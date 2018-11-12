//
//  GFImageCropView.m
//  GetFun
//
//  Created by zhouxiangzhong on 16/7/30.
//  Copyright © 2016年 zhouxiangzhong. All rights reserved.
//

#import "GFImageCropView.h"

#import "RSKTouchView.h"
#import "RSKImageScrollView.h"
#import "RSKInternalUtility.h"
#import "UIImage+RSKImageCropper.h"
#import "CGGeometry+RSKImageCropper.h"
#import "UIApplication+RSKImageCropper.h"

static const CGFloat kResetAnimationDuration = 0.4;
static const CGFloat kLayoutImageScrollViewAnimationDuration = 0.25;

// K is a constant such that the accumulated error of our floating-point computations is definitely bounded by K units in the last place.
#ifdef CGFLOAT_IS_DOUBLE
static const CGFloat kK = 9;
#else
static const CGFloat kK = 0;
#endif

@interface GFImageCropView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) RSKImageScrollView *imageScrollView;
@property (strong, nonatomic) RSKTouchView *overlayView;
@property (strong, nonatomic) CAShapeLayer *maskLayer;

@property (assign, nonatomic) CGRect maskRect;
@property (copy, nonatomic) UIBezierPath *maskPath;

@property (readonly, nonatomic) CGRect rectForMaskPath;
@property (readonly, nonatomic) CGRect rectForClipPath;

@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationGestureRecognizer;

@end

@implementation GFImageCropView
#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        self.avoidEmptySpaceAroundImage = NO;
        self.applyMaskToCroppedImage = NO;
        self.maskLayerLineWidth = 1.0;
        self.rotationEnabled = NO;
        self.cropMode = GFImageCropModeCircle;
        
        self.portraitCircleMaskRectInnerEdgeInset = 15.0f;
        self.portraitSquareMaskRectInnerEdgeInset = 20.0f;
        
        [self addSubview:self.imageScrollView];
        [self addSubview:self.overlayView];
        
        [self addGestureRecognizer:self.doubleTapGestureRecognizer];
        [self addGestureRecognizer:self.rotationGestureRecognizer];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self updateMaskRect];
    [self layoutImageScrollView];
    [self layoutOverlayView];
    [self updateMaskPath];
    [self updateConstraints];
}

- (void)didMoveToSuperview {
    if (!self.imageScrollView.zoomView) {
        [self displayImage];
    }
}

#pragma mark - Custom Accessors
- (RSKImageScrollView *)imageScrollView
{
    if (!_imageScrollView) {
        _imageScrollView = [[RSKImageScrollView alloc] init];
        _imageScrollView.clipsToBounds = NO;
        _imageScrollView.aspectFill = self.avoidEmptySpaceAroundImage;
    }
    return _imageScrollView;
}

- (RSKTouchView *)overlayView
{
    if (!_overlayView) {
        _overlayView = [[RSKTouchView alloc] init];
        _overlayView.receiver = self.imageScrollView;
        [_overlayView.layer addSublayer:self.maskLayer];
    }
    return _overlayView;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        _maskLayer.fillColor = self.maskLayerColor.CGColor;
        _maskLayer.lineWidth = self.maskLayerLineWidth;
        _maskLayer.strokeColor = self.maskLayerStrokeColor.CGColor;
    }
    return _maskLayer;
}

- (UIColor *)maskLayerColor
{
    if (!_maskLayerColor) {
        _maskLayerColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    }
    return _maskLayerColor;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer
{
    if (!_doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapGestureRecognizer.delaysTouchesEnded = NO;
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        _doubleTapGestureRecognizer.delegate = self;
    }
    return _doubleTapGestureRecognizer;
}

- (UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    if (!_rotationGestureRecognizer) {
        _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
        _rotationGestureRecognizer.delaysTouchesEnded = NO;
        _rotationGestureRecognizer.delegate = self;
        _rotationGestureRecognizer.enabled = self.isRotationEnabled;
    }
    return _rotationGestureRecognizer;
}

- (CGRect)cropRect
{
    CGRect cropRect = CGRectZero;
    float zoomScale = 1.0 / self.imageScrollView.zoomScale;
    
    cropRect.origin.x = round(self.imageScrollView.contentOffset.x * zoomScale);
    cropRect.origin.y = round(self.imageScrollView.contentOffset.y * zoomScale);
    cropRect.size.width = CGRectGetWidth(self.imageScrollView.bounds) * zoomScale;
    cropRect.size.height = CGRectGetHeight(self.imageScrollView.bounds) * zoomScale;
    
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    CGFloat ceilWidth = ceil(width);
    CGFloat ceilHeight = ceil(height);
    
    if (fabs(ceilWidth - width) < pow(10, kK) * RSK_EPSILON * fabs(ceilWidth + width) || fabs(ceilWidth - width) < RSK_MIN ||
        fabs(ceilHeight - height) < pow(10, kK) * RSK_EPSILON * fabs(ceilHeight + height) || fabs(ceilHeight - height) < RSK_MIN) {
        
        cropRect.size.width = ceilWidth;
        cropRect.size.height = ceilHeight;
    } else {
        cropRect.size.width = floor(width);
        cropRect.size.height = floor(height);
    }
    
    return cropRect;
}

- (CGRect)rectForClipPath
{
    if (!self.maskLayerStrokeColor) {
        return self.overlayView.frame;
    } else {
        CGFloat maskLayerLineHalfWidth = self.maskLayerLineWidth / 2.0;
        return CGRectInset(self.overlayView.frame, -maskLayerLineHalfWidth, -maskLayerLineHalfWidth);
    }
}

- (CGRect)rectForMaskPath
{
    if (!self.maskLayerStrokeColor) {
        return self.maskRect;
    } else {
        CGFloat maskLayerLineHalfWidth = self.maskLayerLineWidth / 2.0;
        return CGRectInset(self.maskRect, maskLayerLineHalfWidth, maskLayerLineHalfWidth);
    }
}

- (CGFloat)rotationAngle
{
    CGAffineTransform transform = self.imageScrollView.transform;
    CGFloat rotationAngle = atan2(transform.b, transform.a);
    return rotationAngle;
}

- (CGFloat)zoomScale
{
    return self.imageScrollView.zoomScale;
}

- (void)setAvoidEmptySpaceAroundImage:(BOOL)avoidEmptySpaceAroundImage
{
    if (_avoidEmptySpaceAroundImage != avoidEmptySpaceAroundImage) {
        _avoidEmptySpaceAroundImage = avoidEmptySpaceAroundImage;
        
        self.imageScrollView.aspectFill = avoidEmptySpaceAroundImage;
    }
}

- (void)setCropMode:(GFImageCropMode)cropMode
{
    if (_cropMode != cropMode) {
        _cropMode = cropMode;
        
        if (self.imageScrollView.zoomView) {
            [self reset:NO];
        }
    }
}

- (void)setOriginalImage:(UIImage *)originalImage
{
    if (![_originalImage isEqual:originalImage]) {
        _originalImage = originalImage;
        [self displayImage];
    }
}

- (void)setMaskPath:(UIBezierPath *)maskPath
{
    if (![_maskPath isEqual:maskPath]) {
        _maskPath = maskPath;
        
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.rectForClipPath];
        [clipPath appendPath:maskPath];
        clipPath.usesEvenOddFillRule = YES;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = [CATransaction animationDuration];
        pathAnimation.timingFunction = [CATransaction animationTimingFunction];
        [self.maskLayer addAnimation:pathAnimation forKey:@"path"];
        
        self.maskLayer.path = [clipPath CGPath];
    }
}

- (void)setRotationAngle:(CGFloat)rotationAngle
{
    if (self.rotationAngle != rotationAngle) {
        CGFloat rotation = (rotationAngle - self.rotationAngle);
        CGAffineTransform transform = CGAffineTransformRotate(self.imageScrollView.transform, rotation);
        self.imageScrollView.transform = transform;
    }
}

- (void)setRotationEnabled:(BOOL)rotationEnabled
{
    if (_rotationEnabled != rotationEnabled) {
        _rotationEnabled = rotationEnabled;
        
        self.rotationGestureRecognizer.enabled = rotationEnabled;
    }
}

- (void)setZoomScale:(CGFloat)zoomScale
{
    self.imageScrollView.zoomScale = zoomScale;
}

#pragma mark - Action handling
- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self reset:YES];
}

- (void)handleRotation:(UIRotationGestureRecognizer *)gestureRecognizer
{
    [self setRotationAngle:(self.rotationAngle + gestureRecognizer.rotation)];
    gestureRecognizer.rotation = 0;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:kLayoutImageScrollViewAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self layoutImageScrollView];
                         }
                         completion:nil];
    }
}

#pragma mark - Private

- (void)reset:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:@"rsk_reset" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:kResetAnimationDuration];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    [self resetRotation];
    [self resetFrame];
    [self resetZoomScale];
    [self resetContentOffset];
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)resetContentOffset
{
    CGSize boundsSize = self.imageScrollView.bounds.size;
    CGRect frameToCenter = self.imageScrollView.zoomView.frame;
    
    CGPoint contentOffset;
    if (CGRectGetWidth(frameToCenter) > boundsSize.width) {
        contentOffset.x = (CGRectGetWidth(frameToCenter) - boundsSize.width) * 0.5f;
    } else {
        contentOffset.x = 0;
    }
    if (CGRectGetHeight(frameToCenter) > boundsSize.height) {
        contentOffset.y = (CGRectGetHeight(frameToCenter) - boundsSize.height) * 0.5f;
    } else {
        contentOffset.y = 0;
    }
    
    self.imageScrollView.contentOffset = contentOffset;
}

- (void)resetFrame
{
    [self layoutImageScrollView];
}

- (void)resetRotation
{
    [self setRotationAngle:0.0];
}

- (void)resetZoomScale
{
    CGFloat zoomScale;
    if (CGRectGetWidth(self.bounds) > CGRectGetHeight(self.bounds)) {
        zoomScale = CGRectGetHeight(self.bounds) / self.originalImage.size.height;
    } else {
        zoomScale = CGRectGetWidth(self.bounds) / self.originalImage.size.width;
    }
    self.imageScrollView.zoomScale = zoomScale;
}

- (NSArray *)intersectionPointsOfLineSegment:(RSKLineSegment)lineSegment withRect:(CGRect)rect
{
    RSKLineSegment top = RSKLineSegmentMake(CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)),
                                            CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)));
    
    RSKLineSegment right = RSKLineSegmentMake(CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)),
                                              CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)));
    
    RSKLineSegment bottom = RSKLineSegmentMake(CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)),
                                               CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)));
    
    RSKLineSegment left = RSKLineSegmentMake(CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)),
                                             CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)));
    
    CGPoint p0 = RSKLineSegmentIntersection(top, lineSegment);
    CGPoint p1 = RSKLineSegmentIntersection(right, lineSegment);
    CGPoint p2 = RSKLineSegmentIntersection(bottom, lineSegment);
    CGPoint p3 = RSKLineSegmentIntersection(left, lineSegment);
    
    NSMutableArray *intersectionPoints = [@[] mutableCopy];
    if (!RSKPointIsNull(p0)) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p0]];
    }
    if (!RSKPointIsNull(p1)) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p1]];
    }
    if (!RSKPointIsNull(p2)) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p2]];
    }
    if (!RSKPointIsNull(p3)) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p3]];
    }
    
    return [intersectionPoints copy];
}

- (void)displayImage
{
    if (self.originalImage) {
        [self.imageScrollView displayImage:self.originalImage];
        [self reset:NO];
    }
}

- (void)layoutImageScrollView
{
    CGRect frame = CGRectZero;
    
    // The bounds of the image scroll view should always fill the mask area.
    switch (self.cropMode) {
        case GFImageCropModeSquare: {
            if (self.rotationAngle == 0.0) {
                frame = self.maskRect;
            } else {
                // Step 1: Rotate the left edge of the initial rect of the image scroll view clockwise around the center by `rotationAngle`.
                CGRect initialRect = self.maskRect;
                CGFloat rotationAngle = self.rotationAngle;
                
                CGPoint leftTopPoint = CGPointMake(initialRect.origin.x, initialRect.origin.y);
                CGPoint leftBottomPoint = CGPointMake(initialRect.origin.x, initialRect.origin.y + initialRect.size.height);
                RSKLineSegment leftLineSegment = RSKLineSegmentMake(leftTopPoint, leftBottomPoint);
                
                CGPoint pivot = RSKRectCenterPoint(initialRect);
                
                CGFloat alpha = fabs(rotationAngle);
                RSKLineSegment rotatedLeftLineSegment = RSKLineSegmentRotateAroundPoint(leftLineSegment, pivot, alpha);
                
                // Step 2: Find the points of intersection of the rotated edge with the initial rect.
                NSArray *points = [self intersectionPointsOfLineSegment:rotatedLeftLineSegment withRect:initialRect];
                
                // Step 3: If the number of intersection points more than one
                // then the bounds of the rotated image scroll view does not completely fill the mask area.
                // Therefore, we need to update the frame of the image scroll view.
                // Otherwise, we can use the initial rect.
                if (points.count > 1) {
                    // We have a right triangle.
                    
                    // Step 4: Calculate the altitude of the right triangle.
                    if ((alpha > M_PI_2) && (alpha < M_PI)) {
                        alpha = alpha - M_PI_2;
                    } else if ((alpha > (M_PI + M_PI_2)) && (alpha < (M_PI + M_PI))) {
                        alpha = alpha - (M_PI + M_PI_2);
                    }
                    CGFloat sinAlpha = sin(alpha);
                    CGFloat cosAlpha = cos(alpha);
                    CGFloat hypotenuse = RSKPointDistance([points[0] CGPointValue], [points[1] CGPointValue]);
                    CGFloat altitude = hypotenuse * sinAlpha * cosAlpha;
                    
                    // Step 5: Calculate the target width.
                    CGFloat initialWidth = CGRectGetWidth(initialRect);
                    CGFloat targetWidth = initialWidth + altitude * 2;
                    
                    // Step 6: Calculate the target frame.
                    CGFloat scale = targetWidth / initialWidth;
                    CGPoint center = RSKRectCenterPoint(initialRect);
                    frame = RSKRectScaleAroundPoint(initialRect, center, scale, scale);
                    
                    // Step 7: Avoid floats.
                    frame.origin.x = round(CGRectGetMinX(frame));
                    frame.origin.y = round(CGRectGetMinY(frame));
                    frame = CGRectIntegral(frame);
                } else {
                    // Step 4: Use the initial rect.
                    frame = initialRect;
                }
            }
            break;
        }
        case GFImageCropModeCircle: {
            frame = self.maskRect;
            break;
        }
        case GFImageCropModeCustom: {
            if ([self.dataSource respondsToSelector:@selector(imageCropViewCustomMovementRect:)]) {
                frame = [self.dataSource imageCropViewCustomMovementRect:self];
            } else {
                // Will be changed to `CGRectNull` in version `2.0.0`.
                frame = self.maskRect;
            }
            break;
        }
    }
    
    CGAffineTransform transform = self.imageScrollView.transform;
    self.imageScrollView.transform = CGAffineTransformIdentity;
    self.imageScrollView.frame = frame;
    self.imageScrollView.transform = transform;
}

- (void)layoutOverlayView
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 2, CGRectGetHeight(self.bounds) * 2);
    self.overlayView.frame = frame;
}

- (void)updateMaskRect
{
    switch (self.cropMode) {
        case GFImageCropModeCircle: {
            CGFloat viewWidth = CGRectGetWidth(self.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.bounds);
            
            CGFloat diameter;
            diameter = MIN(viewWidth, viewHeight) - self.portraitCircleMaskRectInnerEdgeInset * 2;
            CGSize maskSize = CGSizeMake(diameter, diameter);
            
            self.maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                       (viewHeight - maskSize.height) * 0.5f,
                                       maskSize.width,
                                       maskSize.height);
            break;
        }
        case GFImageCropModeSquare: {
            CGFloat viewWidth = CGRectGetWidth(self.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.bounds);
            
            CGFloat length;
            length = MIN(viewWidth, viewHeight) - self.portraitSquareMaskRectInnerEdgeInset * 2;
            
            CGSize maskSize = CGSizeMake(length, length);
            
            self.maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                       (viewHeight - maskSize.height) * 0.5f,
                                       maskSize.width,
                                       maskSize.height);
            break;
        }
        case GFImageCropModeCustom: {
            self.maskRect = [self.dataSource imageCropViewCustomMaskRect:self];
            break;
        }
    }
}

- (void)updateMaskPath
{
    switch (self.cropMode) {
        case GFImageCropModeCircle: {
            self.maskPath = [UIBezierPath bezierPathWithOvalInRect:self.rectForMaskPath];
            break;
        }
        case GFImageCropModeSquare: {
            self.maskPath = [UIBezierPath bezierPathWithRect:self.rectForMaskPath];
            break;
        }
        case GFImageCropModeCustom: {
            self.maskPath = [self.dataSource imageCropViewCustomMaskPath:self];
            break;
        }
    }
}

- (UIImage *)croppedImage:(UIImage *)image cropRect:(CGRect)cropRect scale:(CGFloat)imageScale orientation:(UIImageOrientation)imageOrientation
{
    if (!image.images) {
        CGImageRef croppedCGImage = CGImageCreateWithImageInRect(image.CGImage, cropRect);
        UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage scale:imageScale orientation:imageOrientation];
        CGImageRelease(croppedCGImage);
        return croppedImage;
    } else {
        UIImage *animatedImage = image;
        NSMutableArray *croppedImages = [NSMutableArray array];
        for (UIImage *image in animatedImage.images) {
            UIImage *croppedImage = [self croppedImage:image cropRect:cropRect scale:imageScale orientation:imageOrientation];
            [croppedImages addObject:croppedImage];
        }
        return [UIImage animatedImageWithImages:croppedImages duration:image.duration];
    }
}

- (UIImage *)croppedImage:(UIImage *)image cropMode:(GFImageCropMode)cropMode cropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle zoomScale:(CGFloat)zoomScale maskPath:(UIBezierPath *)maskPath applyMaskToCroppedImage:(BOOL)applyMaskToCroppedImage
{
    // Step 1: check and correct the crop rect.
    CGSize imageSize = image.size;
    CGFloat x = CGRectGetMinX(cropRect);
    CGFloat y = CGRectGetMinY(cropRect);
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    
    UIImageOrientation imageOrientation = image.imageOrientation;
    if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
        cropRect.origin.x = y;
        cropRect.origin.y = round(imageSize.width - CGRectGetWidth(cropRect) - x);
        cropRect.size.width = height;
        cropRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
        cropRect.origin.x = round(imageSize.height - CGRectGetHeight(cropRect) - y);
        cropRect.origin.y = x;
        cropRect.size.width = height;
        cropRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
        cropRect.origin.x = round(imageSize.width - CGRectGetWidth(cropRect) - x);
        cropRect.origin.y = round(imageSize.height - CGRectGetHeight(cropRect) - y);
    }
    
    CGFloat imageScale = image.scale;
    cropRect = CGRectApplyAffineTransform(cropRect, CGAffineTransformMakeScale(imageScale, imageScale));
    
    // Step 2: create an image using the data contained within the specified rect.
    UIImage *croppedImage = [self croppedImage:image cropRect:cropRect scale:imageScale orientation:imageOrientation];
    
    // Step 3: fix orientation of the cropped image.
    croppedImage = [croppedImage fixOrientation];
    imageOrientation = croppedImage.imageOrientation;
    
    // Step 4: If current mode is `GFImageCropModeSquare` and the image is not rotated
    // or mask should not be applied to the image after cropping and the image is not rotated,
    // we can return the cropped image immediately.
    // Otherwise, we must further process the image.
    if ((cropMode == GFImageCropModeSquare || !applyMaskToCroppedImage) && rotationAngle == 0.0) {
        // Step 5: return the cropped image immediately.
        return croppedImage;
    } else {
        // Step 5: create a new context.
        CGSize maskSize = CGRectIntegral(maskPath.bounds).size;
        CGSize contextSize = CGSizeMake(ceil(maskSize.width / zoomScale),
                                        ceil(maskSize.height / zoomScale));
        UIGraphicsBeginImageContextWithOptions(contextSize, NO, imageScale);
        
        // Step 6: apply the mask if needed.
        if (applyMaskToCroppedImage) {
            // 6a: scale the mask to the size of the crop rect.
            UIBezierPath *maskPathCopy = [maskPath copy];
            CGFloat scale = 1 / zoomScale;
            [maskPathCopy applyTransform:CGAffineTransformMakeScale(scale, scale)];
            
            // 6b: move the mask to the top-left.
            CGPoint translation = CGPointMake(-CGRectGetMinX(maskPathCopy.bounds),
                                              -CGRectGetMinY(maskPathCopy.bounds));
            [maskPathCopy applyTransform:CGAffineTransformMakeTranslation(translation.x, translation.y)];
            
            // 6c: apply the mask.
            [maskPathCopy addClip];
        }
        
        // Step 7: rotate the cropped image if needed.
        if (rotationAngle != 0) {
            croppedImage = [croppedImage rotateByAngle:rotationAngle];
        }
        
        // Step 8: draw the cropped image.
        CGPoint point = CGPointMake(round((contextSize.width - croppedImage.size.width) * 0.5f),
                                    round((contextSize.height - croppedImage.size.height) * 0.5f));
        [croppedImage drawAtPoint:point];
        
        // Step 9: get the cropped image affter processing from the context.
        croppedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // Step 10: remove the context.
        UIGraphicsEndImageContext();
        
        croppedImage = [UIImage imageWithCGImage:croppedImage.CGImage scale:imageScale orientation:imageOrientation];
        
        // Step 11: return the cropped image affter processing.
        return croppedImage;
    }
}

- (void)cropImage
{
    if ([self.delegate respondsToSelector:@selector(imageCropView:willCropImage:)]) {
        [self.delegate imageCropView:self willCropImage:self.originalImage];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect cropRect = self.cropRect;
        CGFloat rotationAngle = self.rotationAngle;
        
        UIImage *croppedImage = [self croppedImage:self.originalImage cropMode:self.cropMode cropRect:cropRect rotationAngle:rotationAngle zoomScale:self.imageScrollView.zoomScale maskPath:self.maskPath applyMaskToCroppedImage:self.applyMaskToCroppedImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(imageCropView:didCropImage:usingCropRect:rotationAngle:)]) {
                [self.delegate imageCropView:self didCropImage:croppedImage usingCropRect:cropRect rotationAngle:rotationAngle];
            } else if ([self.delegate respondsToSelector:@selector(imageCropView:didCropImage:usingCropRect:)]) {
                [self.delegate imageCropView:self didCropImage:croppedImage usingCropRect:cropRect];
            }
        });
    });
}

- (void)cancelCrop
{
    if ([self.delegate respondsToSelector:@selector(imageCropViewDidCancelCrop:)]) {
        [self.delegate imageCropViewDidCancelCrop:self];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end

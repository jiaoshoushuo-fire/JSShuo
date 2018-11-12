//
//  GFImageCropView.h
//  GetFun
//
//  Created by zhouxiangzhong on 16/7/30.
//  Copyright © 2016年 zhouxiangzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GFImageCropViewDataSource;
@protocol GFImageCropViewDelegate;

/**
 Types of supported crop modes.
 */
typedef NS_ENUM(NSUInteger, GFImageCropMode) {
    GFImageCropModeCircle,
    GFImageCropModeSquare,
    GFImageCropModeCustom
};

@interface GFImageCropView : UIView

///-----------------------------
/// @name Accessing the Delegate
///-----------------------------

/**
 The receiver's delegate.
 
 @discussion A `GFImageCropViewDelegate` delegate responds to messages sent by completing / canceling crop the image in the image crop view.
 */
@property (weak, nonatomic, nullable) id<GFImageCropViewDelegate> delegate;

/**
 The receiver's data source.
 
 @discussion A `GFImageCropViewDataSource` data source provides a custom rect and a custom path for the mask.
 */
@property (weak, nonatomic, nullable) id<GFImageCropViewDataSource> dataSource;

///--------------------------
/// @name Accessing the Image
///--------------------------

/**
 The image for cropping.
 */
@property (strong, nonatomic) UIImage *originalImage;

/// -----------------------------------
/// @name Accessing the Mask Attributes
/// -----------------------------------

/**
 The color of the layer with the mask. Default value is [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f].
 */
@property (copy, nonatomic) UIColor *maskLayerColor;

/**
 The line width used when stroking the path of the mask layer. Default value is 1.0.
 */
@property (assign, nonatomic) CGFloat maskLayerLineWidth;

/**
 The color to fill the stroked outline of the path of the mask layer, or nil for no stroking. Default valus is nil.
 */
@property (copy, nonatomic, nullable) UIColor *maskLayerStrokeColor;

/**
 The rect of the mask.
 
 @discussion Updating each time before the crop view lays out its subviews.
 */
@property (assign, readonly, nonatomic) CGRect maskRect;

/**
 The path of the mask.
 
 @discussion Updating each time before the crop view lays out its subviews.
 */
@property (copy, readonly, nonatomic) UIBezierPath *maskPath;

/// -----------------------------------
/// @name Accessing the Crop Attributes
/// -----------------------------------

/**
 The mode for cropping. Default value is `GFImageCropModeCircle`.
 */
@property (assign, nonatomic) GFImageCropMode cropMode;

/**
 The crop rectangle.
 
 @discussion The value is calculated at run time.
 */
@property (readonly, nonatomic) CGRect cropRect;

/**
 A value that specifies the current rotation angle of the image in radians.
 
 @discussion The value is calculated at run time.
 */
@property (readonly, nonatomic) CGFloat rotationAngle;

/**
 A floating-point value that specifies the current scale factor applied to the image.
 
 @discussion The value is calculated at run time.
 */
@property (readonly, nonatomic) CGFloat zoomScale;

/**
 A Boolean value that determines whether the image will always fill the mask space. Default value is `NO`.
 */
@property (assign, nonatomic) BOOL avoidEmptySpaceAroundImage;

/**
 A Boolean value that determines whether the mask applies to the image after cropping. Default value is `NO`.
 */
@property (assign, nonatomic) BOOL applyMaskToCroppedImage;

/**
 A Boolean value that controls whether the rotaion gesture is enabled. Default value is `NO`.
 
 @discussion To support the rotation when `cropMode` is `GFImageCropModeCustom` you must implement the data source method `ImageCropViewCustomMovementRect:`.
 */
@property (assign, getter=isRotationEnabled, nonatomic) BOOL rotationEnabled;

/// -------------------------------------
/// @name Accessing the Layout Attributes
/// -------------------------------------

/**
 The inset of the circle mask rect's area within the crop view's area in portrait orientation. Default value is `15.0f`.
 */
@property (assign, nonatomic) CGFloat portraitCircleMaskRectInnerEdgeInset;

/**
 The inset of the square mask rect's area within the crop view's area in portrait orientation. Default value is `20.0f`.
 */
@property (assign, nonatomic) CGFloat portraitSquareMaskRectInnerEdgeInset;

- (void)cropImage;
- (void)cancelCrop;

@end

/**
 The `GFImageCropViewDataSource` protocol is adopted by an object that provides a custom rect and a custom path for the mask.
 */
@protocol GFImageCropViewDataSource <NSObject>

/**
 Asks the data source a custom rect for the mask.
 
 @param view The crop view object to whom a rect is provided.
 
 @return A custom rect for the mask.
 
 @discussion Only valid if `cropMode` is `GFImageCropModeCustom`.
 */
- (CGRect)imageCropViewCustomMaskRect:(GFImageCropView *)view;

/**
 Asks the data source a custom path for the mask.
 
 @param view The crop view object to whom a path is provided.
 
 @return A custom path for the mask.
 
 @discussion Only valid if `cropMode` is `GFImageCropModeCustom`.
 */
- (UIBezierPath *)imageCropViewCustomMaskPath:(GFImageCropView *)view;

@optional

/**
 Asks the data source a custom rect in which the image can be moved.
 
 @param view The crop view object to whom a rect is provided.
 
 @return A custom rect in which the image can be moved.
 
 @discussion Only valid if `cropMode` is `GFImageCropModeCustom`. If you want to support the rotation  when `cropMode` is `GFImageCropModeCustom` you must implement it. Will be marked as `required` in version `2.0.0`.
 */
- (CGRect)imageCropViewCustomMovementRect:(GFImageCropView *)view;

@end

/**
 The `GFImageCropViewDelegate` protocol defines messages sent to a image crop view delegate when crop image was canceled or the original image was cropped.
 */
@protocol GFImageCropViewDelegate <NSObject>

@optional

/**
 Tells the delegate that crop image has been canceled.
 */
- (void)imageCropViewDidCancelCrop:(GFImageCropView *)view;

/**
 Tells the delegate that the original image will be cropped.
 */
- (void)imageCropView:(GFImageCropView *)view willCropImage:(UIImage *)originalImage;

/**
 Tells the delegate that the original image has been cropped. Additionally provides a crop rect used to produce image.
 */
- (void)imageCropView:(GFImageCropView *)view didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect;

/**
 Tells the delegate that the original image has been cropped. Additionally provides a crop rect and a rotation angle used to produce image.
 */
- (void)imageCropView:(GFImageCropView *)view didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle;

@end

NS_ASSUME_NONNULL_END

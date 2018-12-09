//
//  UIImage+Extension.h
//  Uniwa
//
//  Created by LOFT.LIFE.ZHENG on 15/11/5.
//  Copyright © 2015年 com.zws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageForOSWithName:(NSString *)name;

// 返回一张可以随意拉伸不变形的图片
- (UIImage *)resizableImage;

// 模糊图片
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


- (UIImage *)rescaleImageToSize:(CGSize)size;
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;

// 生成占位图片
+ (UIImage *) placeholderForSize:(CGSize)imageSize;

+ (UIImage *) imageFromWebView:(UIWebView *)view;


// 颜色生成图
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

//
+ (UIImage *)scaledCopyOfSize:(CGSize)newSize image:(UIImage *)image;


// 拍照购所需要的图片尺寸
+ (UIImage *)photographImage:(UIImage *)originImage image:(CGFloat)breadth;


+ (UIImage *)mergeImagesData:(NSArray *)imagesDatas logo:(UIImage *)logo;


- (CGRect)convertCropRect:(CGRect)cropRect;
- (UIImage *)croppedImage:(CGRect)cropRect;
- (UIImage *)resizedImage:(CGSize)size imageOrientation:(UIImageOrientation)imageOrientation;

+ (void)loadWebImage:(NSString *)url completion:(void (^)(UIImage *))completion;

+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;
@end

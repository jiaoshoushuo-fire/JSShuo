//
//  GGPhotoLibrary.h
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef NS_OPTIONS(NSInteger, AssetMediaOption) {
    AssetMediaOptionImage = 1,
    AssetMediaOptionVideo = 1 << 1,
    AssetMediaOptionAll   = AssetMediaOptionVideo | AssetMediaOptionImage
};

@interface GGPhotoLibrary : NSObject

/**
 *  检查相册授权, 不同授权下的提示已在内部做处理，外部只需要根据回调里的status做功能逻辑处理
 */
+ (void)checkAuthorizationCompletion:(void (^)(PHAuthorizationStatus status))completion;

/**
 *  获取相册列表
 */
+ (void)fetchCameraRollMediaOption:(AssetMediaOption)mediaOption completion:(void (^)(PHAssetCollection *collection))completion;

+ (void)fetchAssetCollectionsMediaOption:(AssetMediaOption)mediaOption completion:(void (^)(NSArray<NSDictionary<PHAssetCollection *, NSNumber *> *> *result))completion;

/**
 *  获取相册里的所有照片集合
 */
+ (void)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection completion:(void (^)(PHFetchResult *result))completion;
+ (void)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection mediaOption:(AssetMediaOption)mediaOption completion:(void (^)(PHFetchResult *result))completion;

/**
 *  获取相册缩略图(内部第一个asset的缩略图)
 */
+ (void)requestThumbnailForAssetCollection:(PHAssetCollection *)assetCollection
                                completion:(void (^)(UIImage *image))completion;

+ (void)requestImageForAsset:(PHAsset *)asset
                  preferSize:(CGSize)preferSize
                  completion:(void (^)(UIImage *image, NSDictionary *info))completion;
/**
 *  保存图片到呱呱相册
 */
+ (void)saveImageToCameraRollImage:(UIImage *)image
                         localPath:(NSString *)localPath
                        completion:(void (^)(PHAsset *asset))completion;

+ (NSString *)saveImageDataToTemporaryDirectory:(NSData *)data ext:(NSString *)ext;
+ (NSString *)saveImageToTemporaryDirectory:(UIImage *)image ext:(NSString *)ext;

@end

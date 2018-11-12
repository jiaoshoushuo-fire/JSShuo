//
//  GGPhotoLibrary.m
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import "GGPhotoLibrary.h"
#import "AppDelegate.h"
#import "JSTabBarViewController.h"

@implementation GGPhotoLibrary

+ (void)checkAuthorizationCompletion:(void (^)(PHAuthorizationStatus))completion {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(status);
                    }
                });
            }];
            break;
        }
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied: {
            [self showAuthorizationRestrictedAlertCompletion:completion];
            break;
        }
        case PHAuthorizationStatusAuthorized: {
            if (completion) {
                completion(PHAuthorizationStatusAuthorized);
            }
            break;
        }
    }
}

+ (void)fetchCameraRollMediaOption:(AssetMediaOption)mediaOption completion:(void (^)(PHAssetCollection *))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchResult *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                             subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                             options:nil];
        PHAssetCollection *result = nil;
        for (PHCollection *collection in cameraRoll) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                result = (PHAssetCollection *)collection;
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(result);
            }
        });
    });
}

+ (void)fetchAssetCollectionsMediaOption:(AssetMediaOption)mediaOption completion:(void (^)(NSArray<NSDictionary<PHAssetCollection *,NSNumber *> *> *))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray<NSDictionary<PHAssetCollection *,NSNumber *> *> *result = [self syncFetchAssetCollectionsMediaOption:mediaOption];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(result);
            }
        });
    });
}

+ (void)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection completion:(void (^)(PHFetchResult *))completion {
    [self fetchAssetsInAssetCollection:assetCollection mediaOption:AssetMediaOptionAll completion:completion];
}

+ (void)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection mediaOption:(AssetMediaOption)mediaOption completion:(void (^)(PHFetchResult *))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchResult *result = [self syncFetchAssetsInAssetCollection:assetCollection mediaOption:mediaOption];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(result);
            }
        });
    });
}

+ (void)requestThumbnailForAssetCollection:(PHAssetCollection *)assetCollection
                                completion:(void (^)(UIImage *))completion {
    @weakify(self)
    [self fetchAssetsInAssetCollection:assetCollection completion:^(PHFetchResult *result) {
        @strongify(self)
        if ([result count] > 0) {
            PHAsset *asset = [result firstObject];
            [self requestImageForAsset:asset
                            preferSize:CGSizeMake(320, 320)
                            completion:^(UIImage *image, NSDictionary *info) {
                                if (completion) {
                                    completion(image);
                                }
                            }];
        } else {
            if (completion) {
                completion(nil);
            }
        }
    }];
}

+ (void)requestImageForAsset:(PHAsset *)asset
                  preferSize:(CGSize)preferSize
                  completion:(void (^)(UIImage *, NSDictionary *))completion {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    [[self defaultCachingImageManager] requestImageForAsset:asset
                                                 targetSize:preferSize
                                                contentMode:PHImageContentModeAspectFit
                                                    options:options
                                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                  BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                                                  if (downloadFinined && result && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                                                      if (completion) {
                                                          completion(result,info);
                                                      }
                                                  }
                                              }];
}


+ (void)saveImageToCameraRollImage:(UIImage *)image localPath:(NSString *)localPath completion:(void (^)(PHAsset *))completion {
    
    NSURL *url = [NSURL fileURLWithPath:localPath];
    
    __block NSString *assetId = nil;
    NSError *error;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetChangeRequest *request = nil;
        if (url) {
            request = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:url];
        } else if (image) {
            request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        }
        assetId = request.placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    PHAsset *asset = nil;
    if (assetId) {
        asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
    }
    
    if (completion) {
        completion(asset);
    }
}

+ (NSString *)saveImageToTemporaryDirectory:(UIImage *)image ext:(NSString *)ext {
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    return [self saveImageDataToTemporaryDirectory:data ext:ext];
}

+ (NSString *)saveImageDataToTemporaryDirectory:(NSData *)data ext:(NSString *)ext {
    
    NSString *fileName = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    ext = [ext isNotBlank] ? ext : @"jpg";
    fileName = [NSString stringWithFormat:@"%@.%@", fileName, ext];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
    BOOL result = [data writeToFile:path atomically:YES];
    return result ? path : nil;
}


#pragma mark - private
+ (PHCachingImageManager *)defaultCachingImageManager {
    static PHCachingImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PHCachingImageManager alloc] init];
    });
    return manager;
}

+ (void)showAuthorizationRestrictedAlertCompletion:(void (^)(PHAuthorizationStatus))completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"开启相册权限"
                                                                             message:@"你还没有开启相册权限，开启之后即可选择照片"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"暂不允许"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          if (completion) {
                                                              completion(PHAuthorizationStatusDenied);
                                                          }
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"马上设置"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          if (completion) {
                                                              completion(PHAuthorizationStatusDenied);
                                                          }
                                                          if (SYSTEM_VERSION_NOT_LESS_THAN(@"10.0")) {
                                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                                              
                                                          } else {
                                                              [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                          }
                                                      }]];
//    [GFRedirectCenter redirectToViewController:alertController];
    id currentTabViewController = [[AppDelegate instance].mainViewController selectedViewController];
    UIViewController *topViewController = [self findTopViewController:currentTabViewController];
    [self presentViewController:alertController from:topViewController animated:YES];
}

+ (NSArray<NSDictionary<PHAssetCollection *,NSNumber *> *> *)syncFetchAssetCollectionsMediaOption:(AssetMediaOption)mediaOption {
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 相机胶卷
    {
        PHFetchResult *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                             subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                             options:nil];
        for (PHCollection *collection in cameraRoll) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHFetchResult *assets = [self syncFetchAssetsInAssetCollection:(PHAssetCollection *)collection mediaOption:mediaOption];
                if (assets.count > 0) {
                    NSDictionary *dict = @{collection : @(assets.count)};
                    [result addObject:dict];
                }
            }
        }
    }
    // 其它智能相册
    {
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                              subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                              options:nil];
        for (PHCollection *collection in smartAlbums) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                if (assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) continue;
                
                PHFetchResult *assets = [self syncFetchAssetsInAssetCollection:assetCollection mediaOption:mediaOption];
                if (assets.count > 0) {
                    NSDictionary *dict = @{collection : @(assets.count)};
                    [result addObject:dict];
                }
            }
        }
    }
    // 用户自建相册
    {
        PHFetchResult *topLevelUserCollections = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
        for (PHCollection *collection in topLevelUserCollections) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                
                PHFetchResult *assets = [self syncFetchAssetsInAssetCollection:(PHAssetCollection *)collection mediaOption:mediaOption];
                if (assets.count > 0) {
                    NSDictionary *dict = @{collection : @(assets.count)};
                    [result addObject:dict];
                }
            }
        }
    }
    return result;
}

+ (PHFetchResult *)syncFetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection mediaOption:(AssetMediaOption)mediaOption {
    
    NSLog(@"syncFetchAssetsInAssetCollection:%@", assetCollection.localizedTitle);
    NSLog(@"start time %f", [[NSDate date] timeIntervalSince1970]);
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] initWithCapacity:0];
    if (mediaOption & AssetMediaOptionImage) {
        [mediaTypes addObject:@(PHAssetMediaTypeImage)];
    }
    if (mediaOption & AssetMediaOptionVideo) {
        [mediaTypes addObject:@(PHAssetMediaTypeVideo)];
    }
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", mediaTypes];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    NSLog(@"end time %f", [[NSDate date] timeIntervalSince1970]);
    
    return assetsFetchResult;
}

+ (void)presentViewController:(UIViewController *)destViewController from:(UIViewController *)fromViewController animated:(BOOL)animated {
    
    if (fromViewController.tabBarController) {
        [fromViewController.tabBarController presentViewController:destViewController animated:animated completion:NULL];
    } else if (fromViewController.rt_navigationController) {
        [fromViewController.rt_navigationController presentViewController:destViewController animated:animated completion:NULL];
    } else if (fromViewController.navigationController) {
        [fromViewController.navigationController presentViewController:destViewController animated:animated completion:NULL];
    } else {
        [fromViewController presentViewController:destViewController animated:animated completion:NULL];
    }
}

+ (UIViewController *)findTopViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[JSTabBarViewController class]]) {
        viewController = [(JSTabBarViewController *)viewController selectedViewController];
        return [self findTopViewController:viewController];
    } else if ([viewController isKindOfClass:[RTRootNavigationController class]]) {
        viewController = [[(RTRootNavigationController *)viewController rt_viewControllers] lastObject];
        return [self findTopViewController:viewController];
    } else if ([viewController isKindOfClass:[UIPageViewController class]]) {
        viewController = [[(UIPageViewController *)viewController viewControllers] lastObject];
        return [self findTopViewController:viewController];
    } else {
        if (viewController.presentedViewController) {
            return [self findTopViewController:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }
}
@end

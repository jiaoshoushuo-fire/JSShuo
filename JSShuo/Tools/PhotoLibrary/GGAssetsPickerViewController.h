//
//  GGAssetsPickerViewController.h
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import <RTRootNavigationController/RTRootNavigationController.h>

@class GGAssetsPickerViewController;

@protocol GGAssetPickerViewControllerDelegate <NSObject>
@optional
- (NSString *)picker:(GGAssetsPickerViewController *)picker rightBarButtonItemTitleForViewController:(UIViewController *)viewController;
- (void)picker:(GGAssetsPickerViewController *)picker didSelectAssets:(NSArray<PHAsset *> *)assetsPicked;
- (void)picker:(GGAssetsPickerViewController *)picker didSelectImageAtPath:(NSString *)path;

@end

@interface GGAssetsPickerViewController : RTRootNavigationController

@property (nonatomic, weak)id<GGAssetPickerViewControllerDelegate> pickerDelegate;

@property (nonatomic, assign) BOOL allowTakePhoto;
@property (nonatomic, assign) AssetMediaOption option; // 默认可以选择全部
@property (nonatomic, assign) NSUInteger maxAssetCount; // 默认只能选1

@property (nonatomic, assign) BOOL allowPreviewAndEdit; // 允许预览、编辑（这个参数只对选择一张照片时有效）

@property (nonatomic, strong) NSMutableArray *selectedAssets;

@end

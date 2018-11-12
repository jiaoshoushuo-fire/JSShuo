//
//  GGPhotoLibraryViewController.m
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import "GGPhotoLibraryViewController.h"
#import "GGAssetsPickerViewController.h"
#import "GGCameraViewController.h"
#import "GGPhotoPreviewViewController.h"
#import "JSAdjustButton.h"
#import "GGAssetItemCell.h"
#import "NSString+Path.h"
#import "GGAssetCollectionView.h"

@interface GGPhotoLibraryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) PHFetchResult *assets;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) JSAdjustButton *assetCollectionButton;
@property (nonatomic, strong) UILabel *photoCountLabel;
@property (nonatomic, strong) UIButton *nextStepButton;

@property (nonatomic, strong) GGAssetCollectionView *collectionSelectView;

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@end

@implementation GGPhotoLibraryViewController

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"00bf8f"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton sizeToFit];
    }
    return _cancelButton;
}
- (JSAdjustButton *)assetCollectionButton {
    if (!_assetCollectionButton) {
        _assetCollectionButton = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        _assetCollectionButton.position = JSImagePositionRight;
        _assetCollectionButton.itemSpace = 5.0f;
        [_assetCollectionButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_assetCollectionButton setImage:[UIImage imageNamed:@"nav_publish_arrow_down"] forState:UIControlStateNormal];
        [_assetCollectionButton setImage:[UIImage imageNamed:@"nav_publish_arrow_up"] forState:UIControlStateSelected];
        _assetCollectionButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [_assetCollectionButton sizeToFit];
    }
    return _assetCollectionButton;
}
- (UILabel *)photoCountLabel {
    if (!_photoCountLabel) {
        _photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _photoCountLabel.backgroundColor = [UIColor colorWithHexString:@"00bf8f"];
        _photoCountLabel.layer.masksToBounds = YES;
        _photoCountLabel.layer.cornerRadius = 10;
        _photoCountLabel.font = [UIFont systemFontOfSize:11];
    }
    return _photoCountLabel;
}

- (UIButton *)nextStepButton {
    if (!_nextStepButton) {
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepButton setTitleColor:[UIColor colorWithHexString:@"00bf8f"] forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_nextStepButton setTitle:@"完成" forState:UIControlStateNormal];
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_nextStepButton sizeToFit];
    }
    return _nextStepButton;
}
- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        if (SYSTEM_VERSION_NOT_LESS_THAN(@"9.0")) {
            layout.sectionHeadersPinToVisibleBounds = YES;
        }
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mainCollectionView.alwaysBounceVertical = YES;
        [_mainCollectionView registerClass:[GGAssetItemCell class] forCellWithReuseIdentifier:@"GGAssetItemCell"];
    }
    return _mainCollectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainCollectionView];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    // Do any additional setup after loading the view.
    GGAssetsPickerViewController *picker = (GGAssetsPickerViewController *)self.rt_navigationController;
    if (self.tabBarController) {
        self.mainCollectionView.height = self.view.height - 48 - 64;
    } else {
        self.mainCollectionView.height = self.view.height - 64;
    }
    NSMutableArray *items = [@[
                               [[UIBarButtonItem alloc] initWithCustomView:self.nextStepButton]
                               ] mutableCopy];
    if (picker.option && AssetMediaOptionImage && picker.maxAssetCount > 1) {
        [self updateRightBarItem];
        [items addObject:[[UIBarButtonItem alloc] initWithCustomView:self.photoCountLabel]];
    }
    self.navigationItem.rightBarButtonItems = items;
    
    NSString *rightBarButtonItemTitle = @"完成";
    if ([picker.pickerDelegate respondsToSelector:@selector(picker:rightBarButtonItemTitleForViewController:)]) {
        NSString *title = [picker.pickerDelegate picker:picker rightBarButtonItemTitleForViewController:self];
        if ([title isNotBlank]) {
            rightBarButtonItemTitle = title;
        }
    }
    [self.nextStepButton setTitle:rightBarButtonItemTitle forState:UIControlStateNormal];
    
    [self.cancelButton addTarget:self action:@selector(didSelectCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.assetCollectionButton addTarget:self action:@selector(didSelectAssetCollectionButton) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepButton addTarget:self action:@selector(didSelectNextStepButton) forControlEvents:UIControlEventTouchUpInside];
    
    [GGPhotoLibrary checkAuthorizationCompletion:^(PHAuthorizationStatus status) {
        
        [GGPhotoLibrary fetchCameraRollMediaOption:picker.option completion:^(PHAssetCollection *collection) {
            self.assetCollection = collection;
            [self.assetCollectionButton setTitle:[self assetCollectionTitle:self.assetCollection] forState:UIControlStateNormal];
            self.navigationItem.titleView = self.assetCollectionButton;
            
            [self showWaitingHUD];
            @weakify(self)
            [GGPhotoLibrary fetchAssetsInAssetCollection:self.assetCollection mediaOption:picker.option completion:^(PHFetchResult *result) {
                @strongify(self)
                
                [self hideWaitingHUD];
                self.assets = result;
                [self.mainCollectionView reloadData];
            }];
        }];
    }];
}
- (void)updateRightBarItem {
    
    GGAssetsPickerViewController *picker = (GGAssetsPickerViewController *)self.rt_navigationController;
    
    self.nextStepButton.enabled = (picker.selectedAssets.count > 0);
    self.photoCountLabel.hidden = (picker.selectedAssets.count == 0);
    NSString *text = [NSString stringWithFormat:@"%ld", picker.selectedAssets.count];
    self.photoCountLabel.attributedText = [text attributedStringWithFont:[UIFont boldSystemFontOfSize:16]
                                                                   color:[UIColor whiteColor]
                                                             lineSpacing:0
                                                               alignment:NSTextAlignmentCenter];
}
- (NSString *)assetCollectionTitle:(PHAssetCollection *)assetCollection {
    
    NSString *text = assetCollection.localizedTitle;
    if (assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
        text = @"所有照片";
    };
    return text;
}

#pragma mark - private
- (void)didSelectCancelButton {
    // 这里需要判断self.tabBarController
    GGAssetsPickerViewController *picker = (GGAssetsPickerViewController *)self.rt_navigationController;
    if (self.tabBarController) {
        // 取消发布，在发布页，picker不是present出来的，被present出来的是tabbarcontroller
        [self.tabBarController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        // 取消选择图片，其它情况，picker是被present出来的
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}
- (void)didSelectAssetCollectionButton {
    self.assetCollectionButton.userInteractionEnabled = NO;
    
    if (self.assetCollectionButton.selected) {
        self.assetCollectionButton.selected = NO;
        [self hideCollectionSelectView];
    } else {
        self.assetCollectionButton.selected = YES;
        [self showCollectionSelectView];
    }
}
- (void)didSelectNextStepButton {
    GGAssetsPickerViewController *picker = (GGAssetsPickerViewController *)self.rt_navigationController;
    [picker.pickerDelegate picker:picker didSelectAssets:picker.selectedAssets];
}

- (void)hideCollectionSelectView {
    @synchronized (self) {
        
        if (!self.collectionSelectView) return;
        
        UIViewController *superViewController = self.tabBarController ? self.tabBarController : (self.navigationController ? self.navigationController : self);
        
        [UIView animateWithDuration:0.2f
                         animations:^{
                             self.collectionSelectView.top = superViewController.view.bottom;
                         } completion:^(BOOL finished) {
                             self.assetCollectionButton.userInteractionEnabled = YES;
                             [self.collectionSelectView removeFromSuperview];
                             self.collectionSelectView = nil;
                         }];
    }
}
- (void)showCollectionSelectView {
    @synchronized (self) {
        
        if (self.collectionSelectView) return;
        
        GGAssetsPickerViewController *picker = (GGAssetsPickerViewController *)self.rt_navigationController;
        
        UIViewController *superViewController = self.tabBarController ? self.tabBarController : (self.navigationController ? self.navigationController : self);
        
        self.collectionSelectView = [[GGAssetCollectionView alloc] initWithFrame:CGRectMake(0, 0, superViewController.view.width, superViewController.view.height - 64) mediaOption:picker.option];
        self.collectionSelectView.top = superViewController.view.bottom;
        @weakify(self)
        self.collectionSelectView.assetCollectionHandler = ^(PHAssetCollection *assetCollection) {
            @strongify(self)
            self.assetCollection = assetCollection;
            [self.assetCollectionButton setTitle:[self assetCollectionTitle:self.assetCollection] forState:UIControlStateNormal];
            [self.mainCollectionView scrollToTopAnimated:NO];
            self.assetCollectionButton.selected = NO;
            [self hideCollectionSelectView];
            
            @weakify(self)
            [GGPhotoLibrary fetchAssetsInAssetCollection:assetCollection mediaOption:picker.option completion:^(PHFetchResult *result) {
                @strongify(self)
                self.assets = result;
                [self.mainCollectionView reloadData];
            }];
        };
        [superViewController.view addSubview:self.collectionSelectView];
        [UIView animateWithDuration:0.2f
                         animations:^{
                             self.collectionSelectView.top = 64;
                         } completion:^(BOOL finished) {
                             self.assetCollectionButton.userInteractionEnabled = YES;
                         }];
    }
}


#pragma  mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    GGAssetsPickerViewController *picker = (GGAssetsPickerViewController *)self.rt_navigationController;
    return self.assets.count + (picker.allowTakePhoto ? 1 : 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.5f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.5f;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GGAssetItemCell *cell = [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:@"GGAssetItemCell" forIndexPath:indexPath];
    
    GGAssetsPickerViewController *picker = (GGAssetsPickerViewController *)self.rt_navigationController;
    if (indexPath.item == 0 && picker.allowTakePhoto) {
        [cell bindWithModel:nil];
        [cell markCheck:NO];
    } else {
        GGAssetsPickerViewController *picker = (GGAssetsPickerViewController *)self.rt_navigationController;
        PHAsset *asset = [self.assets objectAtIndex:indexPath.item - (picker.allowTakePhoto ? 1 : 0)];
        [cell bindWithModel:asset];
        [cell markCheck:[picker.selectedAssets containsObject:asset]];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [GGAssetItemCell sizeWithModel:nil];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    @synchronized (self) {
        
        GGAssetsPickerViewController *picker = (GGAssetsPickerViewController *)self.rt_navigationController;
        if (indexPath.item == 0 && picker.allowTakePhoto) {
            GGCameraViewController *cameraViewController = [[GGCameraViewController alloc] init];
            cameraViewController.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:cameraViewController animated:YES complete:NULL];
        } else {
            GGAssetItemCell *cell = (GGAssetItemCell *)[self.mainCollectionView cellForItemAtIndexPath:indexPath];
            PHAsset *asset = (PHAsset *)cell.model;
            
            if ([picker.selectedAssets containsObject:asset]) {
                [picker.selectedAssets removeObject:asset];
                [cell markCheck:NO];
            } else {
                PHAsset *lastAsset = [picker.selectedAssets lastObject];
                if (!lastAsset) { // 未添加过
                    if (asset.mediaType == PHAssetMediaTypeVideo) {
                        [picker.pickerDelegate picker:picker didSelectAssets:@[asset]];
                    } else {
                        if (picker.maxAssetCount == 1) {
                            if (picker.allowPreviewAndEdit) {
                                GGPhotoPreviewViewController *previewViewController = [[GGPhotoPreviewViewController alloc] initWithAsset:asset];
                                [self.rt_navigationController pushViewController:previewViewController animated:YES complete:NULL];
                            } else {
                                [picker.pickerDelegate picker:picker didSelectAssets:@[asset]];
                            }
                        } else {
                            [picker.selectedAssets addObject:asset];
                            [cell markCheck:YES];
                        }
                    }
                } else { // 已经添加过，原有的肯定是图片
                    if (asset.mediaType == PHAssetMediaTypeVideo) {
                        [self showAutoDismissTextAlert:@"不能同时选择照片和视频"];
                    } else {
                        if (picker.selectedAssets.count < picker.maxAssetCount) {
                            [picker.selectedAssets addObject:asset];
                            [cell markCheck:YES];
                        } else {
                            [self showAutoDismissTextAlert:[NSString stringWithFormat:@"最多选择%lu张照片", (unsigned long)picker.maxAssetCount]];
                        }
                    }
                }
            }
            [self updateRightBarItem]; // 选择或取消选择时，更新右上角计数
        }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

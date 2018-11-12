//
//  GGPhotoPreviewViewController.m
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import "GGPhotoPreviewViewController.h"
#import "GGAssetsPickerViewController.h"
#import "GFImageCropView.h"

@interface GGPhotoPreviewViewController ()<GFImageCropViewDataSource,
GFImageCropViewDelegate>

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *fullImage;

@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, strong) GFImageCropView *imageCropView;

@end

@implementation GGPhotoPreviewViewController

- (UIButton *)nextStepButton {
    if (!_nextStepButton) {
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepButton setTitleColor:[UIColor colorWithHexString:@"00bf8f"] forState:UIControlStateNormal];
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _nextStepButton;
}

- (GFImageCropView *)imageCropView {
    if (!_imageCropView) {
        _imageCropView = [[GFImageCropView alloc] initWithFrame:self.view.bounds];
        _imageCropView.avoidEmptySpaceAroundImage = YES;
        _imageCropView.cropMode = GFImageCropModeCustom;
        _imageCropView.delegate = self;
        _imageCropView.dataSource = self;
    }
    return _imageCropView;
}
- (instancetype)initWithAsset:(PHAsset *)asset {
    if (self = [super init]) {
        self.asset = asset;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.fullImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    GGAssetsPickerViewController *picker = (GGAssetsPickerViewController *)self.rt_navigationController;
    NSString *rightBarButtonItemTitle = @"完成";
    if ([picker.pickerDelegate respondsToSelector:@selector(picker:rightBarButtonItemTitleForViewController:)]) {
        NSString *title = [picker.pickerDelegate picker:picker rightBarButtonItemTitleForViewController:self];
        if ([title isNotBlank]) {
            rightBarButtonItemTitle = title;
        }
    }
    [self.nextStepButton setTitle:rightBarButtonItemTitle forState:UIControlStateNormal];
    [self.nextStepButton sizeToFit];
    [self.nextStepButton addTarget:self action:@selector(didSelectNextStepButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextStepButton];
    
    [self.view addSubview:self.imageCropView];
    
    if (self.fullImage) {
        self.imageCropView.originalImage = self.fullImage;
    } else if (self.asset) {
        @weakify(self)
        [GGPhotoLibrary requestImageForAsset:self.asset preferSize:CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight) completion:^(UIImage *image, NSDictionary *info) {
            @strongify(self)
            self.fullImage = image;
            self.imageCropView.originalImage = image;
        }];
    }
}
- (void)didSelectNextStepButton {
    [self.imageCropView cropImage];
}

#pragma mark - GFImageCropViewDataSource
- (CGRect)imageCropViewCustomMaskRect:(GFImageCropView *)view {
    CGFloat width = self.view.width;
    CGFloat height = width;
    CGFloat x = 0;
    CGFloat y = (self.view.height - height) / 2.0f;
    return CGRectMake(x, y, width, height);
}

- (UIBezierPath *)imageCropViewCustomMaskPath:(GFImageCropView *)view {
    CGFloat width = self.view.width;
    CGFloat height = width;
    CGFloat x = 0;
    CGFloat y = (self.view.height - height) / 2.0f;
    CGRect pathRect = CGRectMake(x, y, width, height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:pathRect];
    return path;
}

#pragma mark - GFImageCropViewDelegate
- (void)imageCropView:(GFImageCropView *)view didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    
    NSString *path = [GGPhotoLibrary saveImageToTemporaryDirectory:croppedImage ext:nil];
    if ([path isNotBlank]) {
        GGAssetsPickerViewController *nav = (GGAssetsPickerViewController *)self.rt_navigationController;
        if ([nav.pickerDelegate respondsToSelector:@selector(picker:didSelectImageAtPath:)]) {
            [nav.pickerDelegate picker:nav didSelectImageAtPath:path];
        }
    } else {
        [self showAutoDismissTextAlert:@"图片保存失败"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  GGCameraViewController.m
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import "GGCameraViewController.h"
#import "GGPhotoPreviewViewController.h"
#import <FastttCamera.h>

static CGFloat const kEdgePadding = 10.0f;


@interface GGCameraViewController ()<FastttCameraDelegate>
@property (nonatomic, strong) FastttCamera *fastCamera;
//@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *torchButton;
@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) UIImageView *shutterBackground;
@property (nonatomic, strong) UIButton *shutterButton;

@property (nonatomic, strong) UIImageView *previewImageView;
@end

@implementation GGCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拍照";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAVCaptureSessionStartRunning:) name:AVCaptureSessionDidStartRunningNotification object:nil];
    
    if (!self.fastCamera) {
        self.fastCamera = [[FastttCamera alloc] init];
        self.fastCamera.delegate = self;
        [self.fastCamera setCameraTorchMode:FastttCameraTorchModeOff];
        [self.fastCamera setCameraDevice:FastttCameraDeviceRear];
        [self fastttAddChildViewController:self.fastCamera];
//        self.fastCamera.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
        [self.fastCamera.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self)
    if (!self.torchButton) {
        self.torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.torchButton setImage:[UIImage imageNamed:@"camera_flash_normal"] forState:UIControlStateNormal];
        [self.torchButton setImage:[UIImage imageNamed:@"camera_flash_selected"] forState:UIControlStateSelected];
        [self.torchButton sizeToFit];
        self.torchButton.center = CGPointMake(kEdgePadding + self.torchButton.width/2,
                                              self.view.height - kEdgePadding - self.torchButton.height/2);
        [self.view addSubview:self.torchButton];
        
        [self.torchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(36, 36));
            make.left.equalTo(self.view).offset(10);
            make.bottom.equalTo(self.view).offset(-10);
        }];
        self.torchButton.hidden = YES;
        [self.torchButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            FastttCameraTorchMode torchMode;
            if (self.fastCamera.cameraTorchMode == FastttCameraTorchModeOn) {
                torchMode = FastttCameraTorchModeOff;
            } else {
                torchMode = FastttCameraTorchModeOn;
            }
            [self.fastCamera setCameraTorchMode:torchMode];
            self.torchButton.selected = (torchMode == FastttCameraTorchModeOn);
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.switchCameraButton) {
        self.switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.switchCameraButton setImage:[UIImage imageNamed:@"camera_switch"] forState:UIControlStateNormal];
        [self.switchCameraButton sizeToFit];
        self.switchCameraButton.center = CGPointMake(self.view.width - kEdgePadding - self.switchCameraButton.width/2,
                                                     self.view.bottom - kEdgePadding - self.switchCameraButton.height/2);
        [self.view addSubview:self.switchCameraButton];
        [self.switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(36, 36));
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view).offset(-10);
        }];
        self.switchCameraButton.hidden = YES;
        [self.switchCameraButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            // 切换前后摄像头的时候，把电筒和闪光灯关闭
            if (self.fastCamera.isTorchAvailableForCurrentDevice) {
                self.fastCamera.cameraTorchMode = FastttCameraTorchModeOff;
                self.torchButton.selected = NO;
            }
            
            FastttCameraDevice cameraDevice;
            switch (self.fastCamera.cameraDevice) {
                case FastttCameraDeviceFront:
                    cameraDevice = FastttCameraDeviceRear;
                    break;
                case FastttCameraDeviceRear:
                default:
                    cameraDevice = FastttCameraDeviceFront;
                    break;
            }
            self.fastCamera.cameraDevice = cameraDevice;
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.shutterBackground) {
        self.shutterBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_shutter_bg"]];
        [self.shutterBackground sizeToFit];
        
        CGFloat tabbarHeight = self.tabBarController ? 48 : 0;
        self.shutterBackground.center = CGPointMake(self.view.width/2, self.view.bottom + (kScreenHeight - self.view.bottom - tabbarHeight) / 2);
        self.shutterBackground.bottom = self.view.height;
        [self.view addSubview:self.shutterBackground];
        [self.shutterBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(85, 85));
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        self.shutterBackground.hidden = YES;
    }
    
    if (!self.shutterButton) {
        self.shutterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shutterButton setImage:[UIImage imageNamed:@"camera_shutter_normal"] forState:UIControlStateNormal];
        [self.shutterButton sizeToFit];
        self.shutterButton.center = self.shutterBackground.center;
        [self.view addSubview:self.shutterButton];
        [self.shutterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(69, 69));
            make.centerX.mas_equalTo(self.shutterBackground.mas_centerX);
            make.centerY.mas_equalTo(self.shutterBackground.mas_centerY);
        }];
        self.shutterButton.hidden = YES;
        [self.shutterButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            [self.fastCamera takePicture];
            [UIView animateWithDuration:0.2f animations:^{
                self.shutterButton.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f animations:^{
                    self.shutterButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                }];
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中允许叫兽说使用相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureSessionDidStartRunningNotification object:nil];
    //    self.flashButton.hidden =
    self.torchButton.hidden =
    self.switchCameraButton.hidden =
    self.shutterBackground.hidden =
    self.shutterButton.hidden = YES;
    
    if (self.previewImageView) {
        [self.previewImageView removeFromSuperview];
        self.previewImageView = nil;
    }
}

- (void)didAVCaptureSessionStartRunning:(NSNotification *)notification {
    
    self.torchButton.hidden = ![self.fastCamera isTorchAvailableForCurrentDevice];
    //    self.flashButton.hidden =
    self.switchCameraButton.hidden =
    self.shutterBackground.hidden =
    self.shutterButton.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IFTTTFastttCameraDelegate
- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishCapturingImage:(FastttCapturedImage *)capturedImage {
    
    //    UIView *flashView = [[UIView alloc] initWithFrame:self.fastCamera.view.frame];
    //    flashView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f];
    //    flashView.alpha = 0.f;
    //    [self.view addSubview:flashView];
    //
    //    [UIView animateWithDuration:0.15f
    //                          delay:0
    //                        options:UIViewAnimationOptionCurveEaseIn
    //                     animations:^{
    //                         flashView.alpha = 1.0f;
    //                     } completion:^(BOOL finished) {
    //
    //                         self.previewImageView = [[UIImageView alloc] initWithFrame:flashView.frame];
    //                         self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    //                         self.previewImageView.image = capturedImage.rotatedPreviewImage;
    //                         [self.view insertSubview:self.previewImageView belowSubview:flashView];
    //
    //                         [UIView animateWithDuration:0.15f
    //                                               delay:0.05f
    //                                             options:UIViewAnimationOptionCurveEaseOut
    //                                          animations:^{
    //                                              flashView.alpha = 0;
    //                                          } completion:^(BOOL finished) {
    //                                              [flashView removeFromSuperview];
    //                                          }];
    //                     }];
}

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage {
    GGPhotoPreviewViewController *previewViewController = [[GGPhotoPreviewViewController alloc] initWithImage:capturedImage.fullImage];
    previewViewController.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:previewViewController animated:YES complete:NULL];
}


@end

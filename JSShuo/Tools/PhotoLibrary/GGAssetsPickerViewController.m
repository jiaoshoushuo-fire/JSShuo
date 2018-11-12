//
//  GGAssetsPickerViewController.m
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import "GGAssetsPickerViewController.h"
#import "GGPhotoLibraryViewController.h"

@interface GGAssetsPickerViewController ()

@end

@implementation GGAssetsPickerViewController

- (instancetype)init{
    if (self = [super init]) {
        self.allowTakePhoto = NO;
        self.option = AssetMediaOptionAll;
        self.maxAssetCount = 1;
        self.selectedAssets = [NSMutableArray array];
        
        GGPhotoLibraryViewController *photoLibraryViewController = [[GGPhotoLibraryViewController alloc]init];
        self.viewControllers = @[photoLibraryViewController];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

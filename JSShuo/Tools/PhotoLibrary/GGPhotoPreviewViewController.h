//
//  GGPhotoPreviewViewController.h
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import "JSBaseViewController.h"

@interface GGPhotoPreviewViewController : JSBaseViewController

- (instancetype)initWithAsset:(PHAsset *)asset;
- (instancetype)initWithImage:(UIImage *)image;

@end

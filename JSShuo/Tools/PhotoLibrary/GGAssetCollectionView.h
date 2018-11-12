//
//  GGAssetCollectionView.h
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGAssetCollectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame mediaOption:(AssetMediaOption)mediaOption;

@property (nonatomic, copy) void (^assetCollectionHandler)(PHAssetCollection *);

@end

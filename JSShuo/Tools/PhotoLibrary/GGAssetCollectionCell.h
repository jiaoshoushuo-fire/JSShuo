//
//  GGAssetCollectionCell.h
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGAssetCollectionCell : UICollectionViewCell

+ (CGSize)sizeWithModel:(id)model;

- (void)bindWithModel:(id)model count:(NSInteger)count;
@end

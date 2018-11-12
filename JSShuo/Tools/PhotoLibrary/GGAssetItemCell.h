//
//  GGAssetItemCell.h
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGAssetItemCell : UICollectionViewCell

@property (nonatomic, strong) id model;
- (void)markCheck:(BOOL)check;
- (void)bindWithModel:(id)model;
+ (CGSize)sizeWithModel:(id)model;
@end

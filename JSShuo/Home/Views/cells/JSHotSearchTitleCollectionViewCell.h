//
//  JSHotSearchTitleCollectionViewCell.h
//  JSShuo
//
//  Created by li que on 2018/11/16.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSHotSearchTitleCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *numberLable;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSDictionary *modelDic;

@end

NS_ASSUME_NONNULL_END

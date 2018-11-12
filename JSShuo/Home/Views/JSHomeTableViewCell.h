//
//  JSHomeTableViewCell.h
//  JSShuo
//
//  Created by li que on 2018/11/7.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSHomeModel.h"
#import "JSCellBottomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSHomeTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
//* 大图
@property (nonatomic,strong) UIImageView *bigImageView;
//* 小图
@property (nonatomic,strong) UIImageView *smallImageView;
//* 三图
@property (nonatomic,strong) UIView *threeContentView;

// 底部的视图
@property (nonatomic,strong) JSCellBottomView *bottomView;


@property (nonatomic,strong) JSHomeModel *model;


@end

NS_ASSUME_NONNULL_END

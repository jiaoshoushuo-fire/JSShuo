//
//  JSCircleThreePictureTableViewCell.h
//  JSShuo
//
//  Created by li que on 2019/2/1.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCircleBottomView.h"
//#import "JSCircleListModel.h"
#import "JSCircleRootCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCircleThreePictureTableViewCell : JSCircleRootCell

/** 用户头像 **/
@property (nonatomic,strong) UIImageView *headView;
/** 昵称 **/
@property (nonatomic,strong) UILabel *nicknameLabel;
/** 标题 **/
@property (nonatomic,strong) UILabel *titleLabel;
/** 详情标题 **/
@property (nonatomic,strong) UILabel *subtitleLabel;
/** 用户上传的图片 **/
@property (nonatomic,strong) UIImageView *userPostImageView1;
@property (nonatomic,strong) UIImageView *userPostImageView2;
@property (nonatomic,strong) UIImageView *userPostImageView3;
/** cell底部的一排 **/
@property (nonatomic,strong) JSCircleBottomView *bottomView;

//@property (nonatomic,strong) JSCircleListModel *model;

@end

NS_ASSUME_NONNULL_END

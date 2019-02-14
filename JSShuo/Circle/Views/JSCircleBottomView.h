//
//  JSCircleBottomView.h
//  JSShuo
//
//  Created by li que on 2019/2/1.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCircleListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCircleBottomView : UIView

@property (nonatomic,strong) UILabel *hotLabel;// 置顶label
@property (nonatomic,strong) UIImageView *commitCountImg;// 评论
@property (nonatomic,strong) UILabel *commitCountLabel;// 评论数量
@property (nonatomic,strong) UIImageView *praiseCountImg;// 点赞
@property (nonatomic,strong) UILabel *praiseCountLabel; // 点赞数量
@property (nonatomic,strong) UILabel *timeLabel;// 发布时间
@property (nonatomic,strong) JSCircleListModel *model;


@end

NS_ASSUME_NONNULL_END

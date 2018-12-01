//
//  JSCommentTableViewCell.h
//  JSShuo
//
//  Created by li que on 2018/11/19.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCommentListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCommentTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headerImgView;
/** 用户头像 */
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *createTimeLabel;
@property (nonatomic,strong) UILabel *mainContentLabel;
@property (nonatomic,strong) UIView *bottomLineView;
/** 最后布局 */
@property (nonatomic,strong) UIView *bigContentView;

@property (nonatomic,strong) JSCommentListModel *model;

@property (nonatomic,assign) CGFloat replayHeight;

@end

NS_ASSUME_NONNULL_END

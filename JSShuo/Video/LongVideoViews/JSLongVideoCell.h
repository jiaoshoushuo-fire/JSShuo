//
//  JSLongVideoView.h
//  JSShuo
//
//  Created by li que on 2018/11/5.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSLongVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSLongVideoCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *playerIconImg;
@property (nonatomic,strong) UILabel *hotLabel;// 置顶label
@property (nonatomic,strong) UILabel *sourceLabel;
@property (nonatomic,strong) UILabel *releaseTimeLabel;
@property (nonatomic,strong) UILabel *videoTimeLabel;
@property (nonatomic,strong) UIImageView *praiseCountImg;
@property (nonatomic,strong) UILabel *praiseCountLabel;
@property (nonatomic,strong) UIImageView *commitCountImg;
@property (nonatomic,strong) UILabel *commitCountLabel;

@property (nonatomic,strong) JSLongVideoModel *model;

@end

NS_ASSUME_NONNULL_END

//
//  JSCircleMyTableViewCell.h
//  JSShuo
//
//  Created by li que on 2019/2/14.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCircleListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCircleMyTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) JSCircleListModel *model;

@end

NS_ASSUME_NONNULL_END

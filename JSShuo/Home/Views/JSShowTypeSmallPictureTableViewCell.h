//
//  JSShowTypeSmallPictureTableViewCell.h
//  JSShuo
//
//  Created by li que on 2018/11/9.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSHomeModel.h"
#import "JSCellBottomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSShowTypeSmallPictureTableViewCell : UITableViewCell

/** 标题 */
@property (nonatomic,strong) UILabel *titleLabel;
/** 小图 */
@property (nonatomic,strong) UIImageView *smallImageView;
/** 底部的视图 */
@property (nonatomic,strong) JSCellBottomView *bottomView;
/** model */
@property (nonatomic,strong) JSHomeModel *model;

@end

NS_ASSUME_NONNULL_END

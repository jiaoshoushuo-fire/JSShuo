//
//  JSShowTypeThreePictureTableViewCell.h
//  JSShuo
//
//  Created by li que on 2018/11/9.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSHomeModel.h"
#import "JSCellBottomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSShowTypeThreePictureTableViewCell : UITableViewCell

/** 标题 */
@property (nonatomic,strong) UILabel *titleLabel;
/** 底部的视图 */
@property (nonatomic,strong) JSCellBottomView *bottomView;
/** model */
@property (nonatomic,strong) JSHomeModel *model;
///** 三张图的父视图 */
//@property (nonatomic,strong) UIView *fatherContentView;
///** 三个子视图 */
//@property (nonatomic,strong) UIImageView *firstImgView;
//@property (nonatomic,strong) UIImageView *secondImgView;
//@property (nonatomic,strong) UIImageView *thirdImgView;

@end

NS_ASSUME_NONNULL_END

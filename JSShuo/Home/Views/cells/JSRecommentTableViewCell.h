//
//  JSRecommentTableViewCell.h
//  JSShuo
//
//  Created by li que on 2018/11/19.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSRecommendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSRecommentTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UIImageView *commentImgView;
@property (nonatomic,strong) UILabel *commentNumLabel;
@property (nonatomic,strong) UIView *bottomLineView;

@property (nonatomic,strong) JSRecommendModel *model;

@end

NS_ASSUME_NONNULL_END

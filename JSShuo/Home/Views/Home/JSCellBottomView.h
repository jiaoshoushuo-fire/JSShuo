//
//  JSCellBottomView.h
//  JSShuo
//
//  Created by li que on 2018/11/7.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSHomeModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JSCellBottomView : UIView

@property (nonatomic,strong) UILabel *hotLabel;// 置顶label
@property (nonatomic,strong) UILabel *sourceLabel;
@property (nonatomic,strong) UILabel *releaseTimeLabel;
@property (nonatomic,strong) UILabel *videoTimeLabel;
@property (nonatomic,strong) UIImageView *praiseCountImg;
@property (nonatomic,strong) UILabel *praiseCountLabel;
@property (nonatomic,strong) UIImageView *commitCountImg;
@property (nonatomic,strong) UILabel *commitCountLabel;

- (instancetype) initWithModel:(JSHomeModel *)model;

@end

NS_ASSUME_NONNULL_END

//
//  JSSearchNormalView.h
//  JSShuo
//
//  Created by li que on 2018/11/15.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSSearchNormalView : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *articleImgView;
@property (nonatomic,strong) UILabel *articleLabel;
@property (nonatomic,strong) UIImageView *videoImgView;
@property (nonatomic,strong) UILabel *videoLabel;
/** 大家在看 */
@property (nonatomic,strong) UILabel *ourWatchLabel;
@property (nonatomic,strong) UIView *bottomLine;

@end

NS_ASSUME_NONNULL_END

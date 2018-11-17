//
//  JSHomeTableViewCell.m
//  JSShuo
//
//  Created by li que on 2018/11/7.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSHomeTableViewCell.h"
#import "JSCellBottomView.h"

@interface ThreeContentView : UIView
@property (nonatomic,strong) UIImageView *firstImgView;
@property (nonatomic,strong) UIImageView *secondImgView;
@property (nonatomic,strong) UIImageView *thirdImgView;
@end

@implementation ThreeContentView

- (UIImageView *)firstImgView {
    if (!_firstImgView) {
        _firstImgView = [[UIImageView alloc] init];
        _firstImgView.backgroundColor = [UIColor cyanColor];
    }
    return _firstImgView;
}

- (UIImageView *)secondImgView {
    if (!_secondImgView) {
        _secondImgView = [[UIImageView alloc] init];
        _secondImgView.backgroundColor = [UIColor cyanColor];
    }
    return _secondImgView;
}

- (UIImageView *)thirdImgView {
    if (!_thirdImgView) {
        _thirdImgView = [[UIImageView alloc] init];
        _thirdImgView.backgroundColor = [UIColor cyanColor];
    }
    return _thirdImgView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.firstImgView];
        [self addSubview:self.secondImgView];
        [self addSubview:self.thirdImgView];
        CGFloat gap = 10;
        CGFloat width = (ScreenWidth - 2*15 - 2*gap ) / 3;
        CGFloat height = width*9 / 16;
        [self.firstImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        [self.secondImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImgView.mas_right).offset(gap);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.mas_equalTo(self.firstImgView.mas_centerY);
        }];
        [self.thirdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.secondImgView.mas_right).offset(gap);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.mas_equalTo(self.firstImgView.mas_centerY);
        }];
    }
    return self;
}

@end


@interface JSHomeTableViewCell()

@end

@implementation JSHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)setModel:(JSHomeModel *)model {
    _model = model;
    
    if (model.showType.intValue == 1) { // 大图
         // 标题
        self.titleLabel.preferredMaxLayoutWidth = ScreenWidth-30;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(9);
            make.left.mas_equalTo(15);
//            make.size.mas_equalTo(CGSizeMake(ScreenWidth-30, 22));
            make.right.mas_equalTo(-15);
        }];
        // 图片
        [self.contentView addSubview:self.bigImageView];
        [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(ScreenWidth - 30);
            make.height.mas_equalTo(self.bigImageView.mas_width).multipliedBy(9.0f/16.0f);
            make.left.mas_equalTo(15);
        }];
        // 底部
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bigImageView.mas_bottom).offset(0); // bottomView自带上边间隙
            make.left.mas_equalTo(0);
//            make.height.mas_equalTo(9+25+2);
            make.bottom.mas_equalTo(self.contentView).offset(-9-25-2).priorityHigh();
            make.right.mas_equalTo(0);
        }];
    } else if (model.showType.intValue == 2) { // 单图
        // 图片
        [self.contentView addSubview:self.smallImageView];
        [self.smallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(9);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(self.smallImageView.mas_width).multipliedBy(9.0/16.0);
        }];
        // 标题
        self.titleLabel.preferredMaxLayoutWidth = ScreenWidth-30-10-120;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(9);
            make.right.mas_equalTo(self.smallImageView.mas_left).offset(-10);
        }];
        // 底部
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.smallImageView.mas_bottom).offset(0); // bottomView自带上边间隙
            make.left.mas_equalTo(0);
//            make.height.mas_equalTo(9+25+2);
            make.bottom.mas_equalTo(self.contentView).offset(-9-25-2).priorityHigh();
            make.right.mas_equalTo(0);
        }];
    } else if (model.showType.intValue == 3) { // 三图
        // 标题
        self.titleLabel.preferredMaxLayoutWidth = ScreenWidth-30;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(9);
            make.left.mas_equalTo(15);
            //            make.size.mas_equalTo(CGSizeMake(ScreenWidth-30, 22));
            make.right.mas_equalTo(-15);
        }];
        // 图片
        ThreeContentView *threeContentView = [[ThreeContentView alloc] init];
        CGFloat width = (ScreenWidth - 2*15 - 2*10 ) / 3;
        CGFloat height = width*9 / 16;
        [self addSubview:threeContentView];
        [threeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
            // 这个高度要和上面设置的一样高
            make.height.mas_equalTo(height);
        }];
        // 底部
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(threeContentView.mas_bottom).offset(0); // bottomView自带上边间隙
            make.left.mas_equalTo(0);
//            make.height.mas_equalTo(9+25+2);
            make.bottom.mas_equalTo(self.contentView).offset(-9-25-2).priorityHigh();
            make.right.mas_equalTo(0);
        }];
    }
    _titleLabel.text = model.title.length ? model.title : model.Description;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _titleLabel.numberOfLines = 0;
        //设置huggingPriority
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _titleLabel;
}

- (UIImageView *)bigImageView {
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc] init];
        _bigImageView.backgroundColor = [UIColor cyanColor];
    }
    return _bigImageView;
}

- (UIImageView *)smallImageView {
    if (!_smallImageView) {
        _smallImageView = [[UIImageView alloc] init];
        _smallImageView.backgroundColor = [UIColor cyanColor];
    }
    return _smallImageView;
}

- (JSCellBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[JSCellBottomView alloc] initWithModel:self.model];
    }
    return _bottomView;
}


@end

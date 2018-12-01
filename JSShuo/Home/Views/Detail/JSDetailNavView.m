//
//  JSDetailNavView.m
//  JSShuo
//
//  Created by li que on 2018/11/20.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSDetailNavView.h"

@implementation JSDetailNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backBtn];
        [self addSubview:self.titleLabel];
        [self addSubview:self.awardView];
        [self addSubview:self.bottomLine];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(9, 16));
            make.top.mas_equalTo(20+(44-16)*0.5);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backBtn);
            make.height.mas_equalTo(22);
            make.centerX.mas_equalTo(self);
        }];
        [self.awardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 22));
            make.centerY.mas_equalTo(self.backBtn);
            make.right.mas_equalTo(-15);
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-1);
            make.height.mas_equalTo(1);
            make.left.right.mas_equalTo(0);
        }];
    }
    return self;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"searchBack"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)awardView {
    if (!_awardView) {
        _awardView = [[UIView alloc] init];
        _awardView.backgroundColor = [UIColor colorWithHexString:@"000000"];
    }
    return _awardView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    }
    return _bottomLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

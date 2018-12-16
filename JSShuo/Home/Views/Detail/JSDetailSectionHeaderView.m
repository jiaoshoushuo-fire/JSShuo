//
//  JSDetailSectionHeaderView.m
//  JSShuo
//
//  Created by li que on 2018/12/10.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSDetailSectionHeaderView.h"

@implementation JSDetailSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.grayLineView];
        [self addSubview:self.colorLineView];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(56);
            make.left.mas_equalTo(15);
        }];
        [self.colorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(self.titleLabel);
            make.left.mas_equalTo(15);
        }];
        [self.grayLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.colorLineView);
            make.left.mas_equalTo(self.titleLabel);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

-(UIView *)colorLineView {
    if (!_colorLineView) {
        _colorLineView = [[UIView alloc] init];
        _colorLineView.backgroundColor = [UIColor colorWithHexString:@"F44336"];
    }
    return _colorLineView;
}

- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
    }
    return _grayLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}


@end

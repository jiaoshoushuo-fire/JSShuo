//
//  JSNoSearchResultView.m
//  JSShuo
//
//  Created by li que on 2018/12/11.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNoSearchResultView.h"

@implementation JSNoSearchResultView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.contentImageView];
        [self addSubview:self.titleLabelOne];
        [self addSubview:self.titleLabelTwo];
        
        [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(63, 68));
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(100);
        }];
        [self.titleLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 15));
            make.top.mas_equalTo(self.contentImageView.mas_bottom).offset(10);
            make.left.mas_equalTo(0);
        }];
        [self.titleLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 15));
            make.top.mas_equalTo(self.titleLabelOne.mas_bottom);
            make.left.mas_equalTo(0);
        }];
    }
    return self;
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.image = [UIImage imageNamed:@"noResultImage"];
    }
    return _contentImageView;
}

- (UILabel *)titleLabelOne {
    if (!_titleLabelOne) {
        _titleLabelOne = [[UILabel alloc] init];
        _titleLabelOne.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _titleLabelOne.textAlignment = NSTextAlignmentCenter;
        _titleLabelOne.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _titleLabelOne;
}

- (UILabel *)titleLabelTwo {
    if (!_titleLabelTwo) {
        _titleLabelTwo = [[UILabel alloc] init];
        _titleLabelTwo.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _titleLabelTwo.textAlignment = NSTextAlignmentCenter;
        _titleLabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _titleLabelTwo;
}

@end

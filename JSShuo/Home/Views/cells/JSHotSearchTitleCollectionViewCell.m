//
//  JSHotSearchTitleCollectionViewCell.m
//  JSShuo
//
//  Created by li que on 2018/11/16.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSHotSearchTitleCollectionViewCell.h"

@implementation JSHotSearchTitleCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.numberLable];
        [self.contentView addSubview:self.titleLabel];
        [self.numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(17);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.numberLable.mas_right).offset(0);
            make.left.mas_equalTo(self.numberLable.mas_right);
            make.top.mas_equalTo(8);
            make.height.mas_equalTo(17);
            make.width.mas_equalTo((ScreenWidth-30)*0.5 - 17);
        }];
    }
    return self;
}

- (void)setModelDic:(NSDictionary *)modelDic {
    _modelDic = modelDic;
    self.numberLable.text = [NSString stringWithFormat:@"%ld",self.tag-1000+1];
    switch (self.tag) {
        case 1000:
            _numberLable.textColor = [UIColor colorWithHexString:@"F44336"];
            break;
        case 1001:
            _numberLable.textColor = [UIColor colorWithHexString:@"F5A623"];
            break;
        case 1002:
            _numberLable.textColor = [UIColor colorWithHexString:@"7ED321"];
            break;
        case 1003:
            _numberLable.textColor = [UIColor colorWithHexString:@"BD10E0"];
            break;
        default:
            _numberLable.textColor = [UIColor colorWithHexString:@"A8A8A8"];
    }
    self.titleLabel.text = [NSString stringWithFormat:@".%@",[modelDic objectForKey:@"title"]];
}

- (UILabel *)numberLable {
    if(!_numberLable) {
        _numberLable = [[UILabel alloc] init];
        _numberLable.textAlignment = NSTextAlignmentLeft;
        _numberLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _numberLable;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}


@end

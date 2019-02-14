//
//  JSCircleBottomView.m
//  JSShuo
//
//  Created by li que on 2019/2/1.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import "JSCircleBottomView.h"

@interface JSCircleBottomView()
@property (nonatomic,strong) UIView *lineView;
@end


@implementation JSCircleBottomView

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setModel:(JSCircleListModel *)model {
    _model = model;
    [self addSubview:self.commitCountImg];
    [self addSubview:self.commitCountLabel];
    [self addSubview:self.praiseCountImg];
    [self addSubview:self.praiseCountLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineView];
    if (_model.isTop.integerValue == 2) { // 2是不置顶，1是置顶
        self.hotLabel.hidden = YES;
        [self.hotLabel removeFromSuperview];
        [self.commitCountImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(19, 17));
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(13);
        }];
    } else {
        self.hotLabel.hidden = NO;
        [self addSubview:self.hotLabel];
        [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(9);
//            make.top.mas_equalTo(9);  //  看看这两个有没有区别
            make.size.mas_equalTo(CGSizeMake(30, 17));
            make.left.mas_equalTo(15);
        }];
        [self.commitCountImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(19, 17));
            make.left.mas_equalTo(self.hotLabel.mas_right).offset(10);
            make.top.mas_equalTo(13);
        }];
    }
    [self.commitCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commitCountImg.mas_right).offset(7);
        make.centerY.mas_equalTo(self.commitCountImg.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(17);
    }];
    [self.praiseCountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.left.mas_equalTo(self.commitCountLabel.mas_right).offset(18);
        make.centerY.mas_equalTo(self.commitCountLabel.mas_centerY);
    }];
    [self.commitCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.commitCountLabel.mas_centerY);
//        make.trailing.equalTo(self.commitCountImg).with.offset(-29);
        make.left.mas_equalTo(self.praiseCountImg.mas_right).offset(7);
        make.centerY.mas_equalTo(self.praiseCountImg.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(17);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.praiseCountLabel.mas_right).offset(18);
        make.centerY.mas_equalTo(self.commitCountLabel.mas_centerY);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(17);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(16);
    }];
    self.commitCountLabel.text = [NSString stringWithFormat:@"%@",model.commentNum];
    self.praiseCountLabel.text = [NSString stringWithFormat:@"%@",model.praiseNum];
    self.timeLabel.text = model.createTimeDesc;
}


- (UILabel *)hotLabel {
    if (!_hotLabel) {
        _hotLabel = [[UILabel alloc] init];
        _hotLabel.text = @"置顶";
        _hotLabel.textAlignment = NSTextAlignmentCenter;
        _hotLabel.layer.borderWidth = 1;
        _hotLabel.layer.borderColor = [[UIColor colorWithHexString:@"F44336"] CGColor];
        _hotLabel.font = [UIFont systemFontOfSize:10];
        _hotLabel.textColor = [UIColor colorWithHexString:@"F44336"];
    }
    return _hotLabel;
}

- (UIImageView *)commitCountImg {
    if (!_commitCountImg) {
        _commitCountImg = [[UIImageView alloc] init];
        _commitCountImg.image = [UIImage imageNamed:@"comment"];
    }
    return _commitCountImg;
}

- (UILabel *)commitCountLabel {
    if (!_commitCountLabel) {
        _commitCountLabel = [[UILabel alloc] init];
        _commitCountLabel.textColor = [UIColor colorWithHexString:@"A8A8A8"];
        _commitCountLabel.font = [UIFont systemFontOfSize:12];
        _commitCountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _commitCountLabel;
}

- (UIImageView *)praiseCountImg {
    if (!_praiseCountImg) {
        _praiseCountImg = [[UIImageView alloc] init];
        _praiseCountImg.image = [UIImage imageNamed:@"praise"];
    }
    return _praiseCountImg;
}

- (UILabel *)praiseCountLabel {
    if (!_praiseCountLabel) {
        _praiseCountLabel = [[UILabel alloc] init];
        _praiseCountLabel.textColor = [UIColor colorWithHexString:@"A8A8A8"];
        _praiseCountLabel.font = [UIFont systemFontOfSize:12];
        _praiseCountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _praiseCountLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"545454"];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UIView *) lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"EDEDED"];
    }
    return _lineView;
}


@end

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
    [self.commitCountImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 17));
//        make.width.mas_equalTo(19);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(13).priorityHigh();
    }];
    [self.commitCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commitCountImg.mas_right).offset(7);
        make.centerY.mas_equalTo(self.commitCountImg.mas_centerY);
        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(17);
    }];
    [self.praiseCountImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.left.mas_equalTo(self.commitCountLabel.mas_right).offset(18);
        make.centerY.mas_equalTo(self.commitCountLabel.mas_centerY);
    }];
    [self.praiseCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.praiseCountImg.mas_right).offset(7);
        make.centerY.mas_equalTo(self.praiseCountImg.mas_centerY);
        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(17);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.praiseCountLabel.mas_right).offset(18);
        make.centerY.mas_equalTo(self.commitCountLabel.mas_centerY);
        make.right.mas_equalTo(-15);
//        make.height.mas_equalTo(17);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(16).priorityHigh();
        make.bottom.mas_equalTo(0);
    }];
    self.commitCountLabel.text = [NSString stringWithFormat:@"%@",model.commentNum];
    self.praiseCountLabel.text = [NSString stringWithFormat:@"%@",model.praiseNum];
    self.timeLabel.text = model.createTimeDesc;
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

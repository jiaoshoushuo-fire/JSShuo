//
//  JSCellBottomView.m
//  JSShuo
//
//  Created by li que on 2018/11/7.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSCellBottomView.h"
//#import "JSComputeTime.h"

@interface JSCellBottomView()
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) JSHomeModel *model;
@end

@implementation JSCellBottomView


- (instancetype) initWithModel:(JSHomeModel *)model {
    if (self = [super init]) {
        _model = model;
        [self addSubview:self.hotLabel];
        [self addSubview:self.sourceLabel];
        [self addSubview:self.releaseTimeLabel];
        [self addSubview:self.commitCountImg];
        [self addSubview:self.commitCountLabel];
        [self addSubview:self.praiseCountImg];
        [self addSubview:self.praiseCountLabel];
        [self addSubview:self.lineView];
        
        [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(9);
//            make.top.mas_equalTo(9);  //  看看这两个有没有区别
            make.size.mas_equalTo(CGSizeMake(30, 17));
            make.left.mas_equalTo(15);
        }];
        
        
        if (!_model.isTop) {
            self.hotLabel.hidden = YES;
            [self.sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self).with.offset(15);
//                make.top.mas_equalTo(self.playerIconImg.mas_bottom).offset(9);
                make.top.mas_equalTo(9);
            }];
        } else {
            self.hotLabel.hidden = NO;
            [self.sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self).with.offset(55);
//                make.top.mas_equalTo(self.playerIconImg.mas_bottom).offset(9);
                make.top.mas_equalTo(9);
            }];
        }
        [self.releaseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sourceLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(self.sourceLabel.mas_centerY);
            make.width.mas_equalTo(240);
        }];
        [self.commitCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            /*  总结：
             1. UILabel、UIImageView 可以不设置宽高；
             2. 不设置宽高时，根据文字、图片内容自动包裹；
             3. 当文字内容、图片尺寸改变时，宽度自动改变；
             4. 当label设置了对trailing的边距，同时左边有view与它有相对距离时；label变宽，这个view也会向左移动，不需要更新约束。
             */
            make.centerY.mas_equalTo(self.releaseTimeLabel.mas_centerY);
            make.trailing.equalTo(self).with.offset(-15);
        }];
        [self.commitCountImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(19, 17));
            make.right.mas_equalTo(self.commitCountLabel.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.commitCountLabel.mas_centerY);
        }];
        [self.praiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.commitCountLabel.mas_centerY);
            make.trailing.equalTo(self.commitCountImg).with.offset(-29);
        }];
        [self.praiseCountImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(17, 17));
            make.right.mas_equalTo(self.praiseCountLabel.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.praiseCountLabel.mas_centerY);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth-30, 2));
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.sourceLabel.mas_bottom).offset(8);
        }];
        
        _sourceLabel.text = _model.origin;
            _releaseTimeLabel.text = _model.publishTime;
//        _releaseTimeLabel.text = [[JSComputeTime new] distanceTimeWithPublistTime:_model.publishTime];
        _videoTimeLabel.text = [NSString stringWithFormat:@"%@",_model.duration];
        _commitCountLabel.text = [NSString stringWithFormat:@"%@",_model.commentNum];
        _praiseCountLabel.text = [NSString stringWithFormat:@"%@",_model.praiseNum];
        
    }
    return self;
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

- (UILabel *)sourceLabel {
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.font = [UIFont systemFontOfSize:12];
        _sourceLabel.textAlignment = NSTextAlignmentLeft;
        _sourceLabel.textColor = [UIColor colorWithHexString:@"A8A8A8"];
    }
    return _sourceLabel;
}

- (UILabel *)releaseTimeLabel {
    if (!_releaseTimeLabel) {
        _releaseTimeLabel = [[UILabel alloc] init];
        _releaseTimeLabel.font = [UIFont systemFontOfSize:12];
        _releaseTimeLabel.textColor = [UIColor colorWithHexString:@"A8A8A8"];
        _releaseTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _releaseTimeLabel;
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

- (UIView *) lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"EDEDED"];
    }
    return _lineView;
}


@end

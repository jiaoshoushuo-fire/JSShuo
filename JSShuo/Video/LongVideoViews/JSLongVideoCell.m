//
//  JSLongVideoView.m
//  JSShuo
//
//  Created by li que on 2018/11/5.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSLongVideoCell.h"
#import "JSComputeTime.h"

@interface JSLongVideoCell()
@property (nonatomic,strong) UIView *lineView;
@end

@implementation JSLongVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.playerIconImg];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth-30, 20));
            make.left.mas_equalTo(self).offset(15);
            make.top.mas_equalTo(10);
        }];
        
        [self.playerIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(ScreenWidth - 30);
            make.height.mas_equalTo(self.playerIconImg.mas_width).multipliedBy(9.0f/16.0f);
            make.left.mas_equalTo(15);
        }];
    }
    return self;
}

- (void)setModel:(JSLongVideoModel *)model {
    _model = model;
    
    [self.contentView addSubview:self.hotLabel];
    [self.contentView addSubview:self.sourceLabel];
    [self.contentView addSubview:self.releaseTimeLabel];
    [self.contentView addSubview:self.commitCountImg];
    [self.contentView addSubview:self.commitCountLabel];
    [self.contentView addSubview:self.praiseCountImg];
    [self.contentView addSubview:self.praiseCountLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerIconImg.mas_bottom).offset(9);
        make.size.mas_equalTo(CGSizeMake(30, 17));
        make.left.mas_equalTo(15);
    }];
    
    // 如果
    if (_model.isTop.integerValue == 2) { // 2是不置顶，1是置顶
        self.hotLabel.hidden = YES;
        [self.sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(15);
            make.top.mas_equalTo(self.playerIconImg.mas_bottom).offset(9);
        }];
    } else {
        self.hotLabel.hidden = NO;
        [self.sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(55);
            make.top.mas_equalTo(self.playerIconImg.mas_bottom).offset(9);
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
    
    _titleLabel.text = _model.title; // 暂时用描述字段来代替_playerIconImg
    [self.playerIconImg sd_setImageWithURL:[NSURL URLWithString:model.cover[0]]];
    _sourceLabel.text = _model.origin;
//    _releaseTimeLabel.text = _model.publishTime;
    _releaseTimeLabel.text = [[JSComputeTime new] distanceTimeWithPublistTime:model.publishTime];
    _videoTimeLabel.text = [NSString stringWithFormat:@"%@",_model.duration];
    _commitCountLabel.text = [NSString stringWithFormat:@"%@",_model.commentNum];
    _praiseCountLabel.text = [NSString stringWithFormat:@"%@",_model.praiseNum];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
    }
    return _titleLabel;
}

- (UIImageView *)playerIconImg {
    if (!_playerIconImg) {
        _playerIconImg = [[UIImageView alloc] init];
    }
    return _playerIconImg;
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

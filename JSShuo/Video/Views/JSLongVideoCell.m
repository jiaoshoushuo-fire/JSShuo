//
//  JSLongVideoView.m
//  JSShuo
//
//  Created by li que on 2018/11/5.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSLongVideoCell.h"

@implementation JSLongVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
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
    
    if (model.isHot) {
        [self.contentView addSubview:self.hotLabel];
        [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.playerIconImg.mas_bottom).offset(9);
            make.size.mas_equalTo(CGSizeMake(30, 17));
        }];
    }
    
    [self.contentView addSubview:self.sourceLabel];
    [self.contentView addSubview:self.releaseTimeLabel];
    [self.contentView addSubview:self.commitCountImg];
    [self.contentView addSubview:self.commitCountLabel];
    [self.contentView addSubview:self.praiseCountImg];
    [self.contentView addSubview:self.praiseCountLabel];
    
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 17));
        make.left.mas_equalTo(self.hotLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.playerIconImg.mas_bottom).offset(9);
    }];
    [self.releaseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sourceLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.playerIconImg.mas_bottom).offset(9);
        make.size.mas_equalTo(CGSizeMake(60, 17));
    }];
    [self.commitCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 17));
        make.centerY.mas_equalTo(self.releaseTimeLabel.mas_centerY);
        make.right.mas_equalTo(self).offset(-15);
    }];
    [self.commitCountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 17));
        make.right.mas_equalTo(self.commitCountLabel.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.commitCountLabel.mas_centerY);
    }];
    [self.praiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 17));
        make.centerY.mas_equalTo(self.commitCountLabel.mas_centerY);
        make.right.mas_equalTo(self.commitCountImg.mas_left).offset(-10);
    }];
    [self.praiseCountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.right.mas_equalTo(self.praiseCountLabel.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.praiseCountLabel.mas_centerY);
    }];
    
    
    
    _titleLabel.text = model.title;
    //这里不能设置为空，不然会有警告
//    _playerIconImg.image = [UIImage imageNamed:model.imgURL];
    _sourceLabel.text = model.source;
    _releaseTimeLabel.text = model.releaseTime;
    _videoTimeLabel.text = model.videoTime;
    _commitCountLabel.text = [NSString stringWithFormat:@"%@",model.commitCount];
    _praiseCountLabel.text = [NSString stringWithFormat:@"%@",model.praiseCount];
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
        _playerIconImg.backgroundColor = [UIColor cyanColor];
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

@end

//
//  JSSearchNormalView.m
//  JSShuo
//
//  Created by li que on 2018/11/15.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSSearchNormalView.h"

@implementation JSSearchNormalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.articleImgView];
        [self  addSubview:self.articleLabel];
        [self addSubview:self.videoImgView];
        [self addSubview:self.videoLabel];
        [self addSubview:self.ourWatchLabel];
        [self addSubview:self.bottomLine];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(27);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(22);
        }];
        [self.articleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 32));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(26);
            make.left.mas_equalTo(self.titleLabel.mas_left);
        }];
        [self.articleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.articleImgView.mas_bottom).offset(4);
            make.left.mas_equalTo(self.articleImgView.mas_left);
            make.width.mas_equalTo(self.articleImgView);
            make.height.mas_equalTo(20);
        }];
        [self.videoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.titleLabel.mas_right);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(26);
            make.size.mas_equalTo(CGSizeMake(37, 32));
        }];
        [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.videoImgView.mas_bottom).offset(4);
            make.right.mas_equalTo(self.videoImgView.mas_right);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(20);
        }];
        [self.ourWatchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.articleLabel.mas_bottom).offset(40);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth-30, 20));
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ourWatchLabel.mas_bottom).offset(5);
            make.left.right.mas_equalTo(15);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"搜索您感兴趣的内容";
    }
    return _titleLabel;
}

- (UIImageView *)articleImgView {
    if (!_articleImgView) {
        _articleImgView = [[UIImageView alloc] init];
        _articleImgView.image = [UIImage imageNamed:@"searchArticle"];
    }
    return _articleImgView;
}

- (UILabel *)articleLabel {
    if (!_articleLabel) {
        _articleLabel = [[UILabel alloc] init];
        _articleLabel.textColor = [UIColor colorWithHexString:@"A8A8A8"];
        _articleLabel.textAlignment = NSTextAlignmentLeft;
        _articleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _articleLabel.text = @"文章";
    }
    return _articleLabel;
}

- (UIImageView *)videoImgView {
    if (!_videoImgView) {
        _videoImgView = [[UIImageView alloc] init];
        _videoImgView.image = [UIImage imageNamed:@"searchVideo"];
    }
    return _videoImgView;
}

- (UILabel *)videoLabel {
    if (!_videoLabel) {
        _videoLabel = [[UILabel alloc] init];
        _videoLabel.textColor = [UIColor colorWithHexString:@"A8A8A8"];
        _videoLabel.textAlignment = NSTextAlignmentLeft;
        _videoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _videoLabel.text = @"视频";
    }
    return _videoLabel;
}

- (UILabel *)ourWatchLabel {
    if (!_ourWatchLabel) {
        _ourWatchLabel = [[UILabel alloc] init];
        _ourWatchLabel.textAlignment = NSTextAlignmentLeft;
        _ourWatchLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _ourWatchLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _ourWatchLabel.text = @"大家都在看";
    }
    return _ourWatchLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
    }
    return _bottomLine;
}





@end

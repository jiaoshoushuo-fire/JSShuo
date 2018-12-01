//
//  JSCommentTableViewCell.m
//  JSShuo
//
//  Created by li que on 2018/11/19.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSCommentTableViewCell.h"
#import "NSMutableAttributedString+JSRangeTextColor.h"
#import "UILabel+QLAdd.h"


@implementation JSCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headerImgView];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.createTimeLabel];

        [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.width.height.mas_equalTo(40);
            make.left.mas_equalTo(15);
        }];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headerImgView.mas_right).offset(16);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
//            make.height.mas_equalTo(20); // 如果是自适应高度的话就不用加
        }];
        [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userNameLabel);
            make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(4);
            make.right.mas_equalTo(self.userNameLabel);
//            make.height.mas_equalTo(17); // 如果是自适应高度的话就不用加
        }];
        
        [self.contentView addSubview:self.mainContentLabel];
        self.mainContentLabel.preferredMaxLayoutWidth = ScreenWidth-15-40-16-15;
        [self.mainContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userNameLabel);
            //            make.trailing.mas_equalTo(self.userNameLabel);
            make.right.mas_equalTo(self.userNameLabel);
            make.top.mas_equalTo(self.createTimeLabel.mas_bottom).offset(4);
        }];
        
    }
    return self;
}

- (void)setModel:(JSCommentListModel *)model {
    _model = model;
    
    if (model.replyList.count) {
        [self.contentView addSubview:self.bigContentView];
        CGFloat totalHeight = [self addReplayView:model];
        [self.bigContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userNameLabel.mas_left);
            make.right.mas_equalTo(self.mainContentLabel.mas_right);
//            make.height.mas_equalTo(totalHeight);
            make.top.mas_equalTo(self.mainContentLabel.mas_bottom).offset(5);
        }];

        [self.contentView addSubview:self.bottomLineView];
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.bigContentView.mas_bottom).offset(5);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    } else {
        [self.contentView addSubview:self.bottomLineView];
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.mainContentLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
    self.userNameLabel.text = model.nickname;
    self.createTimeLabel.text = model.createTime;
    self.mainContentLabel.text = model.content;
}

- (CGFloat) addReplayView:(JSCommentListModel *)model {
    CGFloat totalHeight = 0.0;
    if (model.replyList.count) { //
        if (model.replyList.count == self.bigContentView.subviews.count) {
            return 0;
        }
        for (int i = 0; i < model.replyList.count; i++) {
            NSString *contentStr = [model.replyList[i] objectForKey:@"content"]; // 回复的内容
            NSString *replyNickName = [model.replyList[i] objectForKey:@"replyNickname"]; // 回复某个评论的userName
            NSString *combinStr = [NSString stringWithFormat:@"%@回复：%@",replyNickName,contentStr];
            NSMutableAttributedString *indroStr = [NSMutableAttributedString setupAttributeString:combinStr rangeText:replyNickName textColor:[UIColor colorWithHexString:@"4A90E2"]];
            
            UILabel *label = [[UILabel alloc] init];
            [label setBackgroundColor:[UIColor clearColor]];
            label.textColor = [UIColor colorWithHexString:@"A8A8A8"];
            label.attributedText = indroStr;
            label.font = [UIFont systemFontOfSize:12];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentLeft;
            label.lineBreakMode=NSLineBreakByTruncatingTail;
            label.characterSpace=2;
            label.lineSpace=3;
            CGSize labSize = [label getLableRectWithMaxWidth:ScreenWidth-15-40-16-15-14];
//                        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
//                        CGFloat endMessageLabH = messageLabAotuH > MessageMAX_H?MessageMAX_H:messageLabAotuH;
            UIView *lastView = [self.bigContentView.subviews lastObject];
            CGFloat originalY = CGRectGetMaxY(lastView.frame);
            label.frame = CGRectMake(7, originalY+10, labSize.width, labSize.height+5);
            [self.bigContentView addSubview:label];
            self.bigContentView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
            totalHeight += labSize.height;
        }
        _replayHeight = totalHeight;
        return totalHeight;
    } else { // 没有回复评论
        return 0;
    }
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.layer.cornerRadius = _headerImgView.width/2;
    }
    return _headerImgView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = [UIColor colorWithHexString:@"4A90E2"];
        _userNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _userNameLabel;
}

- (UILabel *)createTimeLabel {
    if (!_createTimeLabel) {
        _createTimeLabel = [[UILabel alloc] init];
        _createTimeLabel.textColor = [UIColor colorWithHexString:@"A8A8A8"];
        _createTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _createTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _createTimeLabel;
}

- (UILabel *)mainContentLabel {
    if (!_mainContentLabel) {
        _mainContentLabel = [[UILabel alloc] init];
        _mainContentLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _mainContentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _mainContentLabel.textAlignment = NSTextAlignmentLeft;
        _mainContentLabel.numberOfLines = 0;
        //设置huggingPriority
        [_mainContentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _mainContentLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    }
    return _bottomLineView;
}

//暂时作为站位的
- (UIView *)bigContentView {
    if (!_bigContentView) {
        _bigContentView = [[UIView alloc] init];
    }
    return _bigContentView;
}


@end

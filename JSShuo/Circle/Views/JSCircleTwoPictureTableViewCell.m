//
//  JSCircleTwoPictureTableViewCell.m
//  JSShuo
//
//  Created by li que on 2019/2/1.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import "JSCircleTwoPictureTableViewCell.h"

@implementation JSCircleTwoPictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)setModel:(JSCircleListModel *)model {
    _model = model;
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.userPostImageView1];
    [self.contentView addSubview:self.userPostImageView2];
    [self.contentView addSubview:self.bottomView];
    
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12).priorityHigh();
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.nicknameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView.mas_right).offset(12);
        make.centerY.mas_equalTo(self.headView.mas_centerY);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-15);
    }];
    if (model.title.length > 0) { // 有标题
        self.titleLabel.hidden = NO;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_bottom).offset(16).priorityHigh();
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
//            make.height.mas_equalTo(25);
        }];
        self.titleLabel.text = [model.title stringByURLDecode];
        // 设置副标题
        self.subtitleLabel.preferredMaxLayoutWidth = ScreenWidth - 30;
        [self.subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(7).priorityHigh();
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
    } else {
        self.titleLabel.hidden = YES;
        [self.titleLabel removeFromSuperview];
        // 设置副标题
        self.subtitleLabel.preferredMaxLayoutWidth = ScreenWidth - 30;
        [self.subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_bottom).offset(7).priorityHigh();
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
    }
    
    CGFloat gap = 15;
    CGFloat width = (ScreenWidth-3*gap)/2;
    [self.userPostImageView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subtitleLabel.mas_bottom).offset(12).priorityHigh();
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(width);
    }];
    [self.userPostImageView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.userPostImageView1);
        make.top.mas_equalTo(self.subtitleLabel.mas_bottom).offset(12).priorityHigh();
        make.left.mas_equalTo(self.userPostImageView1.mas_right).offset(gap);
    }];
    
    // 总共高 12+17+16+1 = 46
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userPostImageView1.mas_bottom).offset(0).priorityHigh();
        make.left.right.mas_equalTo(self.subtitleLabel);
        //        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"placeHolder_1_1"]];
    self.nicknameLabel.text = model.nickname;
    self.subtitleLabel.text = [model.Description stringByURLDecode];
    [self.userPostImageView1 sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:@"placeHolder_1_1"]];
    [self.userPostImageView2 sd_setImageWithURL:[NSURL URLWithString:model.images[1]] placeholderImage:[UIImage imageNamed:@"placeHolder_1_1"]];
    self.bottomView.model = model;
    self.bottomView.commitCountLabel.text = [NSString stringWithFormat:@"%@",model.commentNum];
    self.bottomView.praiseCountLabel.text = [NSString stringWithFormat:@"%@",model.praiseNum];
    self.bottomView.timeLabel.text = model.createTimeDesc;
}


- (JSCircleBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[JSCircleBottomView alloc] init];
    }
    return _bottomView;
}

- (UIImageView *)userPostImageView2 {
    if (!_userPostImageView2) {
        _userPostImageView2 = [[UIImageView alloc] init];
    }
    return _userPostImageView2;
}

- (UIImageView *)userPostImageView1 {
    if (!_userPostImageView1) {
        _userPostImageView1 = [[UIImageView alloc] init];
    }
    return _userPostImageView1;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:16];
        _subtitleLabel.textAlignment = NSTextAlignmentLeft;
        _subtitleLabel.textColor = [UIColor colorWithHexString:@"545454"];
        _subtitleLabel.numberOfLines = 3;
        //设置huggingPriority
        [_subtitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _subtitleLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
    }
    return _titleLabel;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.font = [UIFont systemFontOfSize:18];
        _nicknameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nicknameLabel;
}

- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] init];
        _headView.clipsToBounds = YES;
        _headView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headView;
}

@end

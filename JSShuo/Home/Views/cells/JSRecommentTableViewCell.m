//
//  JSRecommentTableViewCell.m
//  JSShuo
//
//  Created by li que on 2018/11/19.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSRecommentTableViewCell.h"

@implementation JSRecommentTableViewCell

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
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.commentImgView];
        [self.contentView addSubview:self.commentNumLabel];
        [self.contentView addSubview:self.bottomLineView];

        self.titleLabel.preferredMaxLayoutWidth = ScreenWidth-30-100-10;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(self.iconImgView.mas_left).offset(-10);
        }];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(100);
            make.width.mas_equalTo(100);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(5);
        }];
        self.commentNumLabel.preferredMaxLayoutWidth = 80;
        [self.commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.iconImgView).with.offset(-10-15-100);
            make.height.mas_equalTo(18);
            make.bottom.mas_equalTo(-5);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.commentNumLabel.mas_bottom).offset(3);
            make.height.mas_equalTo(2);
            make.bottom.mas_equalTo(0);
        }];
        [self.commentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(19, 18));
            make.right.mas_equalTo(self.commentNumLabel.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.commentNumLabel.mas_centerY);
        }];
    }
    return self;
}

- (void)setModel:(JSRecommendModel *)model {
    _model = model;
    _titleLabel.text = model.title;
//    _titleLabel.text = @"sdfl;kajdf;klajfasiopfulmremqw;lj;fldmsflasdmf;lkjalfdsdmsflasdmf;lkjalfds";
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.cover[0]]];
    _commentNumLabel.text = [NSString stringWithFormat:@"%@",model.commentNum];
//    _commentNumLabel.text = @"123456";
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        //设置huggingPriority
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.clipsToBounds = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImgView;
}

- (UIImageView *)commentImgView {
    if (!_commentImgView) {
        _commentImgView = [[UIImageView alloc] init];
        _commentImgView.image = [UIImage imageNamed:@"comment"];
    }
    return _commentImgView;
}

- (UILabel *)commentNumLabel {
    if (!_commentNumLabel) {
        _commentNumLabel = [[UILabel alloc] init];
        _commentNumLabel.numberOfLines = 0;
        _commentNumLabel.textColor = [UIColor colorWithHexString:@"A8A8A8"];
        _commentNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _commentNumLabel.textAlignment = NSTextAlignmentRight;
        //设置huggingPriority
        [_commentNumLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _commentNumLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    }
    return _bottomLineView;
}


@end

//
//  JSShowTypeSmallPictureTableViewCell.m
//  JSShuo
//
//  Created by li que on 2018/11/9.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSShowTypeSmallPictureTableViewCell.h"

@implementation JSShowTypeSmallPictureTableViewCell

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
        
    }
    return self;
}

- (void)setModel:(JSHomeModel *)model {
    _model = model;
    [self.contentView addSubview:self.titleLabel];
    // 图片
    [self.contentView addSubview:self.smallImageView];
    [self.smallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(9);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(self.smallImageView.mas_width).multipliedBy(9.0/16.0);
    }];
    // 标题
    self.titleLabel.preferredMaxLayoutWidth = ScreenWidth-30-10-120;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(9);
        make.right.mas_equalTo(self.smallImageView.mas_left).offset(-10);
    }];
    // 底部
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.smallImageView.mas_bottom).offset(0); // bottomView自带上边间隙
        make.left.mas_equalTo(0);
        //            make.height.mas_equalTo(9+25+2);
        make.bottom.mas_equalTo(self.contentView).offset(-9-25-2).priorityHigh();
        make.right.mas_equalTo(0);
    }];
    _titleLabel.text = model.title.length ? model.title : model.Description;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@?imageView2/1/w/480/h/270",model.cover[0]];
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"placeHolder_16_9"]];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _titleLabel.numberOfLines = 0;
        //设置huggingPriority
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _titleLabel;
}

- (UIImageView *)smallImageView {
    if (!_smallImageView) {
        _smallImageView = [[UIImageView alloc] init];
        _smallImageView.clipsToBounds = YES;
        _smallImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _smallImageView;
}

- (JSCellBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[JSCellBottomView alloc] initWithModel:self.model];
    }
    return _bottomView;
}

@end

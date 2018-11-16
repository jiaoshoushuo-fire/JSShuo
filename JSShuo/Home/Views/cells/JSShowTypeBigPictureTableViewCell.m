//
//  JSShowTypeBigPictureTableViewCell.m
//  JSShuo
//
//  Created by li que on 2018/11/9.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSShowTypeBigPictureTableViewCell.h"

@implementation JSShowTypeBigPictureTableViewCell

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
    // 标题
    self.titleLabel.preferredMaxLayoutWidth = ScreenWidth-30;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.left.mas_equalTo(15);
        //            make.size.mas_equalTo(CGSizeMake(ScreenWidth-30, 22));
        make.right.mas_equalTo(-15);
    }];
    // 图片
    [self.contentView addSubview:self.bigImageView];
    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth - 30);
        make.height.mas_equalTo(self.bigImageView.mas_width).multipliedBy(9.0f/16.0f);
        make.left.mas_equalTo(15);
    }];
    // 底部
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bigImageView.mas_bottom).offset(0); // bottomView自带上边间隙
        make.left.mas_equalTo(0);
        //            make.height.mas_equalTo(9+25+2);
        make.bottom.mas_equalTo(self.contentView).offset(-9-25-2).priorityHigh();
        make.right.mas_equalTo(0);
    }];
    
    _titleLabel.text = model.title.length ? model.title : model.Description;
    
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.cover[0]]];
    
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

- (UIImageView *)bigImageView {
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc] init];
//        _bigImageView.backgroundColor = [UIColor cyanColor];
    }
    return _bigImageView;
}

- (JSCellBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[JSCellBottomView alloc] initWithModel:self.model];
    }
    return _bottomView;
}

@end

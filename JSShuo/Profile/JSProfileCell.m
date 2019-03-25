//
//  JSProfileCell.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/6.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSProfileCell.h"

@interface JSProfileCell ()
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subLabel;

@end

@implementation JSProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"262626"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.textColor = [UIColor colorWithHexString:@"CBCBCB"];
        _subLabel.font = [UIFont systemFontOfSize:12];
    }
    return _subLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subLabel];
    }
    return self;
}

- (void)setInfoDict:(NSDictionary *)infoDict{
    _infoDict = infoDict;
    NSString *imagePath = infoDict[@"imagePath"];
    NSString *title = infoDict[@"title"];
    NSString *subTitle = infoDict[@"subTitle"];
    
//    self.iconImageView.image = [UIImage imageNamed:imagePath]; // imagePath为本地地址
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];

    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    
    self.subLabel.text = subTitle;
    [self.subLabel sizeToFit];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconImageView.size = CGSizeMake(22, 22);
    self.iconImageView.left = 20;
    self.titleLabel.left = self.iconImageView.right + 10;
    self.subLabel.right = kScreenWidth - 30;
    
    self.iconImageView.centerY = self.titleLabel.centerY = self.subLabel.centerY = self.contentView.height/2.0f;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

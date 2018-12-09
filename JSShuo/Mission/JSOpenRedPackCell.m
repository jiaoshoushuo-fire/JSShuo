//
//  JSOpenRedPackCell.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/23.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSOpenRedPackCell.h"

@interface JSOpenRedPackCell ()

@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *contentLabel;

@end

@implementation JSOpenRedPackCell

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.size = CGSizeMake(28, 28);
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = _iconImageView.height/2.0f;
    }
    return _iconImageView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"FFF157"];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _contentLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}



- (void)setModel:(JSActivityUserModel *)model{
    _model = model;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.portrait] placeholder:[UIImage imageNamed:@"js_profile_default_icon"]];
    self.nameLabel.text = model.nickname;
    [self.nameLabel sizeToFit];
    
    self.contentLabel.text = [NSString stringWithFormat:@"%@元",@(model.amount)];
    [self.contentLabel sizeToFit];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconImageView.left = 10;
    self.nameLabel.left = self.iconImageView.right + 10;
    self.contentLabel.right = self.contentView.width;
    
    
    self.iconImageView.centerY = self.nameLabel.centerY = self.contentLabel.centerY = self.contentView.height/2.0f;
}
@end

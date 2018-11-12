//
//  JSPerfectUserInfoCell.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/9.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSPerfectUserInfoCell.h"

@implementation JSPerfectUserInfoCellModel

@end


@interface JSPerfectUserInfoCell ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *avaterIcon;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, strong)UIImageView *leftItemIcon;
@end

@implementation JSPerfectUserInfoCell

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titleLabel;
}
- (UIImageView *)avaterIcon{
    if (!_avaterIcon) {
        _avaterIcon = [[UIImageView alloc]init];
        _avaterIcon.size = CGSizeMake(40, 40);
        _avaterIcon.clipsToBounds = YES;
        _avaterIcon.layer.cornerRadius = 20.0f;
        _avaterIcon.backgroundColor = [UIColor redColor];
    }
    return _avaterIcon;
}
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.font = [UIFont systemFontOfSize:14];
        _subLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _subLabel.textAlignment = NSTextAlignmentRight;
        _subLabel.numberOfLines = 0;
    }
    return _subLabel;
}
//- (UIImageView *)leftItemIcon{
//    if (!_leftItemIcon) {
//        _leftItemIcon = [[UIImageView alloc]init];
//    }
//    return _leftItemIcon;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.avaterIcon];
        [self.contentView addSubview:self.subLabel];
//        [self.contentView addSubview:self.leftItemIcon];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 20));
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
        }];
        [self.avaterIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.right.equalTo(self.contentView).offset(0);
            make.centerY.equalTo(self.contentView);
        }];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(0);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)setModel:(JSPerfectUserInfoCellModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    if (model.imageUrl) {
        self.avaterIcon.hidden = NO;
        self.subLabel.hidden = YES;
        [self.avaterIcon setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholder:nil];
    }else{
        self.avaterIcon.hidden = YES;
        self.subLabel.hidden = NO;
        self.subLabel.text = model.subTitle;
        CGFloat height = [model.subTitle heightForFont:self.subLabel.font width:kScreenWidth-20-30-60-10];
        height = MAX(height, 20);
        height += 22;
        [self.subLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
    if (model.isHasAccessory) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        [self.subLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-30);
        }];
    }
}
- (void)setAvaterIconImage:(UIImage *)avaterIconImage{
    self.avaterIcon.image = avaterIconImage;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

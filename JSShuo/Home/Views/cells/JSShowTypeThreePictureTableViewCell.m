//
//  JSShowTypeThreePictureTableViewCell.m
//  JSShuo
//
//  Created by li que on 2018/11/9.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSShowTypeThreePictureTableViewCell.h"

@interface ThreeContentView11 : UIView
@property (nonatomic,strong) UIImageView *firstImgView;
@property (nonatomic,strong) UIImageView *secondImgView;
@property (nonatomic,strong) UIImageView *thirdImgView;
@end

@implementation ThreeContentView11

- (UIImageView *)firstImgView {
    if (!_firstImgView) {
        _firstImgView = [[UIImageView alloc] init];
        _firstImgView.clipsToBounds = YES;
        _firstImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _firstImgView;
}

- (UIImageView *)secondImgView {
    if (!_secondImgView) {
        _secondImgView = [[UIImageView alloc] init];
        _secondImgView.clipsToBounds = YES;
        _secondImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _secondImgView;
}

- (UIImageView *)thirdImgView {
    if (!_thirdImgView) {
        _thirdImgView = [[UIImageView alloc] init];
        _thirdImgView.clipsToBounds = YES;
        _thirdImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thirdImgView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.firstImgView];
        [self addSubview:self.secondImgView];
        [self addSubview:self.thirdImgView];
        CGFloat gap = 10;
        CGFloat width = (ScreenWidth - 2*15 - 2*gap ) / 3;
        CGFloat height = width*9 / 16;
        [self.firstImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        [self.secondImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImgView.mas_right).offset(gap);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.mas_equalTo(self.firstImgView.mas_centerY);
        }];
        [self.thirdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.secondImgView.mas_right).offset(gap);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerY.mas_equalTo(self.firstImgView.mas_centerY);
        }];
    }
    return self;
}

@end


@implementation JSShowTypeThreePictureTableViewCell

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
        // 标题
        self.titleLabel.preferredMaxLayoutWidth = ScreenWidth-30;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(9);
            make.left.mas_equalTo(15);
            //            make.size.mas_equalTo(CGSizeMake(ScreenWidth-30, 22));
            make.right.mas_equalTo(-15);
        }];
    }
    return self;
}

- (void)setModel:(JSHomeModel *)model {
    _model = model;
    
    // 图片
    ThreeContentView11 *threeContentView = [[ThreeContentView11 alloc] init];
    [self.contentView addSubview:threeContentView];
    [threeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        // 这个高度要和上面设置的一样高
        CGFloat width = (ScreenWidth - 2*15 - 2*10 ) / 3;
        CGFloat height = width*9 / 16;
        make.height.mas_equalTo(height);
    }];
    // 底部
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(threeContentView.mas_bottom).offset(0); // bottomView自带上边间隙
        make.left.mas_equalTo(0);
        //            make.height.mas_equalTo(9+25+2);
        make.bottom.mas_equalTo(self.contentView).offset(-9-25-2).priorityHigh();
        make.right.mas_equalTo(0);
    }];
    
    
    _titleLabel.text = model.title.length ? model.title : model.Description;
    [threeContentView.firstImgView sd_setImageWithURL:model.cover[0]];
    [threeContentView.secondImgView sd_setImageWithURL:model.cover[1]];
    [threeContentView.thirdImgView sd_setImageWithURL:model.cover[2]];
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

- (JSCellBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[JSCellBottomView alloc] initWithModel:self.model];
    }
    return _bottomView;
}


@end

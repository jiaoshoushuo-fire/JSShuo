//
//  JSInvitationSubViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/12/2.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSInvitationSubViewController.h"
#import "JSNetworkManager+Login.h"
#import "JSWithdrawViewController.h"
#import "JSAdjustButton.h"

@interface JSInvitationDayView : UIView
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UILabel *dayLabel;
@property (nonatomic, strong)UILabel *moneyLabel;
@property (nonatomic, strong)UILabel *subLabel;
@end
@implementation JSInvitationDayView

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"js_profile_invitate_dayback"];
        [_backImageView sizeToFit];
    }
    return _backImageView;
}
- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc]init];
        _dayLabel.textColor = [UIColor whiteColor];
        _dayLabel.font = [UIFont systemFontOfSize:15];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.font = [UIFont systemFontOfSize:17];
        _moneyLabel.textColor = [UIColor redColor];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.font = [UIFont systemFontOfSize:14];
        _subLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _subLabel.text = @"零钱";
        [_subLabel sizeToFit];
    }
    return _subLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [[UIColor colorWithHexString:@"999999"]CGColor];
        self.layer.borderWidth = 1.0f;
        
        [self addSubview:self.backImageView];
        [self addSubview:self.dayLabel];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.subLabel];
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.backImageView.size);
            make.centerX.equalTo(self);
            make.top.mas_equalTo(10);
        }];
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backImageView);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(25);
//            make.top.equalTo(self.backImageView.mas_bottom).offset(10);
            make.centerY.equalTo(self);
        }];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel.size);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return self;
}
@end

@protocol JSInvitationSubCell1Delegate <NSObject>

- (void)didSelectBottomButtonWithModel:(JSAccountModel *)model;

@end

@interface JSInvitationSubCell1 : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, strong)UILabel *bottomLabel;
@property (nonatomic, strong)UIButton *bottomButton;
@property (nonatomic, strong)JSAccountModel *accountModel;
@property (nonatomic, weak)id <JSInvitationSubCell1Delegate>delegate;

@end

@implementation JSInvitationSubCell1

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.text = @"每邀请一名好友，10零钱红包怎么赚？";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.font = [UIFont systemFontOfSize:14];
        _subLabel.textColor = [UIColor colorWithHexString:@"9f9f9f"];
        _subLabel.numberOfLines = 2;
        _subLabel.text = @"好友每天获得5篇阅读奖励并绑定微信，您即可获得当天相应的奖励";
        CGSize size = [_subLabel sizeThatFits:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
        _subLabel.size = size;
    }
    return _subLabel;
}
- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.font = [UIFont systemFontOfSize:16];
        _bottomLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _bottomLabel;
}
- (UIButton *)bottomButton{
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.size = CGSizeMake(100, 30);
        _bottomButton.backgroundColor = [UIColor colorWithHexString:@"FBD058"];
        [_bottomButton setTitle:@"立即提现" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _bottomButton.clipsToBounds = YES;
        _bottomButton.layer.cornerRadius = _bottomButton.height/2.0f;
        @weakify(self)
        [_bottomButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBottomButtonWithModel:)]) {
                [self.delegate didSelectBottomButtonWithModel:self.accountModel];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subLabel];
        [self.contentView addSubview:self.bottomLabel];
        [self.contentView addSubview:self.bottomButton];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel.size);
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self).offset(10);
        }];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel.size);
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
        NSArray *days = @[@"第一天",@"第二天",@"第三天",@"第四天",@"第五天",@"第六天",@"第七天"];
        NSArray *moneys = @[@"0.5",@"1",@"1",@"1",@"1",@"2",@"3.5"];
        CGFloat width = (kScreenWidth - 40 - 20)/3.0f;
        for (int i = 0; i< days.count; i++) {
            JSInvitationDayView *dayView = [[JSInvitationDayView alloc]initWithFrame:CGRectMake(20 + (width+10) * (i%3), 10+self.titleLabel.height+10+self.subLabel.height + 10 + (width + 15)*(i/3), width, width)];
            dayView.dayLabel.text = days[i];
            dayView.moneyLabel.text = moneys[i];
            [self.contentView addSubview:dayView];
        }
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.bottomButton.mas_left).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(30);
        }];
        [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.bottomButton.size);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
    }
    return self;
}
- (void)setAccountModel:(JSAccountModel *)accountModel{
    _accountModel = accountModel;
    NSString *money = [NSString stringWithFormat:@"%0.2f",accountModel.money/100.0f];
    NSString *string = [NSString stringWithFormat:@"快速提现金额：%@",money];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:money]];
    self.bottomLabel.attributedText = text;
    
}
@end

@interface JSInvitationSubCell2 : UITableViewCell
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, strong)UIView *view1;
@property (nonatomic, strong)UIView *view2;
@property (nonatomic, strong)UIView *view3;

@property (nonatomic, strong)UILabel *label_1;
@property (nonatomic, strong)UILabel *label_2;
@property (nonatomic, strong)UILabel *label_3;

@property (nonatomic, strong)JSAdjustButton *botton;

@end

@implementation JSInvitationSubCell2

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.text = @"邀请小技巧";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.textColor = [UIColor colorWithHexString:@"989898"];
        _subLabel.font = [UIFont systemFontOfSize:14];
        _subLabel.text = @"邀请成功率提升200％";
        [_subLabel sizeToFit];
    }
    return _subLabel;
}
- (UIView *)view1{
    if (!_view1) {
        _view1 = [[UIView alloc]init];
        _view1.backgroundColor = [UIColor colorWithHexString:@"F44336"];
        _view1.size = CGSizeMake(7, 30);
    }
    return _view1;
}
- (UIView *)view2{
    if (!_view2) {
        _view2 = [[UIView alloc]init];
        _view2.backgroundColor = [UIColor colorWithHexString:@"F44336"];
        _view2.size = CGSizeMake(7, 30);
    }
    return _view2;
}
- (UIView *)view3{
    if (!_view3) {
        _view3 = [[UIView alloc]init];
        _view3.backgroundColor = [UIColor colorWithHexString:@"F44336"];
        _view3.size = CGSizeMake(7, 30);
    }
    return _view3;
}

- (UILabel *)label_1{
    if (!_label_1) {
        _label_1 = [[UILabel alloc]init];
        _label_1.font = [UIFont systemFontOfSize:16];
        _label_1.textColor = [UIColor colorWithHexString:@"333333"];
        _label_1.text = @"邀请您的家人、朋友、同学、同事成功率最高。";
        _label_1.numberOfLines = 0;
        CGSize size = [_label_1 sizeThatFits:CGSizeMake(kScreenWidth-40-7-15, MAXFLOAT)];
        _label_1.size = size;
    }
    return _label_1;
}
- (UILabel *)label_2{
    if (!_label_2) {
        _label_2 = [[UILabel alloc]init];
        _label_2.font = [UIFont systemFontOfSize:16];
        _label_2.textColor = [UIColor colorWithHexString:@"333333"];
        _label_2.numberOfLines = 0;
        NSString *redString = @"提升200％";
        NSString *string = [NSString stringWithFormat:@"分享到到3个以上微信群／QQ群，成功几率%@",redString];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:redString]];
        
        _label_2.attributedText = text;
        CGSize size = [_label_2 sizeThatFits:CGSizeMake(kScreenWidth-40-7-15, MAXFLOAT)];
        _label_2.size  = size;
    }
    return _label_2;
}

- (UILabel *)label_3{
    if (!_label_3) {
        _label_3 = [[UILabel alloc]init];
        _label_3.font = [UIFont systemFontOfSize:16];
        _label_3.textColor = [UIColor colorWithHexString:@"333333"];
        _label_3.numberOfLines = 0;
        NSString *redString = @"188+88";
        NSString *string = [NSString stringWithFormat:@"可以告诉您的朋友：注册最高可领%@零钱随机红包，可立即提现哦",redString];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:redString]];
        
        _label_3.attributedText = text;
         CGSize size = [_label_3 sizeThatFits:CGSizeMake(kScreenWidth-40-7-15, MAXFLOAT)];
        _label_3.size = size;
    }
    return _label_3;
}
- (JSAdjustButton *)botton{
    if (!_botton) {
        _botton = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        _botton.itemSpace = 20;
        _botton.position = JSImagePositionLeft;
        [_botton setImage:[UIImage imageNamed:@"js_profile_wenhao"] forState:UIControlStateNormal];
        [_botton setTitle:@"如何邀请好友加入叫兽说" forState:UIControlStateNormal];
        _botton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_botton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _botton.size = CGSizeMake(250, 50);
        _botton.clipsToBounds = YES;
        _botton.layer.cornerRadius = _botton.height/2.0f;
        _botton.layer.borderColor = [[UIColor colorWithHexString:@"666666"]CGColor];
        _botton.layer.borderWidth = 1.0f;
    }
    return _botton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subLabel];
        [self.contentView addSubview:self.view1];
        [self.contentView addSubview:self.label_1];
        [self.contentView addSubview:self.view2];
        [self.contentView addSubview:self.label_2];
        [self.contentView addSubview:self.view3];
        [self.contentView addSubview:self.label_3];
        [self.contentView addSubview:self.botton];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(5);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel.size);
            make.top.equalTo(self.lineView.mas_bottom).offset(10);
            make.centerX.equalTo(self.contentView);
        }];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.contentView);
        }];
        [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.view1.size);
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.subLabel.mas_bottom).offset(10);
        }];
        [self.label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.label_1.size);
            make.left.equalTo(self.view1.mas_right).offset(15);
            make.top.equalTo(self.view1.mas_top);
        }];
        
        [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.view2.size);
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.view1.mas_bottom).offset(20);
        }];
        [self.label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.label_2.size);
            make.left.equalTo(self.view2.mas_right).offset(15);
            make.top.equalTo(self.view2.mas_top);
        }];
        
        [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.view3.size);
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.view2.mas_bottom).offset(20);
        }];
        [self.label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.label_3.size);
            make.left.equalTo(self.view3.mas_right).offset(15);
            make.top.equalTo(self.view3.mas_top);
        }];
        
        [self.botton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.botton.size);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.label_3.mas_bottom).offset(20);
        }];
    }
    return self;
}
@end

@interface JSInvitationSubCell3 : UITableViewCell
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, strong)UIImageView *leftImage;
@property (nonatomic, strong)UILabel *leftBottomLabel;
@property (nonatomic, strong)UIImageView *rightImage;
@property (nonatomic, strong)UILabel *rightBottomLabel;
@property (nonatomic, strong)UIImageView *midImage;
@property (nonatomic, strong)UILabel *midBottomLabel;

@property (nonatomic, strong)UIImageView *leftArrowImage;
@property (nonatomic, strong)UIImageView *rightArrowImage;
@property (nonatomic, strong)UILabel *bottomLabel;
@end

@implementation JSInvitationSubCell3

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.text = @"怎么邀请好友";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.textColor = [UIColor colorWithHexString:@"989898"];
        _subLabel.font = [UIFont systemFontOfSize:14];
        _subLabel.text = @"看下面流程，非常简单";
        [_subLabel sizeToFit];
    }
    return _subLabel;
}
- (UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc]init];
        _leftImage.image = [UIImage imageNamed:@"js_profile_invitate_1"];
    }
    return _leftImage;
}
- (UIImageView *)midImage{
    if (!_midImage) {
        _midImage = [[UIImageView alloc]init];
        _midImage.image = [UIImage imageNamed:@"js_profile_invitate_2"];
    }
    return _midImage;
}
- (UIImageView *)rightImage{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc]init];
        _rightImage.image = [UIImage imageNamed:@"js_profile_invitate_3"];
    }
    return _rightImage;
}

- (UILabel *)leftBottomLabel{
    if (!_leftBottomLabel) {
        _leftBottomLabel = [[UILabel alloc]init];
        _leftBottomLabel.font = [UIFont boldSystemFontOfSize:14];
        _leftBottomLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _leftBottomLabel.numberOfLines = 2;
        _leftBottomLabel.textAlignment = NSTextAlignmentCenter;
        _leftBottomLabel.text = @"点击按钮\n分享给好友";
//        [_leftBottomLabel sizeToFit];
        _leftBottomLabel.size = CGSizeMake(90, 40);
    }
    return _leftBottomLabel;
}

- (UILabel *)midBottomLabel{
    if (!_midBottomLabel) {
        _midBottomLabel = [[UILabel alloc]init];
        _midBottomLabel.font = [UIFont boldSystemFontOfSize:14];
        _midBottomLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _midBottomLabel.numberOfLines = 2;
        _midBottomLabel.textAlignment = NSTextAlignmentCenter;
        _midBottomLabel.text = @"好友打开链接\n下载安装";
//        [_midBottomLabel sizeToFit];
        _midBottomLabel.size = CGSizeMake(90, 40);
    }
    return _midBottomLabel;
}

- (UILabel *)rightBottomLabel{
    if (!_rightBottomLabel) {
        _rightBottomLabel = [[UILabel alloc]init];
        _rightBottomLabel.font = [UIFont boldSystemFontOfSize:14];
        _rightBottomLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _rightBottomLabel.numberOfLines = 3;
        _rightBottomLabel.textAlignment = NSTextAlignmentCenter;
        _rightBottomLabel.text = @"好友输入\n邀请码登录阅读\n您获得红包";
//        [_rightBottomLabel sizeToFit];
        _rightBottomLabel.size = CGSizeMake(100, 60);
    }
    return _rightBottomLabel;
}
- (UIImageView *)leftArrowImage{
    if (!_leftArrowImage) {
        _leftArrowImage = [[UIImageView alloc]init];
        _leftArrowImage.image = [UIImage imageNamed:@"js_profile_invitate_arrow"];
    }
    return _leftArrowImage;
}
- (UIImageView *)rightArrowImage{
    if (!_rightArrowImage) {
        _rightArrowImage = [[UIImageView alloc]init];
        _rightArrowImage.image = [UIImage imageNamed:@"js_profile_invitate_arrow"];
    }
    return _rightArrowImage;
}
- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.font = [UIFont systemFontOfSize:13];
        _bottomLabel.textColor = [UIColor colorWithHexString:@"999999"];
        
        _bottomLabel.numberOfLines = 2;
        _bottomLabel.text = @"特别说明：新好友需在新设备上注册（之前未登录过叫兽说账号的手机）好友累计阅读 30金币，方可获得奖励";
        CGSize size = [_bottomLabel sizeThatFits:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
        _bottomLabel.size = size;
    }
    return _bottomLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subLabel];
        [self.contentView addSubview:self.leftImage];
        [self.contentView addSubview:self.leftBottomLabel];
        [self.contentView addSubview:self.midImage];
        [self.contentView addSubview:self.midBottomLabel];
        [self.contentView addSubview:self.rightImage];
        [self.contentView addSubview:self.rightBottomLabel];
        [self.contentView addSubview:self.leftArrowImage];
        [self.contentView addSubview:self.rightArrowImage];
        [self.contentView addSubview:self.bottomLabel];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(5);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel.size);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.lineView.mas_bottom).offset(10);
        }];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel.size);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
        [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 55));
            make.left.equalTo(self.contentView).offset(30);
            make.top.equalTo(self.subLabel.mas_bottom).offset(20);
        }];
        [self.midImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 55));
            make.top.equalTo(self.subLabel.mas_bottom).offset(20);
            make.centerX.equalTo(self.contentView);
        }];
        [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 55));
            make.right.equalTo(self.contentView).offset(-30);
            make.top.equalTo(self.subLabel.mas_bottom).offset(20);
        }];
        
        [self.leftArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImage.mas_right).offset(10);
            make.right.equalTo(self.midImage.mas_left).offset(-20);
            make.centerY.equalTo(self.leftImage);
            make.height.mas_equalTo(11);
        }];
        
        [self.rightArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.midImage.mas_right).offset(20);
            make.right.equalTo(self.rightImage.mas_left).offset(-10);
            make.centerY.equalTo(self.leftImage);
            make.height.mas_equalTo(11);
        }];
        
        [self.leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.leftBottomLabel.size);
            make.centerX.equalTo(self.leftImage);
            make.top.equalTo(self.leftImage.mas_bottom).offset(10);
        }];
        [self.midBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.midBottomLabel.size);
            make.centerX.equalTo(self.midImage);
            make.top.equalTo(self.midImage.mas_bottom).offset(10);
        }];
        [self.rightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.rightBottomLabel.size);
            make.centerX.equalTo(self.rightImage);
            make.top.equalTo(self.rightImage.mas_bottom).offset(10);
        }];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.bottomLabel.size);
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.rightBottomLabel.mas_bottom).offset(10);
        }];
    }
    return self;
}
@end


@interface JSInvitationSubViewController ()<UITableViewDelegate,UITableViewDataSource,JSInvitationSubCell1Delegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)JSAccountModel *accountModel;
@end

@implementation JSInvitationSubViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JSInvitationSubCell1 class] forCellReuseIdentifier:@"JSInvitationSubCell1"];
        [_tableView registerClass:[JSInvitationSubCell2 class] forCellReuseIdentifier:@"JSInvitationSubCell2"];
        [_tableView registerClass:[JSInvitationSubCell3 class] forCellReuseIdentifier:@"JSInvitationSubCell3"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [JSNetworkManager queryAccountInfoWithComplement:^(BOOL isSuccess, JSAccountModel * _Nonnull accountModel) {
        if (isSuccess) {
            self.accountModel = accountModel;
            [self.tableView reloadData];
        }
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        JSInvitationSubCell1 *subCell = [tableView dequeueReusableCellWithIdentifier:@"JSInvitationSubCell1" forIndexPath:indexPath];
        subCell.accountModel = self.accountModel;
        subCell.delegate = self;
        cell = subCell;
    }else if(indexPath.row == 1){
        JSInvitationSubCell2 *subCell = [tableView dequeueReusableCellWithIdentifier:@"JSInvitationSubCell2" forIndexPath:indexPath];
        cell = subCell;
    }else if (indexPath.row == 2){
        JSInvitationSubCell3 *subCell = [tableView dequeueReusableCellWithIdentifier:@"JSInvitationSubCell3" forIndexPath:indexPath];
        cell = subCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CGFloat width = (kScreenWidth - 40 - 20)/3.0f;
        return 75 + 10 + width * 3 + 15 * 2 + 10 + 30 + 10 ;
    }
    return 300;
    
}

- (void)didSelectBottomButtonWithModel:(JSAccountModel *)model{
    JSWithdrawViewController *vc = [[JSWithdrawViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

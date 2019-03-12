//
//  JSAlertRuleView.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/12/22.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAlertRuleView.h"

@interface JSAlertRuleView ()
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIButton *closeButton;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIView *headerBackView;
@property (nonatomic, strong)UILabel *label_1;
@property (nonatomic, strong)UILabel *label_2;
@property (nonatomic, strong)UILabel *label_3;
@property (nonatomic, strong)UILabel *label_4;
//@property (nonatomic, strong)UILabel *label_5;

@end

@implementation JSAlertRuleView

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.clipsToBounds = YES;
        _contentView.layer.cornerRadius = 5;
        _contentView.size = CGSizeMake(260, 450);
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"js_alert_rule_close"] forState:UIControlStateNormal];
        _closeButton.size = CGSizeMake(40, 40);
        [_closeButton addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"活动规则";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleLabel sizeToFit];
        
    }
    return _titleLabel;
}
- (UIView *)headerBackView{
    if (!_headerBackView) {
        _headerBackView = [[UIView alloc]init];
        _headerBackView.backgroundColor = [UIColor colorWithHexString:@"F35037"];
        
    }
    return _headerBackView;
}
- (UILabel *)label_1{
    if (!_label_1) {
        _label_1 = [[UILabel alloc]init];
        _label_1.numberOfLines = 0;
        _label_1.font = [UIFont systemFontOfSize:14];
        _label_1.textColor = [UIColor colorWithHexString:@"242424"];
        NSString *string = @"1次";
        NSString *string_2 = [NSString stringWithFormat:@"1·活动限叫兽说用户参加，每位用户每天仅能参加 %@",string];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string_2];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHexString:@"F35037"]
                              range:[string_2 rangeOfString:string]];
        
        _label_1.attributedText = AttributedStr;
        CGSize size = [_label_1 sizeThatFits:CGSizeMake(self.contentView.width - 40, MAXFLOAT)];
        _label_1.size = size;
    }
    return _label_1;
}

- (UILabel *)label_2{
    if (!_label_2) {
        _label_2 = [[UILabel alloc]init];
        _label_2.numberOfLines = 0;
        _label_2.font = [UIFont systemFontOfSize:14];
        _label_2.textColor = [UIColor colorWithHexString:@"242424"];
        NSString *string = @"1元";
        NSString *string_2 = [NSString stringWithFormat:@"2·活动获得的红包可以在‘我的-钱包’内进行查看和提现。活动期间，到账可能有延迟，请耐心等待。"];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string_2];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHexString:@"F35037"]
                              range:[string_2 rangeOfString:string]];
        
        _label_2.attributedText = AttributedStr;
        CGSize size = [_label_2 sizeThatFits:CGSizeMake(self.contentView.width - 40, MAXFLOAT)];
        _label_2.size = size;
    }
    return _label_2;
}

- (UILabel *)label_3{
    if (!_label_3) {
        _label_3 = [[UILabel alloc]init];
        _label_3.numberOfLines = 0;
        _label_3.font = [UIFont systemFontOfSize:14];
        _label_3.textColor = [UIColor colorWithHexString:@"242424"];
//        NSString *string = @"1元";
        NSString *string_2 = [NSString stringWithFormat:@"3·如发现用户以违规或作弊手段抢红包，叫兽说有权收回用户违规获得得奖励。"];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string_2];
//        [AttributedStr addAttribute:NSForegroundColorAttributeName
//                              value:[UIColor colorWithHexString:@"F35037"]
//                              range:[string_2 rangeOfString:string]];
        
        _label_3.attributedText = AttributedStr;
        CGSize size = [_label_3 sizeThatFits:CGSizeMake(self.contentView.width - 40, MAXFLOAT)];
        _label_3.size = size;
    }
    return _label_3;
}
- (UILabel *)label_4{
    if (!_label_4) {
        _label_4 = [[UILabel alloc]init];
        _label_4.numberOfLines = 0;
        _label_4.font = [UIFont systemFontOfSize:14];
        _label_4.textColor = [UIColor colorWithHexString:@"242424"];
        NSString *string = @"“我的-钱包”";
        NSString *string_2 = [NSString stringWithFormat:@"4·活动结束时间以叫兽说官方信息为准，本活动的最终解释权归叫兽说所有。"];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string_2];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHexString:@"F35037"]
                              range:[string_2 rangeOfString:string]];
        
        _label_4.attributedText = AttributedStr;
        CGSize size = [_label_4 sizeThatFits:CGSizeMake(self.contentView.width - 40, MAXFLOAT)];
        _label_4.size = size;
    }
    return _label_4;
}

//- (UILabel *)label_5{
//    if (!_label_5) {
//        _label_5 = [[UILabel alloc]init];
//        _label_5.numberOfLines = 0;
//        _label_5.font = [UIFont systemFontOfSize:14];
//        _label_5.textColor = [UIColor colorWithHexString:@"242424"];
//        //        NSString *string = @"1元";
//        NSString *string_2 = [NSString stringWithFormat:@"5·活动结束时间以叫兽说官方信息为准，活动的最终解释权归叫兽说所有"];
//
//        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string_2];
//        //        [AttributedStr addAttribute:NSForegroundColorAttributeName
//        //                              value:[UIColor colorWithHexString:@"F35037"]
//        //                              range:[string_2 rangeOfString:string]];
//
//        _label_5.attributedText = AttributedStr;
//        CGSize size = [_label_5 sizeThatFits:CGSizeMake(self.contentView.width - 40, MAXFLOAT)];
//        _label_5.size = size;
//    }
//    return _label_5;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.headerBackView];
        [self.headerBackView addSubview:self.titleLabel];
        [self.headerBackView addSubview:self.closeButton];
        [self.contentView addSubview:self.label_1];
        [self.contentView addSubview:self.label_2];
        [self.contentView addSubview:self.label_3];
        [self.contentView addSubview:self.label_4];
//        [self.contentView addSubview:self.label_5];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(260, 290));
            make.center.equalTo(self);
        }];
        [self.headerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(50);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel.size);
            make.center.equalTo(self.headerBackView);
        }];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.closeButton.size);
            make.right.top.equalTo(self.headerBackView);
        }];
        
        [self.label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.label_1.size);
            make.top.equalTo(self.headerBackView.mas_bottom).offset(10);
            make.centerX.equalTo(self.contentView);
        }];
        [self.label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.label_2.size);
            make.top.equalTo(self.label_1.mas_bottom).offset(10);
            make.centerX.equalTo(self.contentView);
        }];
        [self.label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.label_3.size);
            make.top.equalTo(self.label_2.mas_bottom).offset(10);
            make.centerX.equalTo(self.contentView);
        }];
        [self.label_4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.label_4.size);
            make.top.equalTo(self.label_3.mas_bottom).offset(10);
            make.centerX.equalTo(self.contentView);
        }];
//        [self.label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(self.label_5.size);
//            make.top.equalTo(self.label_4.mas_bottom).offset(10);
//            make.centerX.equalTo(self.contentView);
//        }];
    
        
    }
    return self;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
//        [self addSubview:self.contentView];
        self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.contentView.transform =
                             CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                              animations:^{
                                                  self.contentView.transform = CGAffineTransformIdentity;
                                              }];
                         }];
    }
}


- (void)dismissAlertView{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    anim.toValue = @(0.0f);
    anim.duration = 0.15;
    anim.removedOnCompletion = YES;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self removeFromSuperview];
    };
    [self.contentView pop_addAnimation:anim forKey:@"alpha"];
}
@end

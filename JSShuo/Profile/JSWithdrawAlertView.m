//
//  JSWithdrawAlertView.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/14.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSWithdrawAlertView.h"
#import "JSAdjustButton.h"
#import "JSAccountManager+Wechat.h"
#import "JSNetworkManager+Login.h"
#import "JSBindIPhoneViewController.h"

@interface JSWithdrawAlertView()<YYTextKeyboardObserver>
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIButton *actionButton;
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *alertLabel;
@property (nonatomic, strong)UIImageView *accountIcon;
@property (nonatomic, strong)UITextField *accountTextField;

@property (nonatomic, strong)UIImageView *realNameIcon;
@property (nonatomic, strong)UITextField *realNameTextfield;

@property (nonatomic, strong)JSAdjustButton *bindWechatButton;
@property (nonatomic, strong)UILabel *bindWechatLabel;

@property (nonatomic, copy)void(^actionBlock)(BOOL isSuccess);

@property (nonatomic, assign)JSWithdrawAlertViewType alertType;

@property (nonatomic, assign)BOOL isBindWechat;
@property (nonatomic, assign)BOOL isBindType;
@end

@implementation JSWithdrawAlertView

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (JSAdjustButton *)bindWechatButton{
    if (!_bindWechatButton) {
        _bindWechatButton = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        _bindWechatButton.position = JSImagePositionRight;
        _bindWechatButton.itemSpace = 10;
        _bindWechatButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bindWechatButton setTitle:@"去绑定" forState:UIControlStateNormal];
        [_bindWechatButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_bindWechatButton setImage:[UIImage imageNamed:@"personalCenter_arrow"] forState:UIControlStateNormal];
        _bindWechatButton.size = CGSizeMake(80, 30);
        
        @weakify(self)
        [_bindWechatButton bk_addEventHandler:^(UIButton *sender) {
            @strongify(self)
            [JSAccountManager wechatAuthorizeFromLogin:NO completion:^(BOOL success) {
                if (success) {
                    self.isBindWechat = success;
                    [sender setTitle:@"已绑定" forState:UIControlStateNormal];
                    sender.enabled = NO;
                }
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindWechatButton;
}
- (UILabel *)bindWechatLabel{
    if (!_bindWechatLabel) {
        _bindWechatLabel = [[UILabel alloc]init];
        _bindWechatLabel.font = [UIFont systemFontOfSize:16];
        _bindWechatLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _bindWechatLabel;
}
- (UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.size = CGSizeMake(kScreenWidth-20, 45);
        [_actionButton setTitle:@"提现" forState:UIControlStateNormal];
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"js_tixian_back_image"] forState:UIControlStateNormal];
    }
    return _actionButton;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"js_tixian_weibangding"];
        [_iconImageView sizeToFit];
    }
    return _iconImageView;
}
- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.text = @"手机号未绑定";
        _alertLabel.font = [UIFont systemFontOfSize:16];
        _alertLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [_alertLabel sizeToFit];
    }
    return _alertLabel;
}
- (UIImageView *)accountIcon{
    if (!_accountIcon) {
        _accountIcon = [[UIImageView alloc]init];
        _accountIcon.image = [UIImage imageNamed:@"js_login_acount_icon"];
    }
    return _accountIcon;
}
- (UIImageView *)realNameIcon{
    if (!_realNameIcon) {
        _realNameIcon = [[UIImageView alloc]init];
        _realNameIcon.image = [UIImage imageNamed:@"js_tixian_realname_icon"];
    }
    return _realNameIcon;
}

- (UITextField *)accountTextField{
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc]init];
        _accountTextField.placeholder = @"请输入支付宝账号";
        _accountTextField.font = [UIFont systemFontOfSize:14];
        
        _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _accountTextField;
}
- (UITextField *)realNameTextfield{
    if (!_realNameTextfield) {
        _realNameTextfield = [[UITextField alloc]init];
        _realNameTextfield.placeholder = @"请输入真实姓名";
        _realNameTextfield.font = [UIFont systemFontOfSize:14];
        
        _realNameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _realNameTextfield;
}
- (instancetype)initWithFrame:(CGRect)frame type:(JSWithdrawAlertViewType)type isBindType:(BOOL)isBind
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:169/255.0f green:169/255.0f blue:169/255.0f alpha:0.5];
        [self addSubview:self.contentView];
        self.contentView.frame = CGRectMake(0, self.height - 250, self.width, 250);
        self.alertType = type;
        self.isBindType = isBind;
        switch (type) {
            case JSWithdrawAlertViewTypeAlipay:{
                
                [self.contentView addSubview:self.accountIcon];
                [self.contentView addSubview:self.accountTextField];
                [self.contentView addSubview:self.realNameIcon];
                [self.contentView addSubview:self.realNameTextfield];
                [self.contentView addSubview:self.actionButton];
                
                if (self.isBindType) {
                    [self.actionButton setTitle:@"绑定支付宝" forState:UIControlStateNormal];
                }
                
                
                [self.accountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 23));
                    make.left.equalTo(self.contentView).offset(20);
                    make.top.equalTo(self.contentView).offset(20);
                }];
                
                [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.accountIcon.mas_right).offset(10);
                    make.right.equalTo(self.contentView).offset(-20);
                    make.height.mas_equalTo(30);
                    make.centerY.mas_equalTo(self.accountIcon.mas_centerY);
                }];
                
                [self.realNameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 23));
                    make.left.equalTo(self.contentView).offset(20);
                    make.top.equalTo(self.accountIcon.mas_bottom).offset(20);
                }];
                
                [self.realNameTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.realNameIcon.mas_right).offset(10);
                    make.right.equalTo(self.contentView).offset(-20);
                    make.height.mas_equalTo(30);
                    make.centerY.mas_equalTo(self.realNameIcon.mas_centerY);
                }];
                
                [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(10);
                    make.right.equalTo(self.contentView).offset(-10);
                    make.height.mas_equalTo(45);
                    CGFloat tap = -25;
                    if (IS_IPHONE_X) {
                        tap -= 34;
                    }
                    make.bottom.mas_equalTo(self.contentView).offset(tap);
                }];
            }break;
            case JSWithdrawAlertViewTypeWechat:{
                [self.contentView addSubview:self.accountIcon];

                [self.contentView addSubview:self.bindWechatLabel];
                [self.contentView addSubview:self.bindWechatButton];
                
                [self.contentView addSubview:self.realNameIcon];
                [self.contentView addSubview:self.realNameTextfield];
                [self.contentView addSubview:self.actionButton];
                if (self.isBindType) {
                    [self.actionButton setTitle:@"绑定微信" forState:UIControlStateNormal];
                }
                
                
                [self.accountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 23));
                    make.left.equalTo(self.contentView).offset(20);
                    make.top.equalTo(self.contentView).offset(20);
                }];
                
                [self.bindWechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(80, 30));
                    make.right.equalTo(self.contentView).offset(-20);
                    make.centerY.mas_equalTo(self.accountIcon.mas_centerY);
                }];
                
                [self.bindWechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.accountIcon.mas_right).offset(10);
                    make.right.mas_equalTo(self.bindWechatButton.mas_left).offset(-10);
                    make.height.mas_equalTo(30);
                    make.centerY.mas_equalTo(self.accountIcon.mas_centerY);
                }];
                
                [self.realNameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 23));
                    make.left.equalTo(self.contentView).offset(20);
                    make.top.equalTo(self.accountIcon.mas_bottom).offset(20);
                }];
                
                [self.realNameTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.realNameIcon.mas_right).offset(10);
                    make.right.equalTo(self.contentView).offset(-20);
                    make.height.mas_equalTo(30);
                    make.centerY.mas_equalTo(self.realNameIcon.mas_centerY);
                }];
                
                [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(10);
                    make.right.equalTo(self.contentView).offset(-10);
                    make.height.mas_equalTo(45);
                    CGFloat tap = -25;
                    if (IS_IPHONE_X) {
                        tap -= 34;
                    }
                    make.bottom.mas_equalTo(self.contentView).offset(tap);
                }];
                
            }break;
            case JSWithdrawAlertViewTypeBindIPhone:{
                [self.contentView addSubview:self.iconImageView];
                [self.contentView addSubview:self.alertLabel];
                [self.contentView addSubview:self.actionButton];
                
                if (self.isBindType) {
                    [self.actionButton setTitle:@"绑定手机号" forState:UIControlStateNormal];
                }
                
                [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(self.iconImageView.size);
                    make.top.mas_equalTo(20);
                    make.centerX.equalTo(self.contentView);
                }];
                
                [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(self.alertLabel.size);
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
                    make.centerX.mas_equalTo(self.iconImageView.mas_centerX);
                }];
                [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(10);
                    make.right.equalTo(self.contentView).offset(-10);
                    make.height.mas_equalTo(45);
                    CGFloat tap = -25;
                    if (IS_IPHONE_X) {
                        tap -= 34;
                    }
                    make.bottom.mas_equalTo(self.contentView).offset(tap);
                }];
                
            }break;
                
            default:
                break;
        }
        @weakify(self)
        [self.actionButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            
            switch (self.alertType) {
                case JSWithdrawAlertViewTypeAlipay:{
                    if (self.accountTextField.text.length > 0 && self.realNameTextfield.text.length > 0) {
                        [JSNetworkManager bindAlipayWithAlipayId:self.accountTextField.text realName:self.realNameTextfield.text complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
                            if (isSuccess) {
                                [self endEditing:YES];
                                [self removeFromSuperview];
                                if (self.actionBlock) {
                                    self.actionBlock(YES);
                                }
                            }
                        }];
                    }else{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                        
                        hud.mode = MBProgressHUDModeText;
                        hud.label.text = @"请输入支付宝账号或真实姓名";
                        [hud hideAnimated:YES afterDelay:2.f];
                    }
                }break;
                case JSWithdrawAlertViewTypeWechat:{
                    if (!self.isBindWechat) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                        
                        hud.mode = MBProgressHUDModeText;
                        hud.label.text = @"请先绑定微信";
                        [hud hideAnimated:YES afterDelay:2.f];
                        return ;
                    }
                    
                    if (self.realNameTextfield.text.length <= 0) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                        
                        hud.mode = MBProgressHUDModeText;
                        hud.label.text = @"请输入真实姓名";
                        [hud hideAnimated:YES afterDelay:2.f];
                        return;
                    }
                    
                    
                    
                }break;
                case JSWithdrawAlertViewTypeBindIPhone:{
                    JSBindIPhoneViewController *bindVC = [[JSBindIPhoneViewController alloc]init];
                    bindVC.codeType = JSRequestSecurityCodeTypeBindIPhone;
                    bindVC.complement = ^(BOOL isFinished) {
                        if (isFinished) {
                            [self endEditing:YES];
                            [self removeFromSuperview];
                            if (self.actionBlock) {
                                self.actionBlock(YES);
                            }
                        }
                    };
                    [self.viewController.rt_navigationController pushViewController:bindVC animated:YES complete:nil];
                    
                }break;
                    
                default:
                    break;
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    return self;
}
#pragma mark YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    //    [self.inputToolbar controlInputViewWithFirstResponder:[self.inputToolbar gg_isFirstResponder]];
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self];
    if (transition.animationDuration == 0) {
        self.contentView.bottom = CGRectGetMinY(toFrame);
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.contentView.bottom = CGRectGetMinY(toFrame);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
+ (void)showAlertViewWithSuperView:(UIView *)superView type:(JSWithdrawAlertViewType)type isBind:(BOOL)isBind handle:(void(^)(BOOL isSuccess))hande{
    JSWithdrawAlertView *alertView = [[JSWithdrawAlertView alloc]initWithFrame:superView.bounds type:type isBindType:isBind];
    alertView.actionBlock = hande;
    
    [superView addSubview:alertView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [self.contentView.layer convertPoint:point fromLayer:self.layer];
    
    if (![self.contentView.layer containsPoint:point]) {
        if ([self.accountTextField isFirstResponder] || [self.realNameTextfield isFirstResponder]) {
            [self endEditing:YES];
        }else{
            [self removeFromSuperview];
        }
    }
}

@end

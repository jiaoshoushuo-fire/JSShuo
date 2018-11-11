//
//  JSLoginViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/2.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSLoginViewController.h"
#import "JSForgetPasswordViewController.h"


@implementation JSLoginBottomView

- (UIView *)otherPlatformLeftLine{
    if (!_otherPlatformLeftLine) {
        _otherPlatformLeftLine = [[UIView alloc]init];
        _otherPlatformLeftLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }
    return _otherPlatformLeftLine;
}
- (UIView *)otherPlanformRightLine{
    if (!_otherPlanformRightLine) {
        _otherPlanformRightLine = [[UIView alloc]init];
        _otherPlanformRightLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }
    return _otherPlanformRightLine;
}
- (UILabel *)otherPlatfomTitle{
    if (!_otherPlatfomTitle) {
        _otherPlatfomTitle = [[UILabel alloc]init];
        _otherPlatfomTitle.textColor = [UIColor colorWithHexString:@"546D86"];
        _otherPlatfomTitle.font = [UIFont systemFontOfSize:14];
        _otherPlatfomTitle.text = @"第三方登录";
        _otherPlatfomTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _otherPlatfomTitle;
}
- (UIButton *)wechatLoginButton{
    if (!_wechatLoginButton) {
        _wechatLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatLoginButton.size = CGSizeMake(40, 40);
//        _wechatLoginButton.backgroundColor = [UIColor redColor];
        [_wechatLoginButton setImage:[UIImage imageNamed:@"js_login_wechat"] forState:UIControlStateNormal];
    }
    return _wechatLoginButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.otherPlatformLeftLine];
        [self addSubview:self.otherPlanformRightLine];
        [self addSubview:self.otherPlatfomTitle];
        [self addSubview:self.wechatLoginButton];
        
        [self.otherPlatfomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 20));
            make.centerX.equalTo(self);
            make.top.equalTo(self);
        }];
        [self.otherPlatformLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.mas_equalTo(self.otherPlatfomTitle.mas_left).offset(-25);
            make.height.mas_equalTo(1.0f);
            make.centerY.equalTo(self.otherPlatfomTitle.mas_centerY);
        }];
        [self.otherPlanformRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.otherPlatfomTitle.mas_right).offset(25);
            make.right.equalTo(self).offset(-10);
            make.height.mas_equalTo(1.0);
            make.centerY.equalTo(self.otherPlatfomTitle.mas_centerY);
        }];
        [self.wechatLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.mas_equalTo(self.otherPlatfomTitle.mas_bottom).offset(25);
            make.centerX.equalTo(self.otherPlatfomTitle.mas_centerX);
        }];
    }
    return self;
}
@end


@interface JSLoginViewController ()
@property (nonatomic, strong)UIImageView *accountIcon;
@property (nonatomic, strong)UITextField *accountTextField;
@property (nonatomic, strong)UIView *accountLine;

@property (nonatomic, strong)UIImageView *passwordIcon;
@property (nonatomic, strong)UITextField *passwordTextField;
@property (nonatomic, strong)UIView *passwordLine;

@property (nonatomic, strong)UIButton *forgetPasswordButton;
@property (nonatomic, strong)UIButton *securityCodeLoginButton;

@property (nonatomic, strong)UIButton *loginButton;

@property (nonatomic, strong)JSLoginBottomView *loginBottomView;
@end

@implementation JSLoginViewController

- (UIImageView *)accountIcon{
    if (!_accountIcon) {
        _accountIcon = [[UIImageView alloc]init];
        _accountIcon.image = [UIImage imageNamed:@"js_login_acount_icon"];
    }
    return _accountIcon;
}
- (UITextField *)accountTextField{
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc]init];
        _accountTextField.placeholder = @"请输入账号";
        _accountTextField.font = [UIFont systemFontOfSize:14];
        _accountTextField.keyboardType = UIKeyboardTypeNumberPad;
        _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _accountTextField;
}
- (UIView *)accountLine{
    if (!_accountLine) {
        _accountLine = [[UIView alloc]init];
        _accountLine.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
        _accountLine.height = 1;
    }
    return _accountLine;
}

- (UIImageView *)passwordIcon{
    if (!_passwordIcon) {
        _passwordIcon = [[UIImageView alloc]init];
        _passwordIcon.image = [UIImage imageNamed:@"js_login_password_icon"];
    }
    return _passwordIcon;
}
- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.font = [UIFont systemFontOfSize:14];
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
    }
    return _passwordTextField;
}

- (UIView *)passwordLine{
    if (!_passwordLine) {
        _passwordLine = [[UIView alloc]init];
        _passwordLine.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
        _passwordLine.height = 1;
    }
    return _passwordLine;
}

- (UIButton *)forgetPasswordButton{
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_forgetPasswordButton setTitleColor:[UIColor colorWithHexString:@"4A90E2"] forState:UIControlStateNormal];
        @weakify(self)
        [_forgetPasswordButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            JSForgetPasswordViewController *forgetVC = [[JSForgetPasswordViewController alloc]init];
            forgetVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:forgetVC animated:YES complete:nil];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPasswordButton;
}
- (UIButton *)securityCodeLoginButton{
    if (!_securityCodeLoginButton) {
        _securityCodeLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_securityCodeLoginButton setTitle:@"手机验证码登录" forState:UIControlStateNormal];
        _securityCodeLoginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_securityCodeLoginButton setTitleColor:[UIColor colorWithHexString:@"0D0D0D"] forState:UIControlStateNormal];
        
        @weakify(self)
        [_securityCodeLoginButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedPageControllerWithIndex:)]) {
                [self.delegate didSelectedPageControllerWithIndex:1];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _securityCodeLoginButton;
}

- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginButton.backgroundColor = [UIColor colorWithHexString:@"999999"];
        _loginButton.enabled = NO;
        @weakify(self)
        [_loginButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
- (JSLoginBottomView *)loginBottomView{
    if (!_loginBottomView) {
        _loginBottomView = [[JSLoginBottomView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 125)];
        @weakify(self)
        [_loginBottomView.wechatLoginButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.accountIcon];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.accountLine];
    
    [self.view addSubview:self.passwordIcon];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.passwordLine];
    
    [self.view addSubview:self.forgetPasswordButton];
    [self.view addSubview:self.securityCodeLoginButton];
    
    
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.loginBottomView];
    
    [self.accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.accountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 23));
        CGFloat tap = 37;
        if (kScreenWidth == 320) {
            tap = 20;
        }
        make.top.equalTo(self.view).offset(tap);
        make.left.equalTo(self.view).offset(10);
    }];
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountIcon.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.accountIcon.mas_centerY);
    }];
    
    [self.accountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.0);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.mas_equalTo(self.accountIcon.mas_bottom).offset(10);
    }];
    
    
    [self.passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 23));
        make.top.equalTo(self.accountLine.mas_bottom).offset(20);
        make.left.equalTo(self.accountIcon.mas_left);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordIcon.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.passwordIcon.mas_centerY);
    }];
    
    [self.passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.0);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.mas_equalTo(self.passwordIcon.mas_bottom).offset(10);
    }];
    
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.passwordLine.mas_bottom).offset(13);
    }];
    
    [self.securityCodeLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(self.forgetPasswordButton.mas_centerY);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(46);
        CGFloat tap = 30;
        if (kScreenWidth == 320) {
            tap = 20;
        }
        make.top.mas_equalTo(self.forgetPasswordButton.mas_bottom).offset(tap);
    }];
    [self.loginBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        CGFloat height = 125;
        if (kScreenWidth == 320) {
            height = 105;
        }
        make.height.mas_equalTo(height);
        CGFloat bottomOffset = IS_IPHONE_X ? 34 : 0;
        make.bottom.equalTo(self.view).offset(bottomOffset);
    }];
}

- (void) textFieldDidChange:(UITextField *) textField {
    
    if (self.accountTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.loginButton.enabled = YES;
        self.loginButton.backgroundColor = [UIColor colorWithHexString:@"F44336"];
    }else{
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end

//
//  JSRegisterViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/2.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSRegisterViewController.h"
#import "JSNetworkManager+Login.h"

@interface JSRegisterViewController ()
@property (nonatomic, strong)UIImageView *accountIcon;
@property (nonatomic, strong)UITextField *accountTextField;
@property (nonatomic, strong)UIView *accountLine;

@property (nonatomic, strong)UIImageView *passwordIcon;
@property (nonatomic, strong)UITextField *passwordTextField;
@property (nonatomic, strong)UIView *passwordLine;

@property (nonatomic, strong)UIView *securityCodeButtonLeftLine;
@property (nonatomic, strong)UIButton *securityCodeButton;

@property (nonatomic, strong)YYLabel *agreementLabel;
@property (nonatomic, strong)UIButton *registerButton;
@property (nonatomic, strong)YYLabel *gologinLabel;

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger timeCount;

@property (nonatomic, strong)JSLoginBottomView *loginBottomView;

@end

@implementation JSRegisterViewController

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
        _accountTextField.placeholder = @"请输入手机号";
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
        _passwordTextField.placeholder = @"请输入验证码";
        _passwordTextField.font = [UIFont systemFontOfSize:14];
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
- (UIView *)securityCodeButtonLeftLine{
    if (!_securityCodeButtonLeftLine) {
        _securityCodeButtonLeftLine = [[UIView alloc]init];
        _securityCodeButtonLeftLine.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
        _securityCodeButtonLeftLine.height = 1;
    }
    return _securityCodeButtonLeftLine;
}
- (UIButton *)securityCodeButton{
    if (!_securityCodeButton) {
        _securityCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_securityCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _securityCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_securityCodeButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _securityCodeButton.enabled = NO;
        @weakify(self)
        [_securityCodeButton bk_addEventHandler:^(UIButton *sender) {
            @strongify(self)
            [JSNetworkManager requestSecurityCodeWithPhoneNumber:self.accountTextField.text type:JSRequestSecurityCodeTypeLogin complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
                if (isSuccess) {
                    if ([self.timer isValid]) {
                        [self.timer invalidate];
                        self.timer = nil;
                    }
                    sender.enabled = NO;
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
                        
                        if (self.timeCount == 0) {
                            self.timeCount = 60;
                            [timer invalidate];
                            timer = nil;
                            [sender setTitle:@"重发" forState:UIControlStateNormal];
                            [self textFieldDidChange:self.accountTextField];
                        }else{
                            self.timeCount -- ;
                            [sender setTitle:[NSString stringWithFormat:@"%@s",@(self.timeCount)] forState:UIControlStateNormal];
                        }
                        
                    } repeats:YES];
                }
            }];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _securityCodeButton;
}
- (YYLabel *)agreementLabel{
    if (!_agreementLabel) {
        _agreementLabel = [[YYLabel alloc]init];
        _agreementLabel.displaysAsynchronously = YES;
        _agreementLabel.ignoreCommonProperties = YES;
        
        
        _agreementLabel.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"agreem highlight tap");
        };
        
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setImage:[UIImage imageNamed:@"js_agree_selected"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"js_agree_selected"] forState:UIControlStateSelected];
        [selectButton sizeToFit];
        @weakify(self)
        [selectButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            NSLog(@"agreem selectbutton tap");
        } forControlEvents:UIControlEventTouchUpInside];
        
        NSString *string_1 = @"我已阅读并同意";
        NSString *string_2 = @"《用户协议》";
        
        NSMutableAttributedString *textString = [self stringWithContent:selectButton string:string_1 highlightString:string_2];
        
        [textString setColor:[UIColor colorWithHexString:@"999999"] range:[textString.string rangeOfString:string_1]];
        [textString setColor:[UIColor colorWithHexString:@"E81E2D"] range:[textString.string rangeOfString:string_2]];
        textString.font = [UIFont systemFontOfSize:12];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAXFLOAT, 25) text:textString];
        
        [_agreementLabel setTextLayout:layout];
        _agreementLabel.size = layout.textBoundingSize;
        
    }
    return _agreementLabel;
}
- (UIButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [_registerButton setTitle:@"登录" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        @weakify(self)
        [_registerButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            [JSNetworkManager loginAccountNumberWithPhoneNumber:self.accountTextField.text securityCode:self.passwordTextField.text complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
                if (isSuccess) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginSuccessComplement)]) {
                        [self.delegate didLoginSuccessComplement];
                    }
                }
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (YYLabel *)gologinLabel{
    if (!_gologinLabel) {
        _gologinLabel = [[YYLabel alloc]init];
        _gologinLabel = [[YYLabel alloc]init];
        _gologinLabel.displaysAsynchronously = YES;
        _gologinLabel.ignoreCommonProperties = YES;
        
        @weakify(self)
        _gologinLabel.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedPageControllerWithIndex:)]) {
                [self.delegate didSelectedPageControllerWithIndex:0];
            }
            NSLog(@"gologinLabel highlight tap");
            
        };
        
        NSString *string_1 = @"已有账号？";
        NSString *string_2 = @" 去登录>";
        NSMutableAttributedString *textString = [self stringWithContent:nil string:string_1 highlightString:string_2];
        
        [textString setColor:[UIColor colorWithHexString:@"546D86"] range:[textString.string rangeOfString:string_1]];
        [textString setColor:[UIColor colorWithHexString:@"E81E2D"] range:[textString.string rangeOfString:string_2]];
        textString.font = [UIFont systemFontOfSize:14];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAXFLOAT, 25) text:textString];
        
        [_gologinLabel setTextLayout:layout];
        _gologinLabel.size = layout.textBoundingSize;
    }
    return _gologinLabel;
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.timeCount = 60;
    
    [self.view addSubview:self.accountIcon];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.accountLine];
    
    [self.view addSubview:self.passwordIcon];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.passwordLine];
    
    [self.view addSubview:self.securityCodeButtonLeftLine];
    [self.view addSubview:self.securityCodeButton];
    
    [self.view addSubview:self.agreementLabel];
    [self.view addSubview:self.registerButton];
//    [self.view addSubview:self.gologinLabel];
    
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
        make.right.equalTo(self.securityCodeButtonLeftLine.mas_left).offset(-10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.passwordIcon.mas_centerY);
    }];
    
    [self.passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.0);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.mas_equalTo(self.passwordIcon.mas_bottom).offset(10);
    }];
    
    [self.securityCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 25));
        make.right.equalTo(self.view).offset(-10);
        make.centerY.mas_equalTo(self.passwordIcon.mas_centerY);
    }];
    
    [self.securityCodeButtonLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 22));
        make.right.equalTo(self.securityCodeButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.passwordIcon.mas_centerY);
    }];
    
    [self.agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.agreementLabel.size);
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.passwordLine.mas_bottom).offset(20);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(46);
        
        make.top.mas_equalTo(self.agreementLabel.mas_bottom).offset(10);
    }];
    
//    [self.gologinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(self.gologinLabel.size);
//        make.top.mas_equalTo(self.registerButton.mas_bottom).offset(18);
//        make.centerX.mas_equalTo(self.registerButton.mas_centerX);
//    }];
    
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


- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    
    //    联通号段:130/131/132/155/156/185/186/145/176
    
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
    
}
- (BOOL)checkAccount{
    NSString *account = [self.accountTextField text];
    return [self isMobileNumber:account];
}
- (void) textFieldDidChange:(UITextField *) textField {
    if ([self checkAccount]) {
        if (![self.timer isValid]) {
            self.securityCodeButton.enabled = YES;
            [self.securityCodeButton setTitleColor:[UIColor colorWithHexString:@"4A90E2"] forState:UIControlStateNormal];
        }
    }else{
        self.securityCodeButton.enabled = NO;
        [self.securityCodeButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    }
    
    if ([self checkAccount] && self.passwordTextField.text.length > 0 ) {
        self.registerButton.enabled = YES;
        self.registerButton.backgroundColor = [UIColor colorWithHexString:@"F44336"];
        
    }else{
        self.registerButton.enabled = NO;
        self.registerButton.backgroundColor = [UIColor colorWithHexString:@"999999"];
        
    }
    
}

- (void)setHighlightInfo:(NSDictionary*)info withRange:(NSRange)range toText:(NSMutableAttributedString *)text {
    if (range.length == 0 || text.length == 0) return;
    {
        NSString *str = text.string;
        unichar *chars = malloc(str.length * sizeof(unichar));
        if (!chars) return;
        [str getCharacters:chars range:NSMakeRange(0, str.length)];
        
        NSUInteger start = range.location, end = range.location + range.length;
        for (int i = 0; i < str.length; i++) {
            unichar c = chars[i];
            if (0xD800 <= c && c <= 0xDBFF) { // UTF16 lead surrogates
                if (start > i) start++;
                if (end > i) end++;
            }
        }
        free(chars);
        if (end <= start) return;
        range = NSMakeRange(start, end - start);
    }
    
    if (range.location >= text.length) return;
    if (range.location + range.length > text.length) return;
    
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 3;
    border.insets = UIEdgeInsetsMake(-2, -2, -2, -2);
    border.fillColor = [UIColor colorWithHexString:@"ebeef0"];
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setBackgroundBorder:border];
    highlight.userInfo = info;
    
    [text setTextHighlight:highlight range:range];
    [text setColor:[UIColor colorWithHexString:@"E81E2D"] range:range];
}

- (NSMutableAttributedString *)stringWithContent:(UIButton *)button string:(NSString *)string highlightString:(NSString *)highlightString{
    NSMutableAttributedString *reslutString = [[NSMutableAttributedString alloc]initWithString:@""];
    if (button) {
        NSMutableAttributedString *imageAttributeString = [NSMutableAttributedString attachmentStringWithContent:button contentMode:UIViewContentModeCenter attachmentSize:button.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
        [reslutString appendAttributedString:imageAttributeString];
        [reslutString appendString:@" "];
    }
    [reslutString appendString:string];
    [reslutString appendString:highlightString];
    
    
    [self setHighlightInfo:@{} withRange:[reslutString.string rangeOfString:highlightString] toText:reslutString];
    return reslutString;
}
- (void)stopTimerIfNeed{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end

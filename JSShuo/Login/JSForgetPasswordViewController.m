//
//  JSForgetPasswordViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/2.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSForgetPasswordViewController.h"

@interface JSForgetPasswordViewController ()
@property (nonatomic, strong)UITextField *phoneNumberTextField;
@property (nonatomic, strong)UIView *line1;
@property (nonatomic, strong)UIButton *getSecurityCodeButton;
@property (nonatomic, strong)UITextField *securityTextfield;

@property (nonatomic, strong)UIView *line2;
@property (nonatomic, strong)UITextField *passwordTextField;
@property (nonatomic, strong)UIView *line3;
@property (nonatomic, strong)UITextField *passwordTestField2;
@property (nonatomic, strong)UIView *line4;

@property (nonatomic, strong)UIButton *completeButton;

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger timeCount;
@end

@implementation JSForgetPasswordViewController

- (UITextField *)phoneNumberTextField{
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[UITextField alloc]init];
        _phoneNumberTextField.placeholder = @"请输入手机号";
        _phoneNumberTextField.font = [UIFont systemFontOfSize:14];
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _phoneNumberTextField;
}

- (UIButton *)getSecurityCodeButton{
    if (!_getSecurityCodeButton) {
        _getSecurityCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getSecurityCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _getSecurityCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_getSecurityCodeButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _getSecurityCodeButton.enabled = NO;
        @weakify(self)
        [_getSecurityCodeButton bk_addEventHandler:^(UIButton *sender) {
            @strongify(self)
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
                    [self textFieldDidChange:self.phoneNumberTextField];
                }else{
                    self.timeCount -- ;
                    [sender setTitle:[NSString stringWithFormat:@"%@s",@(self.timeCount)] forState:UIControlStateNormal];
                }
                
            } repeats:YES];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _getSecurityCodeButton;
}
- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc]init];
        _line1.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
    }
    return _line1;
}

- (UITextField *)securityTextfield{
    if (!_securityTextfield) {
        _securityTextfield = [[UITextField alloc]init];
        _securityTextfield.placeholder = @"请输入验证码";
        _securityTextfield.font = [UIFont systemFontOfSize:14];
        _securityTextfield.keyboardType = UIKeyboardTypeNumberPad;
        _securityTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _securityTextfield;
}
- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc]init];
        _line2.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
    }
    return _line2;
}

- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.font = [UIFont systemFontOfSize:14];
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

- (UIView *)line3{
    if (!_line3) {
        _line3 = [[UIView alloc]init];
        _line3.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
    }
    return _line3;
}
- (UITextField *)passwordTestField2{
    if (!_passwordTestField2) {
        _passwordTestField2 = [[UITextField alloc]init];
        _passwordTestField2.placeholder = @"请再次输入密码";
        _passwordTestField2.font = [UIFont systemFontOfSize:14];
        _passwordTestField2.keyboardType = UIKeyboardTypeASCIICapable;
        
        _passwordTestField2.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _passwordTestField2.secureTextEntry = YES;
    }
    return _passwordTestField2;
}

- (UIView *)line4{
    if (!_line4) {
        _line4 = [[UIView alloc]init];
        _line4.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
    }
    return _line4;
}
- (UIButton *)completeButton{
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _completeButton.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        @weakify(self)
        [_completeButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.timeCount = 60;
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.securityTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTestField2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:self.phoneNumberTextField];
    [self.view addSubview:self.getSecurityCodeButton];
    [self.view addSubview:self.line1];
    
    [self.view addSubview:self.securityTextfield];
    [self.view addSubview:self.line2];
    
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.line3];
    
    [self.view addSubview:self.passwordTestField2];
    [self.view addSubview:self.line4];
    
    [self.view addSubview:self.completeButton];
    
    [self.getSecurityCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 25));
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(50);
    }];
    
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.getSecurityCodeButton.mas_left).offset(-10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.getSecurityCodeButton.mas_centerY);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(1.0f);
        make.top.mas_equalTo(self.phoneNumberTextField.mas_bottom).offset(10);
    }];
    
    [self.securityTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(10);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(1.0f);
        make.top.mas_equalTo(self.securityTextfield.mas_bottom).offset(10);
    }];

    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(10);
    }];

    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(1.0f);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(10);
    }];

    [self.passwordTestField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.line3.mas_bottom).offset(10);
    }];

    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(1.0f);
        make.top.mas_equalTo(self.passwordTestField2.mas_bottom).offset(10);
    }];
    
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(46);
        
        make.top.mas_equalTo(self.line4.mas_bottom).offset(50);
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimerIfNeed];
}

- (void)stopTimerIfNeed{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
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
    NSString *account = [self.phoneNumberTextField text];
    return [self isMobileNumber:account];
}

- (void) textFieldDidChange:(UITextField *) textField {
    if ([self checkAccount]) {
        if (![self.timer isValid]) {
            self.getSecurityCodeButton.enabled = YES;
            [self.getSecurityCodeButton setTitleColor:[UIColor colorWithHexString:@"4A90E2"] forState:UIControlStateNormal];
        }
    }else{
        self.getSecurityCodeButton.enabled = NO;
        [self.getSecurityCodeButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    }
    
    if ([self checkAccount] && self.securityTextfield.text.length > 0 && self.passwordTextField.text.length > 0 && self.passwordTestField2.text.length > 0) {
        self.completeButton.enabled = YES;
        self.completeButton.backgroundColor = [UIColor colorWithHexString:@"F44336"];
        
    }else{
        self.completeButton.enabled = NO;
        self.completeButton.backgroundColor = [UIColor colorWithHexString:@"999999"];
        
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

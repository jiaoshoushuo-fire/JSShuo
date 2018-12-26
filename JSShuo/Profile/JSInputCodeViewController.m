//
//  JSInputCodeViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/18.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSInputCodeViewController.h"
#import "JSNetworkManager+Login.h"
#import "JSAccountManager+Wechat.h"
#import "JSAlertView.h"

@interface JSInputCodeViewController ()
@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, strong)UIButton *bindWechatButton;
@property (nonatomic, strong)UILabel *titleLable;
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UILabel *bottomLabel;
@property (nonatomic, strong)UILabel *bottom_Label_2;
@property (nonatomic, strong)UIImageView *inputBackImageView;

@property (nonatomic, strong)UIButton *openButton;
@property (nonatomic, strong)UIButton *wechatButton;
@property (nonatomic, strong)UILabel *weachtLabel;
@property (nonatomic, strong)UILabel *wechatStatusLabel;

@end

@implementation JSInputCodeViewController

- (UIImageView *)inputBackImageView{
    if (!_inputBackImageView) {
        _inputBackImageView = [[UIImageView alloc]init];
        _inputBackImageView.image = [UIImage imageNamed:@"js_input_back"];
        [_inputBackImageView sizeToFit];
    }
    return _inputBackImageView;
}
- (UIButton *)wechatButton{
    if (!_wechatButton) {
        _wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wechatButton setImage:[UIImage imageNamed:@"js_bind_wechat"] forState:UIControlStateNormal];
        [_wechatButton sizeToFit];
        @weakify(self)
        [_wechatButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            [JSAccountManager wechatAuthorizeFromLogin:NO completion:^(BOOL success) {
                if (success) {
                    [self checkBindWechatInfo];
                }
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatButton;
}
- (UILabel *)weachtLabel{
    if (!_weachtLabel) {
        _weachtLabel = [[UILabel alloc]init];
        _weachtLabel.font = [UIFont systemFontOfSize:12];
        _weachtLabel.textColor = [UIColor whiteColor];
        _weachtLabel.text = @"绑定微信";
        [_weachtLabel sizeToFit];
    }
    return _weachtLabel;
}
- (UILabel *)wechatStatusLabel{
    if (!_wechatStatusLabel) {
        _wechatStatusLabel = [[UILabel alloc]init];
        _wechatStatusLabel.font = [UIFont systemFontOfSize:12];
        _wechatStatusLabel.textColor = [UIColor whiteColor];
        _wechatStatusLabel.textAlignment = NSTextAlignmentCenter;
        _wechatStatusLabel.size = CGSizeMake(50, 30);
    }
    return _wechatStatusLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入邀请码" attributes:
                                          @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                            NSFontAttributeName:[UIFont systemFontOfSize:15]
                                            }];
        _textField.attributedPlaceholder = attrString;
        _textField.textColor = [UIColor whiteColor];
        
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.clipsToBounds = YES;
        _textField.layer.cornerRadius = 15;
    }
    return _textField;
}
- (UIButton *)openButton{
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openButton.size = CGSizeMake(100, 100);
//        _openButton.backgroundColor = [UIColor cyanColor];
//        _openButton.alpha = 0.5;
        @weakify(self)
        [_openButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            //
            if (self.textField.text.length > 0) {
                [self showWaitingHUD];
                [JSNetworkManager requestCreateApprenticeWithInvitateCode:self.textField.text complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
                    [self hideWaitingHUD];
                    if (isSuccess) {
                        //这里需要弹出奖励alert 现在接口没有model

//                        NSDictionary *rewardDict = contentDict[@"reward"];
//
//                        [JSTool showAlertType:JSALertTypeFirstLoginIn withRewardDictiony:rewardDict];
                        
//                        [self performSelector:@selector(dismissSelfVC) withObject:nil afterDelay:2];
                    }
                }];
            }else{
                [self showAutoDismissTextAlert:@"请输入邀请码"];
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}
- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.textColor = [UIColor colorWithHexString:@"ECB68D"];
        _titleLable.font = [UIFont systemFontOfSize:12];
        _titleLable.text = @"输入好友邀请码可以领取红包";
        [_titleLable sizeToFit];
    }
    return _titleLable;
}
- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _bottomLabel.text = @"    叫兽说禁止用户使用非正常途径包括但不限于手机模拟器，改号软件等方式虚假收徒。一经发现，叫兽说有权收回所有奖励";
        CGFloat height = [_bottomLabel sizeThatFits:CGSizeMake(kScreenWidth-60, MAXFLOAT)].height;
        _bottomLabel.size = CGSizeMake(kScreenWidth-60, height);
        
    }
    return _bottomLabel;
}
- (UILabel *)bottom_Label_2{
    if (!_bottom_Label_2) {
        _bottom_Label_2 = [[UILabel alloc]init];
        _bottom_Label_2.font = [UIFont systemFontOfSize:12];
        _bottom_Label_2.numberOfLines = 0;
        _bottom_Label_2.textColor = [UIColor colorWithHexString:@"EE9714"];
        _bottom_Label_2.text = @"输入您好友的邀请码并绑定微信点击‘拆’可以领取最高88零钱大红包，好运等你来";
        CGFloat height = [_bottom_Label_2 sizeThatFits:CGSizeMake(kScreenWidth-60, MAXFLOAT)].height;
        _bottom_Label_2.size = CGSizeMake(kScreenWidth-60, height);
    }
    return _bottom_Label_2;
}
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"js_profile_input_back"];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}
- (void)dismissSelfVC{
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入邀请码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.inputBackImageView];
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.textField];
    
    [self.view addSubview:self.bottomLabel];
    [self.view addSubview:self.bottom_Label_2];
    
    
    [self.view addSubview:self.openButton];
    
    [self.view addSubview:self.wechatStatusLabel];
    [self.view addSubview:self.wechatButton];
    [self.view addSubview:self.weachtLabel];
    
    [self.weachtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.weachtLabel.size);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.openButton.mas_bottom).offset(50);
    }];
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.wechatButton.size);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.weachtLabel.mas_bottom).offset(20);
    }];
    
    [self.wechatStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.wechatStatusLabel.size);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.wechatButton.mas_bottom).offset(50);
    }];
    
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.openButton.size);
        make.centerY.mas_equalTo(self.backImageView).multipliedBy(0.38*2);
        make.centerX.equalTo(self.view);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.bottomLabel.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bottom_Label_2.mas_bottom).offset(10);
    }];
    [self.bottom_Label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.bottom_Label_2.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.backImageView.mas_bottom).offset(15);
    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(self.backImageView.mas_width).dividedBy(0.75);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleLable.size);
        make.top.equalTo(self.view).offset(60);
        make.centerX.equalTo(self.view);
    }];
    [self.inputBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.inputBackImageView.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLable.mas_bottom).offset(10);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBackImageView.mas_left).offset(10);
        make.right.equalTo(self.inputBackImageView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.inputBackImageView.mas_centerY);
    }];
    [self checkBindWechatInfo];
    // Do any additional setup after loading the view.
}

- (void)checkBindWechatInfo{
    [JSNetworkManager queryUserInformationWitchComplement:^(BOOL isSuccess, JSProfileUserModel * _Nonnull userModel) {
        if (isSuccess) {
            if (userModel.isWechatBind == 1) {
                self.wechatStatusLabel.text = @"已绑定";
                self.wechatButton.enabled = NO;
            }else{
                self.wechatStatusLabel.text = @"去绑定";
                self.wechatButton.enabled = YES;
            }
        }
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end

//
//  JSConvertViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/16.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSConvertViewController.h"
#import "JSNetworkManager+Login.h"

@interface JSConvertViewController ()
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UILabel *titleLabel_1;
@property (nonatomic, strong)UILabel *moneyLabel;
@property (nonatomic, strong)UILabel *titleLabel_2;
@property (nonatomic, strong)UILabel *subLabel_2;
@property (nonatomic, strong)UILabel *titleLabel_3;
@property (nonatomic, strong)UITextField *inputTextField;
@property (nonatomic, strong)UILabel *titleLabel_4;
@property (nonatomic, strong)UILabel *subLabel_4;

@property (nonatomic, strong)UIView *line_1;
@property (nonatomic, strong)UIView *line_2;
@property (nonatomic, strong)UIView *line_3;

@property (nonatomic, strong)UIButton *exchangeButton;
@end

@implementation JSConvertViewController

- (UIView *)line_1{
    if (!_line_1) {
        _line_1 = [[UIView alloc]init];
        _line_1.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    }
    return _line_1;
}
- (UIView *)line_2{
    if (!_line_2) {
        _line_2 = [[UIView alloc]init];
        _line_2.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    }
    return _line_2;
}
- (UIView *)line_3{
    if (!_line_3) {
        _line_3 = [[UIView alloc]init];
        _line_3.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    }
    return _line_3;
}
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _topView;
}
- (UILabel *)titleLabel_1{
    if (!_titleLabel_1) {
        _titleLabel_1 = [[UILabel alloc]init];
        _titleLabel_1.font = [UIFont systemFontOfSize:12];
        _titleLabel_1.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel_1.text = @"当前零钱";
        [_titleLabel_1 sizeToFit];
    }
    return _titleLabel_1;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"F44336"];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:20];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}
- (UILabel *)titleLabel_2{
    if (!_titleLabel_2) {
        _titleLabel_2 = [[UILabel alloc]init];
        _titleLabel_2.font = [UIFont systemFontOfSize:16];
        _titleLabel_2.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel_2.text = @"汇率";
        [_titleLabel_2 sizeToFit];
    }
    return _titleLabel_2;
}
- (UILabel *)subLabel_2{
    if (!_subLabel_2) {
        _subLabel_2 = [[UILabel alloc]init];
        _subLabel_2.font = [UIFont systemFontOfSize:16];
        _subLabel_2.textColor = [UIColor colorWithHexString:@"666666"];
        _subLabel_2.textAlignment = NSTextAlignmentCenter;
        
    }
    return _subLabel_2;
}

- (UILabel *)titleLabel_3{
    if (!_titleLabel_3) {
        _titleLabel_3 = [[UILabel alloc]init];
        _titleLabel_3.font = [UIFont systemFontOfSize:16];
        _titleLabel_3.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel_3.text = @"请输入用于兑换的零钱";
        [_titleLabel_3 sizeToFit];
    }
    return _titleLabel_3;
}

- (UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc]init];
        _inputTextField.font = [UIFont systemFontOfSize:16];
        _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return _inputTextField;
}

- (UILabel *)titleLabel_4{
    if (!_titleLabel_4) {
        _titleLabel_4 = [[UILabel alloc]init];
        _titleLabel_4.font = [UIFont systemFontOfSize:16];
        _titleLabel_4.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel_4.text = @"您可获得的金币";
        [_titleLabel_4 sizeToFit];
    }
    return _titleLabel_4;
}

- (UILabel *)subLabel_4{
    if (!_subLabel_4) {
        _subLabel_4 = [[UILabel alloc]init];
        _subLabel_4.font = [UIFont systemFontOfSize:16];
        _subLabel_4.textColor = [UIColor colorWithHexString:@"666666"];
        _subLabel_4.textAlignment = NSTextAlignmentCenter;
        
    }
    return _subLabel_4;
}
- (UIButton *)exchangeButton{
    if (!_exchangeButton) {
        _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeButton.size = CGSizeMake(kScreenWidth-20, 45);
        [_exchangeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        [_exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exchangeButton setBackgroundImage:[UIImage imageNamed:@"js_tixian_back_image"] forState:UIControlStateNormal];
        @weakify(self)
        [_exchangeButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            NSInteger money = 0;
            if (self.inputTextField.text.length > 0) {
                if (self.accountModel.money >= self.inputTextField.text.integerValue * 100) {
                    money = self.inputTextField.text.integerValue * 100;
                }else{
                    [self showAutoDismissTextAlert:@"您还没有这么多零钱"];
                    return ;
                }
            }else{
                money = self.accountModel.money;
            }
            [JSNetworkManager exchangeWithMoney:money complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
                if (isSuccess) {
                    [self showAutoDismissTextAlert:@"兑换成功"];
                    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:2];
                }
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeButton;
}
- (void)dismissViewController{
    [self.rt_navigationController popViewControllerAnimated:YES complete:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didRefreshWithdrawViewController)]) {
            [self.delegate didRefreshWithdrawViewController];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.titleLabel_1];
    [self.topView addSubview:self.moneyLabel];
    
    [self.view addSubview:self.titleLabel_2];
    [self.view addSubview:self.subLabel_2];
    [self.view addSubview:self.titleLabel_3];
    [self.view addSubview:self.inputTextField];
    [self.view addSubview:self.titleLabel_4];
    [self.view addSubview:self.subLabel_4];
    [self.view addSubview:self.line_1];
    [self.view addSubview:self.line_2];
    [self.view addSubview:self.line_3];
    
    [self.view addSubview:self.exchangeButton];
    
    [self.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(70);
    }];
    [self.titleLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleLabel_1.size);
        make.left.equalTo(self.topView).offset(20);
        make.centerY.equalTo(self.topView);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).offset(-20);
        make.left.mas_equalTo(self.titleLabel_1.mas_left).offset(10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.titleLabel_1.mas_centerY);
    }];
    
    [self.titleLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleLabel_2.size);
        make.left.equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(10);
    }];
    
    [self.subLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.left.mas_equalTo(self.titleLabel_2.mas_right).offset(10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.titleLabel_2.mas_centerY);
    }];
    
    [self.titleLabel_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleLabel_3.size);
        make.left.equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.titleLabel_2.mas_bottom).offset(20);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.left.mas_equalTo(self.titleLabel_3.mas_right).offset(10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.titleLabel_3.mas_centerY);
    }];
    
    [self.titleLabel_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleLabel_4.size);
        make.left.equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.titleLabel_3.mas_bottom).offset(20);
    }];
    
    [self.subLabel_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.left.mas_equalTo(self.titleLabel_4.mas_right).offset(10);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.titleLabel_4.mas_centerY);
    }];

    [self.line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.titleLabel_2.mas_bottom).offset(10);
    }];
    [self.line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.titleLabel_3.mas_bottom).offset(10);
    }];
    [self.line_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.titleLabel_4.mas_bottom).offset(10);
    }];
    
    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-20, 45));
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.titleLabel_4.mas_bottom).offset(40);
    }];
    // Do any additional setup after loading the view.
    [self configModel:self.accountModel];
}


- (void)configModel:(JSAccountModel *)model{
    self.moneyLabel.text = [NSString stringWithFormat:@"%0.2f",model.money/100.0f];
    self.subLabel_2.text = [NSString stringWithFormat:@"1零钱=%@金币",@(model.exchangeRate * 100)];
    self.inputTextField.placeholder = [NSString stringWithFormat:@"%0.2f",model.money/100.0f];
    self.subLabel_4.text = @(model.money/100.0f * 1 * model.exchangeRate * 100).stringValue;
}


- (void) textFieldDidChange:(UITextField *) textField {
    
    self.subLabel_4.text = @(textField.text.integerValue * 1 * _accountModel.exchangeRate * 100).stringValue;
}
@end

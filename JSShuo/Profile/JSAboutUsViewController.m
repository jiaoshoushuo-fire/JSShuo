//
//  JSAboutUsViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/12.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAboutUsViewController.h"

@interface JSAboutUsViewController ()
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIButton *button1;
@property (nonatomic, strong)UIButton *button2;
@end

@implementation JSAboutUsViewController

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"js_app_icon"];
        _iconImageView.size = CGSizeMake(100, 100);
    }
    return _iconImageView;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        NSString *textString = @"    叫兽说是一款主打轻松，搞笑以及健康的两性的内容性APP，让用户的碎片时间过的更有意义。";
        CGFloat height = [textString heightForFont:_contentLabel.font width:kScreenWidth - 50];
        _contentLabel.text = textString;
        _contentLabel.numberOfLines = 0;
        _contentLabel.size = CGSizeMake(kScreenWidth - 50, height+1);
    }
    return _contentLabel;
}
- (UIButton *)button1{
    if (!_button1) {//2896941882
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button1 setTitle:@"联系客服QQ：2896941882" forState:UIControlStateNormal];
        _button1.backgroundColor = [UIColor colorWithHexString:@"F44336"];
        [_button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button1.titleLabel.font = [UIFont systemFontOfSize:16];
        _button1.size = CGSizeMake(kScreenWidth-50, 45);
        _button1.clipsToBounds = YES;
        _button1.layer.cornerRadius = 5;
        @weakify(self)
        [_button1 bk_addEventHandler:^(id sender) {
            @strongify(self)
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
                NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"2896941882"]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                [webView loadRequest:request];
                [self.view addSubview:webView];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}
- (UIButton *)button2{
    if (!_button2) {
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button2 setTitle:@"商务洽谈邮箱：2896941882@qq.com" forState:UIControlStateNormal];
        _button2.backgroundColor = [UIColor blackColor];
        [_button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button2.titleLabel.font = [UIFont systemFontOfSize:16];
        _button2.size = CGSizeMake(kScreenWidth-50, 45);
        _button2.clipsToBounds = YES;
        _button2.layer.cornerRadius = 5;
    }
    return _button2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconImageView.size);
        make.top.mas_equalTo(50);
        make.centerX.equalTo(self.view);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.contentLabel.size);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.iconImageView.mas_centerX);
    }];
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.button1.size);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.contentLabel.mas_centerX);
    }];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.button2.size);
        make.top.mas_equalTo(self.button1.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.button1.mas_centerX);
    }];
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

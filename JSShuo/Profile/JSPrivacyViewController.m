//
//  JSPrivacyViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/12.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSPrivacyViewController.h"

@interface JSPrivacyViewController ()
@property (nonatomic, strong)UIWebView *webView;
@end

@implementation JSPrivacyViewController

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"隐私协议";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
    [self.webView loadRequest:request];
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

//
//  JSBaseWebViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/25.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseWebViewController.h"

@interface JSBaseWebViewController ()
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, copy)NSString *currentUrl;
@end

@implementation JSBaseWebViewController

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.currentUrl = url;
    }
    return self;
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentUrl]];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
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

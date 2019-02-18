//
//  JSCircleMyDetailViewController.m
//  JSShuo
//
//  Created by li que on 2019/2/15.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import "JSCircleMyDetailViewController.h"
#import <WebKit/WebKit.h>
#import "JSDetailNavView.h"
#import "JSNetworkManager+Recommend.h"
#import "JSNetworkManager+Poster.h"

@interface JSCircleMyDetailViewController () <WKNavigationDelegate,WKUIDelegate>
{
//    CGFloat wkWebViewHeight;
}
@property (nonatomic,strong) WKWebView *wkWebView;
@property (nonatomic,strong) JSDetailNavView *navView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JSCircleMyDetailViewController

- (void)viewDidDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupWebView];
    self.title = @"帖子";
}

- (void) addBottomBtn {
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
    deleteBtn.frame = CGRectMake(0, ScreenHeight-48, ScreenWidth, 48);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn setTitleColor:[UIColor colorWithHexString:@"F44336"] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor colorWithHexString:@"F44336"] forState:UIControlStateSelected];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.view addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(0);
    }];
    [deleteBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [JSNetworkManager deleteCircleWithID:self.articleId.stringValue complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
            if (isSuccess) {
                [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
            } else {
                NSLog(@"删除失败");
            }
        }];
    }];
}

- (void) setupWebView {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(rewardArticle:) userInfo:nil repeats:NO];
//    wkWebViewHeight = 0.f;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/v1/page/poster/%@",Base_Url,self.articleId]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:urlRequest];
    [self showWaitingHUD];
}

- (void) rewardArticle:(NSTimer *)timer {
    [self.timer invalidate];
    self.timer = nil;
    NSString *token = [JSAccountManager shareManager].accountToken;
    if (token && token.length > 0) {
        NSDictionary *param;
        if (token) {
            param = @{@"token":[JSAccountManager shareManager].accountToken,@"articleId":self.articleId};
            [JSNetworkManager requestRewardArticleWithParams:param complent:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
                [JSTool showAlertWithRewardDictiony:contentDic handle:^{
                    
                }];
            }];
        }
    }
}

#pragma mark ------ < UIScrollViewDeltegate > ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /**  < 解决web白屏问题 >  */
    /**  < 需要调用私有API：_updateVisibleContentRects >  */
    [self.wkWebView setNeedsLayout];
}

#pragma mark ------ < WKUIDelegate,WKNavigationDelegate > ------
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hideWaitingHUD];
    
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '110%'" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGFloat documentHeight = [result doubleValue];
        CGRect webFrame = webView.frame;
        webFrame.size.height = documentHeight;
//        webView.frame = webFrame;
        webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-48);
        [self.view addSubview:self.wkWebView];
        [self addBottomBtn];
        //        [self.tableView reloadData];
        NSLog(@"didFinishNavigation");
        //        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark ------ < getter > ------
#pragma mark
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        wkWebConfig.userContentController = wkUController;
        /** << 自适应屏幕宽度js > */
        NSMutableString *JSString = [NSMutableString string];
        
        /** < 法3 > */
        NSString *windowLocationString = @"<script type=\"text/javascript\">\
        window.onload = function() {\
        window.location.href = \"ready://\" + document.body.scrollHeight;\
        }\
        </script>";
        
        [JSString appendString:windowLocationString];
        
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        [JSString appendString:jSString];
        
        
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:JSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        /** << 添加js调用 > */
        [wkUController addUserScript:wkUserScript];
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1) configuration:wkWebConfig];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        _wkWebView.opaque = NO;
        _wkWebView.scrollView.scrollEnabled = NO;
        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0,*)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _wkWebView.scrollView.bounces = NO;
        _wkWebView.backgroundColor = [UIColor clearColor];
    }
    return _wkWebView;
}

- (void) setupNav {
    self.navView = [[JSDetailNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navView.titleLabel.text = @"推荐详情";
    [_navView.backBtn bk_addEventHandler:^(id sender) {
        [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navView];
}


@end

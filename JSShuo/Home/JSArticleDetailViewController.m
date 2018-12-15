//
//  JSArticleDetailViewController.m
//  JSShuo
//
//  Created by li que on 2018/11/16.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSArticleDetailViewController.h"
#import <WebKit/WebKit.h>
#import "JSNetworkManager+Comment.h"
#import "JSNetworkManager+Recommend.h"
#import "JSRecommentTableViewCell.h"
#import "JSCommentTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JSDetailNavView.h"
#import "JSDetailBottomSendCommentView.h"
#import "JSBottomPopSendCommentView.h"
#import "JSShareManager.h"
#import "JSNetworkManager+Login.h"

@interface SectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong)UIView *colorLineView;
@property (nonatomic, strong)UIView *grayLineView;
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation SectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.grayLineView];
        [self addSubview:self.colorLineView];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(56);
            make.left.mas_equalTo(15);
        }];
        [self.colorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(self.titleLabel);
            make.left.mas_equalTo(15);
        }];
        [self.grayLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.colorLineView);
            make.left.mas_equalTo(self.titleLabel);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

-(UIView *)colorLineView {
    if (!_colorLineView) {
        _colorLineView = [[UIView alloc] init];
        _colorLineView.backgroundColor = [UIColor colorWithHexString:@"F44336"];
    }
    return _colorLineView;
}

- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = [UIColor colorWithHexString:@"E9E9E9"];
    }
    return _grayLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

@end


@interface JSArticleDetailViewController () <WKNavigationDelegate,WKUIDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CGFloat wkWebViewHeight;
}
@property (nonatomic,strong) WKWebView *wkWebView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) int pageNum;
@property (nonatomic,assign) int pageSize;
@property (nonatomic,strong) NSNumber *totalPage;
@property (nonatomic,strong) NSMutableArray *commentDatas;
@property (nonatomic,strong) NSMutableArray *recommendDatas;
@property (nonatomic,strong) JSDetailNavView *navView;
@property (nonatomic, strong)JSDetailBottomSendCommentView *bottomView;

@end

@implementation JSArticleDetailViewController

- (void) reward:(UIBarButtonItem *)item {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupWebView];
//    [self setupNav];
    self.title = @"推荐详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(reward:)];
    [self initSendCommentView];
    [self initTableView];
    self.tableView.hidden = YES;
    _pageNum = 1;
    _pageSize = 10;
    
    [self requestUserInfo];
    [self requestCommentList];
    [self requestRecommendList];
}

// 请求用户点赞、收藏等接口
- (void) requestUserInfo {
    [JSNetworkManager requestDetailWithArticleID:self.articleId.integerValue complent:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
        if (isSuccess) {
            NSNumber *collected = contentDic[@"collect"];
            if ([collected  isEqual: @1]) {
                self.bottomView.collectionBtn.selected = YES;
            }
            NSNumber *praised = contentDic[@"praise"];
            if ([praised  isEqual: @1]) {
                self.bottomView.praiseBtn.selected = YES;
            }
        }
    }];
}

// 请求评论列表
- (void) requestCommentList {
    NSDictionary *commentParams = @{@"articleId":self.articleId,@"pageNum":[NSNumber numberWithInt:_pageNum],@"pageSize":[NSNumber numberWithInt:_pageSize]};
    [JSNetworkManager requestCommentListWithParams:commentParams complent:^(BOOL isSuccess, NSNumber * _Nonnull totalPage, NSArray * _Nonnull modelsArray) {
        if (isSuccess) {
            self.commentDatas = [NSMutableArray arrayWithArray:modelsArray];
            self.totalPage = totalPage;
            [self.tableView reloadData];
        }
    }];
}

// 请求相关推荐列表
- (void) requestRecommendList {
    NSDictionary *recommendParams = @{@"articleId":self.articleId,@"type":@1,@"pageSize":@6};
    [JSNetworkManager requestRecommendListWithParams:recommendParams complent:^(BOOL isSuccess, NSArray * _Nonnull modelsArray) {
        if (isSuccess) {
            self.recommendDatas = [NSMutableArray arrayWithArray:modelsArray];
            [self.tableView reloadData];
        }
    }];
}

// 底部的一排按钮
- (void) initSendCommentView {
    JSDetailBottomSendCommentView *bottomView = [[JSDetailBottomSendCommentView alloc] initWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth, 40)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSendChat:)];
    [bottomView.sendCommentLabel addGestureRecognizer:tap];
    
    _bottomView = bottomView;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    @weakify(self);
    [_bottomView.shareBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [JSShareManager shareWithTitle:@"叫兽说" Text:@"文章详情" Image:[UIImage imageNamed:@"js_share_image"] Url:[NSString stringWithFormat:@"http://api.jiaoshoutt.com/v1/page/article/%@",self.articleId] complement:^(BOOL isSuccess) {
            if (isSuccess) {
                [self showAutoDismissTextAlert:@"分享成功"];
            }else{
                [self showAutoDismissTextAlert:@"分享失败"];
            }
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    // 第 2 个按钮
    [_bottomView.praiseBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
        if (token) {
            self.bottomView.praiseBtn.userInteractionEnabled = NO;
            if (self.bottomView.praiseBtn.selected) { // 取消点赞
                [JSNetworkManager deletePraiseWithArticleID:self.articleId.integerValue complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
                    NSLog(@"取消点赞 -- %@",contentDic);
                    self.bottomView.praiseBtn.userInteractionEnabled = YES;
                    if (isSuccess) {
                        self.bottomView.praiseBtn.selected = NO;
                    }
                }];
            } else { // 点赞
                NSDictionary *params = @{@"token":token,@"articleId":self.articleId};
                [JSNetworkManager addPraise:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
                    NSLog(@"点赞 -- %@",contentDic);
                    self.bottomView.praiseBtn.userInteractionEnabled = YES;
                    if (isSuccess) {
                        self.bottomView.praiseBtn.selected = YES;
                    }
                }];
            }
            self.bottomView.praiseBtn.selected = !self.bottomView.praiseBtn.selected;
        } else {
            [JSAccountManager checkLoginStatusComplement:^(BOOL isLogin) {
                
            }];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    // 第 3 个按钮
    [_bottomView.collectionBtn bk_addEventHandler:^(id sender) {
        @strongify(self)
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
        if (token) {
            self.bottomView.collectionBtn.userInteractionEnabled = NO;
            if (self.bottomView.collectionBtn.selected) { // 取消收藏
                [JSNetworkManager requestDeleateCollectWithArticleId:self.articleId.integerValue complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
                    self.bottomView.collectionBtn.userInteractionEnabled = YES;
                    if (isSuccess) {
                        self.bottomView.collectionBtn.selected = NO;
                        [self showAutoDismissTextAlert:@"取消收藏"];
                    }
                }];
            } else { // 收藏
                NSDictionary *params = @{@"token":token,@"articleId":self.articleId};
                [JSNetworkManager addCollect:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
                    self.bottomView.collectionBtn.userInteractionEnabled = YES;
                    NSLog(@"收藏成功 -- %@",contentDic);
                    if (isSuccess) {
                        self.bottomView.collectionBtn.selected = YES;
                        [self showAutoDismissTextAlert:@"收藏成功"];
                    }
                }];
            }
            self.bottomView.collectionBtn.selected = !self.bottomView.collectionBtn.selected;
        } else {
            [JSAccountManager checkLoginStatusComplement:^(BOOL isLogin) {
                
            }];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    // 第 1 个按钮
    [_bottomView.chatBtn bk_addEventHandler:^(id sender) {
        @strongify(self)
        if (self.bottomView.chatBtn.selected) {
            [self.tableView scrollToTop];
        } else {
            if (self.commentDatas.count) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        self.bottomView.chatBtn.selected = !self.bottomView.chatBtn.selected;
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void) showSendChat:(UITapGestureRecognizer *)tap {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
    __block BOOL haveToken = token.length > 0 ? YES : NO;
    if (haveToken) {
        [JSBottomPopSendCommentView showInputBarWithView:self.navigationController.view articleId:[NSString stringWithFormat:@"%@",self.articleId] complement:^(NSDictionary * _Nonnull comment) {
            [self showAutoDismissTextAlert:@"发送成功"];
            [self requestCommentList];
        }];
    } else {
        [JSAccountManager checkLoginStatusComplement:^(BOOL isLogin) {
            
        }];
    }
}

- (void) setupNav {
    self.navView = [[JSDetailNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navView.titleLabel.text = @"推荐详情";
    [_navView.backBtn bk_addEventHandler:^(id sender) {
        [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navView];
}

- (void) initTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
        
    }];
}

#pragma mark -- UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JSRecommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSRecommentTableViewCell" forIndexPath:indexPath];
        cell.model = self.recommendDatas[indexPath.row];
        return cell;
    } else {
        JSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSCommentTableViewCell" forIndexPath:indexPath];
        cell.model = self.commentDatas[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeaderView *headerView = [[SectionHeaderView alloc] init];
    [headerView.contentView setBackgroundColor:[UIColor whiteColor]];
    if (section == 0) {
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 30);
        [headerView.titleLabel setText:@"相关推荐"];
    } else {
        if (self.commentDatas.count > 0) {
            headerView.frame = CGRectMake(0, 0, ScreenWidth, 30);
            [headerView.titleLabel setText:@"热门评论"];
        } else {
            headerView.frame = CGRectMake(0, 0, ScreenWidth, 1);
        }
    }
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.recommendDatas.count > 0 && self.commentDatas.count > 0) {
        return 2;
    } else if (self.commentDatas.count >0 || self.recommendDatas.count > 0) {
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    if (section == 0) {
        footerView.frame = CGRectMake(0, 0, ScreenWidth, 10);
        footerView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    } else {
        footerView.frame = CGRectMake(0, 0, ScreenWidth, 1);
        footerView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height;
    if (section == 0) {
        height = 30;
    } else {
        if (self.commentDatas.count > 0) {
            height = 30;
        } else {
            height = 1;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = section == 0 ? 10 : 1;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    } else {
        JSCommentListModel *model = self.commentDatas[indexPath.row];
        if (model.replyList.count) {
            CGFloat height = [tableView fd_heightForCellWithIdentifier:@"JSCommentTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                // 重点(自适应高度必须实现)
                [self setupModelOfCell:cell AtIndexPath:indexPath];
            }];
            return height + [model getReplayHeight:model];
//            return height + [model getReplayHeight:model];
        } else {
            return [tableView fd_heightForCellWithIdentifier:@"JSCommentTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                // 重点(自适应高度必须实现)
                [self setupModelOfCell:cell AtIndexPath:indexPath];
            }];
        }
    }
}

//预加载Cell内容
- (void)setupModelOfCell:(JSCommentTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell.model = [self.commentDatas objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {  return self.recommendDatas.count;}
    else {  return self.commentDatas.count;}
}

- (void) setupWebView {
    wkWebViewHeight = 0.f;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.jiaoshoutt.com/v1/page/article/%@",self.articleId]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:urlRequest];
}

#pragma mark ------ < UIScrollViewDeltegate > ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /**  < 解决web白屏问题 >  */
    /**  < 需要调用私有API：_updateVisibleContentRects >  */
    [self.wkWebView setNeedsLayout];
}

#pragma mark ------ < WKUIDelegate,WKNavigationDelegate > ------
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self showWaitingHUD];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hideWaitingHUD];
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGFloat documentHeight = [result doubleValue];
        CGRect webFrame = webView.frame;
        webFrame.size.height = documentHeight;
        webView.frame = webFrame;
//        [self.view addSubview:self.wkWebView];
        self.tableView.tableHeaderView = self.wkWebView;
//        [self.tableView reloadData];
        NSLog(@"didFinishNavigation");
        self.tableView.hidden = NO;
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-40) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[JSRecommentTableViewCell class] forCellReuseIdentifier:@"JSRecommentTableViewCell"];
        [_tableView registerClass:[JSCommentTableViewCell class] forCellReuseIdentifier:@"JSCommentTableViewCell"];
        [_tableView registerClass:[SectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"SectionHeaderView"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        if (@available(iOS 11.0, *)) {
//            _tableView.estimatedRowHeight = 0;
//            _tableView.estimatedSectionFooterHeight = 0;
//            _tableView.estimatedSectionHeaderHeight = 0;
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }else{
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)commentDatas {
    if (!_commentDatas) {
        _commentDatas = [NSMutableArray arrayWithCapacity:0];
    }
    return _commentDatas;
}

- (NSMutableArray *)recommendDatas {
    if (!_recommendDatas) {
        _recommendDatas = [NSMutableArray arrayWithCapacity:0];
    }
    return _recommendDatas;
}


@end

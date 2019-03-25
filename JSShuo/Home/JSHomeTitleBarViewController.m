//
//  JSHomeTitleBarViewController.m
//  JSShuo
//
//  Created by li que on 2018/11/4.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSHomeTitleBarViewController.h"
#import "JSHomeViewController.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "JSNavSearchView.h"
#import "JSNetworkManager+Channel.h"
#import "JSSearchViewController.h"
#import "JSNetworkManager+Login.h"
#import "JSMainViewController.h"
#import "AppDelegate.h"
#import "JSRedPacketViewController.h"
#import "JSNoSearchResultView.h"


@interface JSHomeTitleBarViewController () <TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) JSNavSearchView *nav;
@property (nonatomic,strong) JSNoSearchResultView *noResultView;
//@property (nonatomic) BOOL haveToken;
@end

@implementation JSHomeTitleBarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.nav updateHeaderImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [JSNetworkManager requestIsShowInviteMenu]; // 请求 “我的” 页面中，是否显示接口
    [self setupNav];
    [self addTabPageBar];
    [self addPagerController];
    [self requestData];
    [self.view addSubview:self.noResultView];
    _noResultView.hidden = YES;
}

- (void) requestData {
    [JSNetworkManager requestChannelListWithParams:@{} complent:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
        if (isSuccess) {
            self.noResultView.hidden = YES;
            self.datas = contentDic[@"list"];
            [self loadData];
        } else {
            self.noResultView.hidden = NO;
        }
    }];
}

- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    tabBar.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 0;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

- (void) loadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

//设置tabbar的高度
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 36);
    _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = [self.datas[index] objectForKey:@"name"];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = [self.datas[index] objectForKey:@"name"];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return self.datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    JSHomeViewController *vc = [[JSHomeViewController alloc] init];
    vc.type = JSHomePage;
    vc.genreID = [_datas[index] objectForKey:@"channelId"];
    return vc;
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void) setupNav {
    self.nav = [[JSNavSearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _nav.backgroundColor = [UIColor colorWithHexString:@"F44336"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToSearchVC:)];
    [_nav.searchRectangle addGestureRecognizer:tap];
    @weakify(self);
    [_nav.headButton bk_addEventHandler:^(id sender) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
        __block BOOL haveToken = token.length > 0 ? YES : NO;
        @strongify(self);
        [JSAccountManager checkLoginStatusComplement:^(BOOL isLogin) {
            if (isLogin) {
                if (haveToken) {
                    JSMainViewController *mainVC = [AppDelegate instance].mainViewController;
                    [mainVC switchToViewControllerAtIndex:3];
                }
                [self.nav updateHeaderImage];
            }
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_nav.redPocketButton bk_addEventHandler:^(id sender) {
        JSRedPacketViewController *vc = [JSRedPacketViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    [_nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
        make.top.mas_equalTo(0);
    }];
}

// 登录成功后的通知
- (void)userLoginSuccessNoti:(NSNotification *)notification {
    
}

// 刷新用户信息的头部
- (void)refreshProfileData{
    [JSNetworkManager requestProfileDateWithComplement:^(BOOL isSuccess, NSDictionary * _Nonnull dataDict) {
        if (isSuccess) {
            
            NSError *error = nil;
            JSProfileUserModel *userModel = [MTLJSONAdapter modelOfClass:[JSProfileUserModel class] fromJSONDictionary:dataDict error:&error];
//            [self.headerView setUserModel:userModel];
        }
//        [self.profileTableView.mj_header endRefreshing];
    }];
}

- (void) pushToSearchVC:(UITapGestureRecognizer *)tap {
    JSSearchViewController *vc = [JSSearchViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}

- (JSNoSearchResultView *)noResultView {
    if (!_noResultView) {
        _noResultView = [[JSNoSearchResultView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
        _noResultView.titleLabelOne.text = @"当前手机暂无网络连接！";
        _noResultView.titleLabelTwo.text = @"请检查网络设置后点击屏幕刷新";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestData)];
        [_noResultView addGestureRecognizer:tap];
    }
    return _noResultView;
}

@end

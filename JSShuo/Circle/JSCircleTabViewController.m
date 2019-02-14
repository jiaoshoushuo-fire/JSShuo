//
//  JSCircleTabViewController.m
//  JSShuo
//
//  Created by li que on 2019/1/30.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import "JSCircleTabViewController.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "JSCircleViewController.h"
#import "JSPostMessageViewController.h"
#import "JSCircleMyViewController.h"

@interface JSCircleTabViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation JSCircleTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self setupNav];
    [self addTabPageBar];
    [self addPagerController];
    [self loadData];
}

- (void) loadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

//设置tabbar的高度
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 44);
    _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = [self.datas[index] objectForKey:@"title"];
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
    if (index == 2) {
        JSCircleMyViewController *vc = [JSCircleMyViewController new];
        return vc;
    } else {
        JSCircleViewController *vc = [[JSCircleViewController alloc] init];
        vc.channel = [self.datas[index] objectForKey:@"channel"];
        return vc;
    }
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
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

- (void) addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    tabBar.layout.cellWidth = CGRectGetWidth(self.view.frame)/6;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.cellEdging = 10;
    tabBar.layout.adjustContentCellsCenter = YES;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    tabBar.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
    [self.view addSubview:tabBar];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth-20-15, (44-20)/2, 20, 20);
    [btn setImage:[UIImage imageNamed:@"js_comment_xie"] forState:UIControlStateNormal];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        JSPostMessageViewController *postVC = [[JSPostMessageViewController alloc]init];
        postVC.hidesBottomBarWhenPushed = YES;
        [self.rt_navigationController pushViewController:postVC animated:YES complete:nil];
    }];
    [tabBar addSubview:btn];
    _tabBar = tabBar;
}

- (void) setupNav {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    topView.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
    [self.view addSubview:topView];
}

- (NSArray *)datas {
    if (!_datas) {
        _datas = [NSArray arrayWithObjects:
                  @{@"title":@"推荐",@"channel":@"0"},
                  @{@"title":@"最新",@"channel":@"1"},
                  @{@"title":@"我的",@"channel":@"me"}, nil];
    }
    return _datas;
}

@end

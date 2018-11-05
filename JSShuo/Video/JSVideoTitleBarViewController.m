//
//  JSVideoTitleBarViewController.m
//  JSShuo
//
//  Created by li que on 2018/11/5.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSVideoTitleBarViewController.h"
#import "JSVideoViewController.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "JSVideoViewController.h"
#import "JSShortVideoViewController.h"

@interface JSVideoTitleBarViewController ()<TYTabPagerControllerDataSource,TYTabPagerControllerDelegate>
@property (nonatomic, strong) NSArray *datas;
@end

@implementation JSVideoTitleBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    navView.backgroundColor = [UIColor colorWithHexString:@"F44336"];
    [self.view addSubview:navView];
    
    self.tabBarHeight = 40;
    self.tabBarOrignY = 20;
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.layout.cellWidth = kScreenWidth/2;
    self.tabBar.layout.cellSpacing = 0;
    self.tabBar.layout.cellEdging = 0;
    self.tabBar.layout.adjustContentCellsCenter = YES;
    self.tabBar.backgroundColor = [UIColor colorWithHexString:@"F44336"];
    self.tabBar.layout.normalTextColor = [UIColor colorWithHexString:@"FCE2E0"];
    self.tabBar.layout.selectedTextColor = [UIColor colorWithHexString:@"FFFFFF"];
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:16.0];
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:18.0];
    self.dataSource = self;
    self.delegate = self;
    [self loadData];
}

- (void) loadData {
    self.datas = @[@"长视频",@"短视频"];
    [self scrollToControllerAtIndex:0 animate:YES];
    [self reloadData];
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return _datas.count;
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index%2 == 0) {
        JSVideoViewController *vc = [JSVideoViewController new];
        return vc;
    }else {
        JSShortVideoViewController *vc = [JSShortVideoViewController new];
        return vc;
    }
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return title;
}


@end

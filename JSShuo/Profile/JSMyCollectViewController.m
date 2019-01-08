//
//  JSMyCollectViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/19.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMyCollectViewController.h"
#import <WMPageController.h>
#import "JSMyCollectArticleViewController.h"
#import "JSMyCollectVideoViewController.h"
#import "JSMyCollectVideoManagerViewController.h"
#import "JSMyCollectShortVideoViewController.h"

@interface JSMyCollectViewController ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong)WMPageController *pageController;
@property (nonatomic, strong)NSArray *topTitles;
@property (nonatomic, strong)NSArray *subVCs;

@end

@implementation JSMyCollectViewController

- (NSArray *)topTitles{
    if (!_topTitles) {
        _topTitles = @[@"文章",@"视频"];
    }
    return _topTitles;
}
- (NSArray *)subVCs{
    if (!_subVCs) {
        JSMyCollectArticleViewController *subVC = [[JSMyCollectArticleViewController alloc]init];
        JSMyCollectShortVideoViewController *subVC2 = [[JSMyCollectShortVideoViewController alloc]init];
        _subVCs = @[subVC,subVC2];
    }
    return _subVCs;
}

- (WMPageController *)pageController{
    if (!_pageController) {
        _pageController = [[WMPageController alloc]init];
        _pageController.menuViewStyle = WMMenuViewStyleLine;
        _pageController.menuView.lineColor = [UIColor colorWithHexString:@"F44336"];
        //        _pageController.menuBGColor = [UIColor whiteColor];
        //        _pageController.menuHeight = 42.f;
        _pageController.menuItemWidth = kScreenWidth/2.0f;
        
        _pageController.titleColorNormal = [UIColor colorWithHexString:@"666666"];
        _pageController.titleSizeNormal = 15;
        _pageController.titleColorSelected = [UIColor colorWithHexString:@"F44336"];
        _pageController.titleSizeSelected = 15;
        _pageController.bounces = YES;
        _pageController.delegate = self;
        _pageController.dataSource = self;
        _pageController.selectIndex = 0;
    }
    return _pageController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.pageController];
    self.pageController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pageController.view];
    
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.topTitles.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index < 0 || index > self.topTitles.count - 1) {
        return nil;
    }
    
    
    return self.subVCs[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    return self.topTitles[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, self.view.width, 42);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = 42;
    return CGRectMake(0, originY, self.view.width, self.pageController.view.height - originY);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController * _Nonnull)viewController withInfo:(NSDictionary * _Nonnull)info{
    
}


@end

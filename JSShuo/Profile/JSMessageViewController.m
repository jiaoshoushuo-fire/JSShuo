//
//  JSMessageViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMessageViewController.h"
#import "JSSwitchSegmentView.h"
#import "JSNotificationViewController.h"


@interface JSMessageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) JSSwitchSegmentView *segmentView;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *allVC;
@property (nonatomic, strong) JSNotificationViewController *notificationVC;
@property (nonatomic, strong) JSNotificationViewController *announcementVC;
@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation JSMessageViewController

- (JSSwitchSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[JSSwitchSegmentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [_segmentView.optionButtonLeft setTitle:@"通知" forState:UIControlStateNormal];
        [_segmentView.optionButtonRight setTitle:@"公告" forState:UIControlStateNormal];
        [_segmentView.optionButtonRight showBadgeWithStyle:WBadgeStyleNumber value:99 animationType:WBadgeAnimTypeNone];
        [_segmentView.optionButtonLeft showBadgeWithStyle:WBadgeStyleNumber value:99 animationType:WBadgeAnimTypeNone];
        
        _segmentView.optionButtonRight.badgeCenterOffset = CGPointMake(kScreenWidth/3.0f, 7);
        _segmentView.optionButtonLeft.badgeCenterOffset = CGPointMake(kScreenWidth/3.0f, 7);
    }
    return _segmentView;
}
- (UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}
- (JSNotificationViewController *)announcementVC{
    if (!_announcementVC) {
        _announcementVC = [[JSNotificationViewController alloc]init];
        _announcementVC.messageType = 2;
    }
    return _announcementVC;
}
- (JSNotificationViewController *)notificationVC{
    if (!_notificationVC) {
        _notificationVC = [[JSNotificationViewController alloc]init];
        _notificationVC.messageType = 1;
    }
    return _notificationVC;
}
- (NSArray *)allVC{
    if (!_allVC) {
        _allVC = @[self.notificationVC,self.announcementVC];
    }
    return _allVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentView];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self addChildViewController:self.pageViewController];
    //    self.pageViewController.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.segmentView.mas_bottom);
        CGFloat tap = 0;
        if (IS_IPHONE_X) {
            tap = 34;
        }
        make.bottom.equalTo(self.view).offset(-tap);
    }];
    @weakify(self)
    [self.pageViewController setViewControllers:@[self.allVC[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        @strongify(self)
        self.currentPage = 0;
    }];
    // Do any additional setup after loading the view.
    
    self.segmentView.selectedIndexChangedHandler = ^(NSUInteger index) {
        @strongify(self);
        
        [self switchPageViewControllerAtIndex:index];
    };
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.allVC indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return self.allVC[index-1];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self.allVC indexOfObject:viewController];
    if (index+1 == self.allVC.count) {
        return nil;
    }
    return self.allVC[index+1];
}

#pragma mark - UIPageViewControllerDelegate
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    _currentPage = [self.allVC indexOfObject:pageViewController.viewControllers.firstObject];
    [self.segmentView setSelectedIndex:_currentPage];
    
}
- (void)switchPageViewControllerAtIndex:(NSUInteger)index {
    
    @weakify(self)
    [self.pageViewController setViewControllers:@[self.allVC[index]] direction:index<self.currentPage animated:YES completion:^(BOOL finished) {
        @strongify(self)
        self.currentPage = index;
        
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

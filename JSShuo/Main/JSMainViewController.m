//
//  JSMainViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMainViewController.h"
#import "JSMainTabBar.h"
#import "JSHomeTitleBarViewController.h"
#import "JSVideoTitleBarViewController.h"
#import "JSMissionViewController.h"
#import "JSProfileViewController.h"
#import "JSActivityCenterViewController.h"

@interface JSMainViewController ()

@property (nonatomic, strong) JSMainTabBar *mainTabBar;


@property (nonatomic, strong) JSHomeTitleBarViewController      *homeViewController;
@property (nonatomic, strong) JSVideoTitleBarViewController     *videoViewController;
@property (nonatomic, strong) JSActivityCenterViewController    *activityViewController;
@property (nonatomic, strong) JSMissionViewController           *newsViewController;
@property (nonatomic, strong) JSProfileViewController           *profileViewController;

@end

@implementation JSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.homeViewController = [[JSHomeTitleBarViewController alloc] init];
    self.videoViewController = [[JSVideoTitleBarViewController alloc] init];
    self.activityViewController = [[JSActivityCenterViewController alloc] init];
    self.newsViewController = [[JSMissionViewController alloc] init];
    self.profileViewController = [[JSProfileViewController alloc] init];
    
    
    RTRootNavigationController *nav1 = [[RTRootNavigationController alloc] init];
    nav1.viewControllers = @[self.homeViewController];
    RTRootNavigationController *nav2 = [[RTRootNavigationController alloc] init];
    nav2.viewControllers = @[self.videoViewController];
    RTRootNavigationController *nav3 = [[RTRootNavigationController alloc] init];
    nav3.viewControllers = @[self.activityViewController];
    RTRootNavigationController *nav4 = [[RTRootNavigationController alloc] init];
    nav4.viewControllers = @[self.newsViewController];
    RTRootNavigationController *nav5 = [[RTRootNavigationController alloc] init];
    nav5.viewControllers = @[self.profileViewController];
    
    self.viewControllers = @[nav1, nav2, nav3, nav4, nav5];
    
    @weakify(self)
    self.mainTabBar = [JSMainTabBar mainTabBarWithHandler:^(id sender) {
        @strongify(self)
        UIButton *button = (UIButton *)sender;
        [self didSelectTabBarButton:button];
    }];
    [self setValue:self.mainTabBar forKey:@"tabBar"];
    
    [self switchToViewControllerAtIndex:0];
}
- (void)didSelectTabBarButton:(UIButton *)button {
    
    if (button == self.mainTabBar.homeButton) {
        if (self.selectedViewController == [self.viewControllers objectAtIndex:0]) {
//            [self.homeViewController scrollToTopAndReloadData];
        } else {
            self.selectedIndex = 0;
        }
    } else if (button == self.mainTabBar.discoverButton) {
        if (self.selectedViewController != [self.viewControllers objectAtIndex:1]) {
            self.selectedIndex = 1;
        }
    } else if (button == self.mainTabBar.publishButton) {
        if (self.selectedViewController == [self.viewControllers objectAtIndex:2]) {
            //            [self.newsViewController scrollToTopAndReloadData];
        } else {
            self.selectedIndex = 2;
        }
        
    } else if (button == self.mainTabBar.newsButton) {
        if (self.selectedViewController == [self.viewControllers objectAtIndex:3]) {
            //            [self.newsViewController scrollToTopAndReloadData];
        } else {
            self.selectedIndex = 3;
        }
    } else if (button == self.mainTabBar.profileButton) {
        if (self.selectedViewController == [self.viewControllers objectAtIndex:4]) {
            //            [self.profileViewController scrollToTopAndReloadData];
        } else {
            self.selectedIndex = 4;
        }
    }
}


- (void)switchToViewControllerAtIndex:(NSInteger)index {
    self.selectedIndex = index;
    [self.mainTabBar setSelectButtonAtIndex:index];
}
@end

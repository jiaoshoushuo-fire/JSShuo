//
//  JSTabBarViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSTabBarViewController.h"

@interface JSTabBarViewController ()

@end

@implementation JSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIViewController *)childViewControllerForStatusBarStyle{
    return [self topMostViewController];
}
- (UIViewController *)childViewControllerForStatusBarHidden{
    return [self topMostViewController];
}
//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}


- (BOOL)shouldAutorotate
{
    if ([self topMostViewController]) {
        return [[self topMostViewController] shouldAutorotate];
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self topMostViewController]) {
        return [[self topMostViewController]supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if ([self topMostViewController]) {
        return [[self topMostViewController]preferredInterfaceOrientationForPresentation];
    }
    return UIInterfaceOrientationPortrait;
    
}

- (UIViewController *)topMostViewController{
    UIViewController *currentVC = self.selectedViewController;
    if ([currentVC isKindOfClass:[RTRootNavigationController class]]) {
        RTRootNavigationController *nav = (RTRootNavigationController *)currentVC;
        return nav.topViewController;
    }
    return currentVC;
}
- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden{
    return [self topMostViewController];
}


@end

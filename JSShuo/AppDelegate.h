//
//  AppDelegate.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSRootViewController.h"
#import "JSLaunchViewController.h"
#import "JSStartupViewController.h"
#import "JSMainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong, readonly) JSRootViewController *rootViewController;

@property (nonatomic, strong, readonly) JSLaunchViewController *launchViewController;               // 0
@property (nonatomic, strong, readonly) JSStartupViewController *startupViewController;             // 1
@property (nonatomic, strong, readonly) JSMainViewController *mainViewController;                   // 2


@property (strong, nonatomic) UIWindow *window;


+ (instancetype)instance;
- (void)setSkipViewControllerAtIndex:(NSInteger)index;
- (void)switchNextRootViewController;
@end


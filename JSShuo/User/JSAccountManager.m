//
//  JSAccountManager.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/2.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAccountManager.h"
#import "AppDelegate.h"
#import "JSLoginMainViewController.h"

@implementation JSAccountManager


+ (instancetype)shareManager{
    static JSAccountManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JSAccountManager alloc]init];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
        if (token && token.length > 0) {
            manager.accountToken = token;
        }
    });
    return manager;
}
+ (void)refreshAccountToken:(NSString *__nullable)accountToken{
    JSAccountManager *manager = [JSAccountManager shareManager];
    
    if (accountToken) {
        manager.accountToken = accountToken;
        [[NSUserDefaults standardUserDefaults] setObject:accountToken forKey:kUserDefaultsKeyAccessToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        manager.accountToken = @"";
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsKeyAccessToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)isLogin{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
    if (!token || [token length] == 0 || (NSNull *)token == [NSNull class]) {
        return NO;
    }
    return YES;
}

+ (void)checkLoginStatusComplement:(void(^)(BOOL isLogin))complement{
    if ([self isLogin]) {
        if (complement) {
            complement(YES);
        }
    }else{
        JSMainViewController *mainVC = [AppDelegate instance].mainViewController;
        RTRootNavigationController *currentNav = mainVC.selectedViewController;
        UIViewController *currentVC = currentNav.rt_topViewController;
        
        
        JSLoginMainViewController *loginVC = [[JSLoginMainViewController alloc]init];
        loginVC.loginComplementBlock = complement;
        RTRootNavigationController *nav1 = [[RTRootNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav1 from:currentVC animated:YES];
    }
}

+ (void)presentViewController:(UIViewController *)destViewController from:(UIViewController *)fromViewController animated:(BOOL)animated {
    
    if (fromViewController.tabBarController) {
        [fromViewController.tabBarController presentViewController:destViewController animated:animated completion:NULL];
    } else if (fromViewController.rt_navigationController) {
        [fromViewController.rt_navigationController presentViewController:destViewController animated:animated completion:NULL];
    } else if (fromViewController.navigationController) {
        [fromViewController.navigationController presentViewController:destViewController animated:animated completion:NULL];
    } else {
        [fromViewController presentViewController:destViewController animated:animated completion:NULL];
    }
}


@end

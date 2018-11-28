//
//  AppDelegate.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "AppDelegate.h"
#import "JSAccountManager+Wechat.h"
#import "JSAccountManager+QQ.h"

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) JSRootViewController *rootViewController;

@property (nonatomic, strong, readwrite) JSLaunchViewController *launchViewController;
@property (nonatomic, strong, readwrite) JSStartupViewController *startupViewController;
@property (nonatomic, strong, readwrite) JSMainViewController *mainViewController;

@property (atomic, strong) NSMutableArray<NSNumber *> *indexesOfViewControllersToShow;

@end

@implementation AppDelegate

+ (instancetype)instance {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)setSkipViewControllerAtIndex:(NSInteger)index {
    @synchronized (self) {
        id objectToRemove = nil;
        for (NSNumber * obj in self.indexesOfViewControllersToShow) {
            if ([obj integerValue] == index) {
                objectToRemove = obj;
                break;
            }
        }
        if (objectToRemove) {
            [self.indexesOfViewControllersToShow removeObject:objectToRemove];
        }
    }
}

- (void)switchNextRootViewController {
    @synchronized (self) {
        NSInteger currentViewControllerIndex = [self.rootViewController.viewControllers indexOfObject:self.rootViewController.selectedViewController];
        
        for (NSInteger index = 0; index < self.indexesOfViewControllersToShow.count; index++) {
            NSNumber *obj = [self.indexesOfViewControllersToShow objectAtIndex:index];
            if ([obj integerValue] == currentViewControllerIndex) {
                NSInteger nextIndex = index + 1;
                if (nextIndex < self.indexesOfViewControllersToShow.count) {
                    NSNumber *nextObj = [self.indexesOfViewControllersToShow objectAtIndex:nextIndex];
                    NSInteger nextViewControllerIndex = [nextObj integerValue];
                    [self.rootViewController switchToViewController:nextViewControllerIndex withCompletionBlock:^{
                        
                    }];
                    break;
                }
            }
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [JSAccountManager initWechat];
    [JSAccountManager initQQ];
    
    [self initRootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)initRootViewController {
    
    self.launchViewController = [[JSLaunchViewController alloc] init];
    self.startupViewController = [[JSStartupViewController alloc] init];
    self.mainViewController = [[JSMainViewController alloc] init];
    self.rootViewController = [[JSRootViewController alloc]
                               initWithViewControllers:@[
                                                         self.launchViewController,
                                                         self.startupViewController,
                                                         self.mainViewController
                                                         ]];
    self.indexesOfViewControllersToShow = [[NSMutableArray alloc] initWithArray:@[@(0), @(1), @(2)]];
    self.window.rootViewController = self.rootViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self handleURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [self handleURL:url];
}

- (BOOL)handleURL:(NSURL *)url {
    
   
    NSString *scheme = [[url scheme] lowercaseString];
    
    if ([scheme isEqualToString:wechat_App_ID]) {
        return [JSAccountManager handleWechatURL:url];
    }else if ([scheme isEqualToString:@"QQ60D1879"] || [scheme isEqualToString:@"tencent101521529"]) {
        return [JSAccountManager handleQQURL:url];
    }
    
    return YES;
    
}


@end

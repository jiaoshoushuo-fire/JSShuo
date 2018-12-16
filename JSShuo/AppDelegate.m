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
#import "JSRedPacketViewController.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "JSArticleDetailViewController.h"
#import "JSVideoDetailViewController.h"
#import "JSActivityCenterViewController.h"


@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong, readwrite) JSRootViewController *rootViewController;

@property (nonatomic, strong, readwrite) JSLaunchViewController *launchViewController;
@property (nonatomic, strong, readwrite) JSStartupViewController *startupViewController;
@property (nonatomic, strong, readwrite) JSMainViewController *mainViewController;
@property (nonatomic, copy) NSString *trackViewUrl;

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
    
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"f75dcab20003fb7b3692bef5"
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
    
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self dealNotificationDictionary:notification.request.content.userInfo]; //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSDictionary * userInfo = response.notification.request.content.userInfo;
        [self dealNotificationDictionary:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    [self dealNotificationDictionary:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
    [self dealNotificationDictionary:userInfo];
    if (application.applicationState == UIApplicationStateActive) { //程序运行时收到通知，先弹出消息框
        NSLog(@"程序在前台");
    } else{ //程序已经关闭或者在后台运行
        NSLog(@"在后台");
        //这里也可以发送个通知,跳转到指定页面
        // [self readNotificationVcWithUserInfo:userInfo];
    }
}

- (void) dealNotificationDictionary:(NSDictionary *)userInfo {
    // 根据消息类型，来进入不同页面
    NSString *type = [userInfo objectForKey:@"type"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([type isEqualToString:@"0"]) { // 文章
            NSString *ID = [userInfo objectForKey:@"ID"];
            JSArticleDetailViewController *vc = [JSArticleDetailViewController new];
            vc.articleId = [NSNumber numberWithString:ID];
            vc.hidesBottomBarWhenPushed = YES;
            RTRootNavigationController *nav = self.mainViewController.viewControllers[0];
            [nav pushViewController:vc animated:YES complete:nil];
        } else if ([type isEqualToString:@"1"]) { // 视频
            NSString *ID = [userInfo objectForKey:@"ID"];
            JSVideoDetailViewController *vc = [JSVideoDetailViewController new];
            vc.urlStr = [userInfo objectForKey:@"urlStr"];
            vc.videoTitle = [userInfo objectForKey:@"videoTitle"];
            vc.articleId = [userInfo objectForKey:@"ID"];
            vc.hidesBottomBarWhenPushed = YES;
            RTRootNavigationController *nav = self.mainViewController.viewControllers[0];
            [nav pushViewController:vc animated:YES complete:nil];
        } else if ([type isEqualToString:@"2"]) { // 活动
            JSMainViewController *mainViewController = [AppDelegate instance].mainViewController;
            [mainViewController switchToViewControllerAtIndex:2];
        } else if ([type isEqualToString:@"3"]) { // 更新
            //获取当前bundle中的版本号
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            
            //获取App Store中当前APP的版本号
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSArray *array = responseObject[@"results"];
                NSDictionary *dict = [array lastObject];
                NSLog(@"线上版本：%@", dict[@"version"]);
                NSString *lineVersion = dict[@"version"];
                if ([lineVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
                    //appstore 版本更高
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message: [NSString stringWithFormat:@" 新版本 %@ 已发布 ! ", lineVersion] delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles: @"马上更新", nil];
                    [alert show];
                    NSLog(@"线上版本:%@ 更高", lineVersion);
                }
                else {
                    NSLog(@"当前版本:%@ 更高", currentVersion);
                }
                //返回json中的trackViewUrl就是App Store中当前APP的下载页面
                self.trackViewUrl = dict[@"trackViewUrl"];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"错误  ： %@",error);
            }];
            //跳转App Store页面进行下载
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.trackViewUrl]];
        }
    });
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
    [application setApplicationIconBadgeNumber:0];   //清除角标
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
    }else if ([scheme isEqualToString:@"jiaoshoushuo"]){
//        //跳整点抢红包
//        JSMainViewController *mainViewController = [AppDelegate instance].mainViewController;
//        [mainViewController switchToViewControllerAtIndex:3];
//        
//        RTRootNavigationController *currentNav = mainViewController.selectedViewController;
//        UIViewController *currentVC = currentNav.rt_topViewController;
//        
//        JSRedPacketViewController *redVC = [[JSRedPacketViewController alloc]init];
//        redVC.hidesBottomBarWhenPushed = YES;
//        [currentVC.rt_navigationController pushViewController:redVC animated:YES complete:nil];
        
        return YES;
    }
    
    return YES;
    
}


@end

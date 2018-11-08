//
//  JSNetworkManager.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@implementation JSNetworkManager

+ (AFHTTPSessionManager *)shareManager{
    static AFHTTPSessionManager *networkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [AFHTTPSessionManager manager];
        networkManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        networkManager.responseSerializer = [AFJSONResponseSerializer serializer];
        networkManager.requestSerializer.timeoutInterval = 30;
        [networkManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [networkManager.requestSerializer setValue:@"*/*; charset=utf-8" forHTTPHeaderField:@"Accept"];
        networkManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
        //允许证书无效
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        networkManager.securityPolicy = securityPolicy;
    });
    return networkManager;
}
+ (void)restartLogin{
    [JSAccountManager refreshAccountToken:nil];
    [JSAccountManager checkLoginStatusComplement:^(BOOL isLogin) {
        
    }];
}
+ (UIViewController *)currentViewController{
    JSMainViewController *mainVC = [AppDelegate instance].mainViewController;
    RTRootNavigationController *currentNav = mainVC.selectedViewController;
    UIViewController *currentVC = currentNav.rt_topViewController;
    return currentVC;
}

+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters complement:(void(^)(BOOL isSuccess,NSDictionary *responseDict))complement{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self currentViewController].view animated:YES];
    [[self shareManager]POST:url parameters:[self transformParameters:parameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [hud hideAnimated:YES];
        NSString *state = responseObject[@"code"];
        if (state.integerValue == 0) {
            NSDictionary *dataDict = responseObject[@"data"];
            if (complement) {
                complement(YES,dataDict);
            }
            
        }else if (state.integerValue == 2){
            [self restartLogin];
            if (complement) {
                complement(NO,nil);
            }
        }else{
            NSString *messageString = responseObject[@"message"];
            [self showErrorMessgae:messageString];
            if (complement) {
                complement(NO,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [hud hideAnimated:YES];
        [self showErrorMessgae:error.localizedDescription];
        
        if (complement) {
            complement(NO,nil);
        }
    }];
}

+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters complement:(void(^)(BOOL isSuccess,NSDictionary *responseDict))complement{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self currentViewController].view animated:YES];
    [[self shareManager]GET:url parameters:[self transformParameters:parameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [hud hideAnimated:YES];
        NSString *state = responseObject[@"code"];
        if (state.integerValue == 0) {
            NSDictionary *dataDict = responseObject[@"data"];
            if (complement) {
                complement(YES,dataDict);
            }
            
        }else if (state.integerValue == 2){
            [self restartLogin];
            if (complement) {
                complement(NO,nil);
            }
        }else{
            NSString *messageString = responseObject[@"message"];
            [self showErrorMessgae:messageString];
            if (complement) {
                complement(NO,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [hud hideAnimated:YES];
        [self showErrorMessgae:error.localizedDescription];
        if (complement) {
            complement(NO,nil);
        }
    }];
}
+ (NSDictionary *)transformParameters:(NSDictionary *)parameters{
    
    NSMutableArray *parameterArray = [NSMutableArray array];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        for (NSString *parameKey in [parameters allKeys]) {
            NSString *parameString = [NSString stringWithFormat:@"%@=%@",parameKey,[parameters objectForKey:parameKey]];
            [parameterArray addObject:parameString];
        }
    }
    NSString *parmamStr = @"";
    if (parameterArray.count > 0) {
        parmamStr = [self sortedArray:parameterArray];
    }
    NSString *sig = parmamStr.md5String;
    NSString *appId = @"IOS";
    NSString *appSecret = @"abc";
    
    NSString *nonce = [NSString stringWithFormat:@"%@%@",@([[NSDate date]timeIntervalSince1970]),[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [newParameters setValue:sig forKey:@"sig"];
    [newParameters setValue:appId forKey:@"appId"];
    [newParameters setValue:nonce forKey:@"nonce"];
    [newParameters setValue:appSecret forKey:@"appSecret"];
    return newParameters;
}
//字典排序---字母排序
+ (NSString *)sortedArray:(NSArray *)array {
    
    if (array.count <= 0) {
        return @"";
    }
    NSArray * array2 = [array sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    
    NSString *s = nil ;
    
    s = [array2 componentsJoinedByString:@"&"];
    
    return s;
}

+ (void)showErrorMessgae:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:2.f];
}

+ (void)normalPOST:(NSString *)url parameters:(NSDictionary *)parameters complement:(void(^)(BOOL isSuccess,NSDictionary *responseDict))complement{
    [[self shareManager]POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complement) {
            complement(YES,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showErrorMessgae:error.localizedDescription];
        if (complement) {
            complement(NO,nil);
        }
    }];
}

+ (void)normalGET:(NSString *)url parameters:(NSDictionary *)parameters complement:(void(^)(BOOL isSuccess,NSDictionary *responseDict))complement{
    
    [[self shareManager]GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complement) {
            complement(YES,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showErrorMessgae:error.localizedDescription];
        if (complement) {
            complement(NO,nil);
        }
    }];
}
@end

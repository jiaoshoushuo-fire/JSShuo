//
//  JSAccountManager.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/2.
//  Copyright © 2018年  乔中祥. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WXApi.h>

static NSString * kUserDefaultsKeyAccessToken = @"kUserDefaultsKeyAccessToken";

/**
 *  分享类型
 */
typedef NS_OPTIONS(NSUInteger, GFShareType) {
    /**
     *  不分享
     */
    GFShareTypeNone             = 0,
    /**
     *  微信好友
     */
    GFShareTypeWechatSession    = 1 << 0,
    /**
     *  微信朋友圈
     */
    GFShareTypeWechatTimeline   = 1 << 1,
    /**
     *  微信收藏
     */
    GFShareTypeWechatCollect    = 1 << 2,
    /**
     *  QQ好友、群
     */
    GFShareTypeQQ               = 1 << 3,
    /**
     *  QQ空间
     */
    GFShareTypeQZone            = 1 << 4,
    /**
     *  新浪微博
     */
    GFShareTypeSinaWeibo        = 1 << 5
};


NS_ASSUME_NONNULL_BEGIN


typedef void(^ShareResponseHandler)(BOOL success, BOOL cancel);

typedef void(^AuthorizeHandler)(BOOL success);

@interface JSAccountManager : NSObject

@property (nonatomic, copy) AuthorizeHandler __nullable authorizeHandler;

#pragma mark - QQ
@property (nonatomic, assign) BOOL authorizeForLogin; // QQ的透传数据被篡改了，没有办法通过"login"、"share"来区别. -_-!!!
@property (nonatomic, strong) TencentOAuth *tencentOAuth;



@property (nonatomic, copy)NSString * __nullable accountToken;
+ (instancetype)shareManager;

+ (void)refreshAccountToken:(NSString * __nullable)accountToken;

//检查登录
+ (void)checkLoginStatusComplement:(void(^)(BOOL isLogin))complement;

+ (BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END

//
//  JSAccountManager+QQ.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAccountManager+QQ.h"
#import "JSAccountManager+Wechat.h"

@implementation JSAccountManager (QQ)

static ShareResponseHandler qqShareHandler = nil;
+ (void)initQQ {
    JSAccountManager *manager = [JSAccountManager shareManager];
    manager.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_App_ID andDelegate:manager];
    //    manager.tencentOAuth.redirectURI = @"http://www.17getfun.com";
    
}

+ (BOOL)handleQQURL:(NSURL *)url {
    [QQApiInterface handleOpenURL:url delegate:[JSAccountManager shareManager]];;
    if ([TencentOAuth CanHandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return NO;
}

+ (void)qqAuthorizeFromLogin:(BOOL)fromLogin completion:(AuthorizeHandler)completion {
    
    JSAccountManager *manager = [JSAccountManager shareManager];
    manager.authorizeForLogin = fromLogin;
    manager.authorizeHandler = completion;
    
    NSArray *permissions = @[kOPEN_PERMISSION_GET_USER_INFO,
                             kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                             kOPEN_PERMISSION_ADD_ALBUM,
                             kOPEN_PERMISSION_ADD_ONE_BLOG,
                             kOPEN_PERMISSION_ADD_SHARE,
                             kOPEN_PERMISSION_ADD_TOPIC,
                             kOPEN_PERMISSION_CHECK_PAGE_FANS,
                             kOPEN_PERMISSION_GET_INFO,
                             kOPEN_PERMISSION_GET_OTHER_INFO,
                             kOPEN_PERMISSION_LIST_ALBUM,
                             kOPEN_PERMISSION_UPLOAD_PIC,
                             kOPEN_PERMISSION_GET_VIP_INFO,
                             kOPEN_PERMISSION_GET_VIP_RICH_INFO];
    [manager.tencentOAuth authorize:permissions];
}

+ (BOOL)shareURLToQQ:(NSString *)url title:(NSString *)title description:(NSString *)description thumbnail:(UIImage *)thumbnail type:(GFShareType)type handler:(ShareResponseHandler)handler {
    
    if (![url isNotBlank] || ![title isNotBlank]) {
        return NO;
    }
    
    qqShareHandler = handler;
//    QQApiWebImageObject *webImageObject = [QQApiWebImageObject objectWithPreviewImageURL:[NSURL URLWithString:url] title:title description:description];
    
    QQApiNewsObject* newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:UIImageJPEGRepresentation(thumbnail, 0.5)];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:newsObject];
    
    QQApiSendResultCode code = EQQAPISENDSUCESS;
    if (type == GFShareTypeQZone) {
        code = [QQApiInterface SendReqToQZone:req];
    } else {
        code = [QQApiInterface sendReq:req];
    }
    
    return YES;
}

+ (BOOL)shareWebImageToQQ:(NSString *)url
                    title:(NSString *)title
              description:(NSString *)description
                     type:(GFShareType)type
                  handler:(ShareResponseHandler)handler{
    if (![url isNotBlank] || ![title isNotBlank]) {
        return NO;
    }
    qqShareHandler = handler;
    
    UIImage *image = [UIImage imageNamed:url];
    QQApiImageObject *webImageObject = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(image,1.0f) previewImageData:UIImageJPEGRepresentation(image,1.0f) title:title description:description];
    
//    QQApiWebImageObject *webImageObject = [QQApiWebImageObject objectWithPreviewImageURL:[NSURL URLWithString:url] title:title description:description];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:webImageObject];
    
    QQApiSendResultCode code = EQQAPISENDSUCESS;
    if (type == GFShareTypeQZone) {
        code = [QQApiInterface SendReqToQZone:req];
    } else {
        code = [QQApiInterface sendReq:req];
    }
    
    return YES;
}

#pragma mark - TencentLoginDelegate
- (void)tencentDidLogin {
    
    if (self.authorizeForLogin) {
//        [self getfunQQLogin];
        
    } else {
        if (self.authorizeHandler) {
            self.authorizeHandler(YES);
            self.authorizeHandler = nil;
        }
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
}

#pragma mark - QQApiInterfaceDelegate
- (void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    if ([resp isKindOfClass:[BaseResp class]]) {
        [self handleWeChatResp:resp];
    } else if ([resp isKindOfClass:[QQBaseResp class]]) {
        [self handleSendMessageToQQResp:resp];
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}

- (void)handleSendMessageToQQResp:(id)resp {
    if (![resp isKindOfClass:[SendMessageToQQResp class]]) return;
    
    SendMessageToQQResp *qqResp = (SendMessageToQQResp *)resp;
    if (qqResp.type == ESENDMESSAGETOQQRESPTYPE) {
        NSInteger result = [qqResp.result integerValue];
        if (qqShareHandler) {
            if (result == 0) {
                // 分享成功
                qqShareHandler(YES, NO);
            } else if (result == -4) {
                // 放弃分享
                qqShareHandler(NO, YES);
            } else {
                // 其它原因分享失败
                qqShareHandler(NO, NO);
            }
            qqShareHandler = nil;
        }
    }
}
@end

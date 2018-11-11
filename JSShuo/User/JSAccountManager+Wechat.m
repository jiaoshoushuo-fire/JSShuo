//
//  JSAccountManager+Wechat.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAccountManager+Wechat.h"
#import "JSNetworkManager+Login.h"
#import "JSAccountManager+QQ.h"

static ShareResponseHandler wechatShareHandler = nil;

@implementation JSAccountManager (Wechat)


+ (BOOL)wechatSupported {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

+ (void)initWechat {
    [WXApi registerApp:wechat_App_ID];
}

+ (BOOL)handleWechatURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[JSAccountManager shareManager]];
}

+ (void)wechatAuthorizeFromLogin:(BOOL)fromLogin completion:(AuthorizeHandler)completion {
    
    [JSAccountManager shareManager].authorizeHandler = completion;
    
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact,post_timeline,sns";
    req.state = fromLogin ? @"login" : @"share";
    [WXApi sendReq:req];
}

+ (BOOL)shareURLToWechat:(NSString *)url title:(NSString *)title description:(NSString *)description thumbnail:(UIImage *)thumbnail type:(GFShareType)type handler:(ShareResponseHandler)handler {
    
    if (![url isNotBlank]) {
        return NO;
    }
    
    wechatShareHandler = handler;
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = webpageObject;
    if (thumbnail) {
        message.thumbData = UIImageJPEGRepresentation(thumbnail, 1.0f);
    }
    
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    request.bText = NO;
    request.message = message;
    request.scene = (type == GFShareTypeWechatTimeline) ? WXSceneTimeline : WXSceneSession;
    
    return [WXApi sendReq:request];
}


#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[BaseResp class]]) {
        [self handleWeChatResp:resp];
    } else if ([resp isKindOfClass:[QQBaseResp class]]) {
        [self handleSendMessageToQQResp:resp];
    }
}

- (void)handleWeChatResp:(id)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        // 授权
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == WXSuccess) {
            
            BOOL fromLogin = [authResp.state isEqualToString:@"login"];
            if (fromLogin) {
                // 登录授权
                [self getfunWechatLogin:authResp.code];
            } else {
                // 分享授权
                [self getWechatAccessToken:authResp.code];
            }
        } else {
            if (self.authorizeHandler) {
                self.authorizeHandler(NO);
                self.authorizeHandler = nil;
            }
        }
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 分享
        SendMessageToWXResp *sendMsgResp = (SendMessageToWXResp *)resp;
        if (wechatShareHandler) {
            if (sendMsgResp.errCode == WXSuccess) {
                // 分享成功
                wechatShareHandler(YES, NO);
            } else if (sendMsgResp.errCode == WXErrCodeUserCancel) {
                // 取消分享
                wechatShareHandler(NO, YES);
            } else {
                // 其它原因分享失败
                wechatShareHandler(NO, NO);
            }
            wechatShareHandler = nil;
        }
    }
}


#pragma mark - 私有方法
- (void)getfunWechatLogin:(NSString *)code {
    [JSNetworkManager wechatLoginWithAuthCode:code appid:wechat_App_ID complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
        if (isSuccess) {
            if (self.authorizeHandler) {
                self.authorizeHandler(YES);
                self.authorizeHandler = nil;
            }
        }else{
            if (self.authorizeHandler) {
                self.authorizeHandler(NO);
                self.authorizeHandler = nil;
            }
        }
    }];
}

- (void)getWechatAccessToken:(NSString *)code {
    NSString *urlStr = @"https://api.weixin.qq.com/sns/oauth2/access_token";
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:wechat_App_ID forKey:@"appid"];
    [para setObject:wechat_APP_SECRET forKey:@"secret"];
    [para setObject:code forKey:@"code"];
    [para setObject:@"authorization_code" forKey:@"grant_type"];
    
//    @weakify(self)
    [JSNetworkManager normalPOST:urlStr parameters:para complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (isSuccess) {
            // 分享授权
            if (self.authorizeHandler) {
                self.authorizeHandler(YES);
                self.authorizeHandler = nil;
            }
        }else{
            if (self.authorizeHandler) {
                self.authorizeHandler(NO);
                self.authorizeHandler = nil;
            }
        }
    }];

}
@end

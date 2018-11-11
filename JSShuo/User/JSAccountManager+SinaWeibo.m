//
//  JSAccountManager+SinaWeibo.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAccountManager+SinaWeibo.h"

static ShareResponseHandler sinaWeiboShareHandler = nil;
@implementation JSAccountManager (SinaWeibo)


+ (void)initSinaWeibo {
    [WeiboSDK enableDebugMode:YES];
    
    NSString *weiboAppKey = weibo_AppKey;
    [WeiboSDK registerApp:weiboAppKey];
}

+ (BOOL)handleSinaWeiboURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:[JSAccountManager shareManager]];
}

+ (void)sinaWeiboAuthorizeFromLogin:(BOOL)fromLogin completion:(AuthorizeHandler)completion {
    
    [JSAccountManager shareManager].authorizeHandler = completion;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = @"http://www.17getfun.com";
    request.scope = @"all";
    request.userInfo = @{
                         @"state" : (fromLogin ? @"login" : @"share")
                         };
    
    [WeiboSDK sendRequest:request];
}


+ (BOOL)shareImageToSinaWeibo:(UIImage *)image text:(NSString *)text handler:(ShareResponseHandler)handler {
    
    if (!image) return NO;
    
    sinaWeiboShareHandler = handler;
    
    
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1);
    
    WBMessageObject *message = [WBMessageObject message];
    message.imageObject = imageObject;
    message.text = text;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.scope = @"follow_app_official_microblog";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    
    return YES;
}


#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        // 授权响应
        WBAuthorizeResponse *authResponse = (WBAuthorizeResponse *)response;
        if (authResponse.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            
            
            BOOL fromLogin = [[response.requestUserInfo objectForKey:@"state"] isEqualToString:@"login"];
            if (fromLogin) {
//                [self getfunSinaWeiboLogin];
            } else {
                // 分享授权
                if (self.authorizeHandler) {
                    self.authorizeHandler(YES);
                    self.authorizeHandler = nil;
                }
            }
        } else {
            if (self.authorizeHandler) {
                self.authorizeHandler(NO);
                self.authorizeHandler = nil;
            }
        }
    } else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        // 分享响应
        WBSendMessageToWeiboResponse *sendMsgResp = (WBSendMessageToWeiboResponse *)response;
        if (sinaWeiboShareHandler) {
            if (sendMsgResp.statusCode == WeiboSDKResponseStatusCodeSuccess) {
                // 分享成功
                sinaWeiboShareHandler(YES, NO);
            } else if (sendMsgResp.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
                // 取消分享
                sinaWeiboShareHandler(NO, YES);
            } else {
                // 其它原因分享失败
                sinaWeiboShareHandler(NO, NO);
            }
            sinaWeiboShareHandler = nil;
        }
    }
}

//- (void)getfunSinaWeiboLogin {
//    NSTimeInterval expireInSeconds = [self.sinaWeiboAuthorizeResponse.expirationDate timeIntervalSince1970];
//    expireInSeconds = floor(expireInSeconds * 1000);
//    [GFNetworkManager sinaWeiboLoginWithUid:self.sinaWeiboAuthorizeResponse.userID
//                                accessToken:self.sinaWeiboAuthorizeResponse.accessToken
//                            expireInSeconds:@(expireInSeconds)
//                                    success:^(NSUInteger taskId, NSInteger code, NSString *apiErrorMessage, NSString *refreshToken, NSString *accessToken, GFUserMTL *user, BOOL shouldCompleteProfile) {
//                                        if (code == 1) {
//                                            [GFAccountManager updateLoginType:GFLoginTypeSinaWeibo
//                                                                 refreshToken:refreshToken
//                                                                  accessToken:accessToken
//                                                                         user:user];
//                                            
//                                            if (self.authorizeHandler) {
//                                                self.authorizeHandler(YES);
//                                            }
//                                        } else {
//                                            if (self.authorizeHandler) {
//                                                self.authorizeHandler(NO);
//                                            }
//                                        }
//                                        self.authorizeHandler = nil;
//                                    } failure:^(NSUInteger taskId, NSError *error) {
//                                        if (self.authorizeHandler) {
//                                            self.authorizeHandler(NO);
//                                        }
//                                        self.authorizeHandler = nil;
//                                    }];
//}
@end

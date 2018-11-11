//
//  JSAccountManager+Wechat.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAccountManager.h"


NS_ASSUME_NONNULL_BEGIN

static NSString *wechat_App_ID = @"wx84fd8fba0a29ae12";
static NSString *wechat_APP_SECRET = @"92c8d5c2c18f65302839d9aef5c94494";

@interface JSAccountManager (Wechat)<WXApiDelegate>


+ (BOOL)wechatSupported;
+ (void)initWechat;
+ (BOOL)handleWechatURL:(NSURL *)url;



+ (void)wechatAuthorizeFromLogin:(BOOL)fromLogin completion:(AuthorizeHandler)completion;


+ (BOOL)shareURLToWechat:(NSString *)url
                   title:(NSString *)title
             description:(NSString *)description
               thumbnail:(UIImage *)thumbnail
                    type:(GFShareType)type
                 handler:(ShareResponseHandler)handler;

//+ (BOOL)shareImageToWechat:(UIImage *)image
//                     title:(NSString *)title
//               description:(NSString *)description
//                 thumbnail:(UIImage *)thumbnail
//                      type:(GFShareType)type;

- (void)handleWeChatResp:(id)resp;

@end

NS_ASSUME_NONNULL_END

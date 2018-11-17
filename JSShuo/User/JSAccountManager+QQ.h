//
//  JSAccountManager+QQ.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAccountManager.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *QQ_App_ID = @"1104254720";


@interface JSAccountManager (QQ)<TencentSessionDelegate, QQApiInterfaceDelegate>

+ (void)initQQ;
+ (BOOL)handleQQURL:(NSURL *)url;


+ (void)qqAuthorizeFromLogin:(BOOL)fromLogin completion:(AuthorizeHandler)completion;

+ (BOOL)shareURLToQQ:(NSString *)url
               title:(NSString *)title
         description:(NSString *)description
           thumbnail:(UIImage *)thumbnail
                type:(GFShareType)type
             handler:(ShareResponseHandler)handler;

- (void)handleSendMessageToQQResp:(id)resp;

@end

NS_ASSUME_NONNULL_END

//
//  JSAccountManager+SinaWeibo.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAccountManager.h"
#import <WeiboSDK.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *weibo_AppKey = @"wx84fd8fba0a29ae12";

@interface JSAccountManager (SinaWeibo)<WeiboSDKDelegate>

+ (void)initSinaWeibo;
+ (BOOL)handleSinaWeiboURL:(NSURL *)url;


+ (void)sinaWeiboAuthorizeFromLogin:(BOOL)fromLogin completion:(AuthorizeHandler)completion;



+ (BOOL)shareImageToSinaWeibo:(UIImage *)image
                         text:(NSString *)text
                      handler:(ShareResponseHandler)handler;




@end

NS_ASSUME_NONNULL_END

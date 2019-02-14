//
//  JSTool.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/12/9.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSTool : NSObject

+ (void)appStoreComent;

+ (void)showAlertWithRewardDictiony:(NSDictionary *)rewardDict handle:(void(^)(void))handle;


+ (NSString *)compareCurrentTime:(NSString *)str;

+ (NSString *)timeFormatted:(int)totalSeconds;

+(NSData *)zipNSDataWithImage:(UIImage *)sourceImage;
@end

NS_ASSUME_NONNULL_END

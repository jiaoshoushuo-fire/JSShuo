//
//  JSNetworkManager+Login.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef  NS_ENUM(NSInteger, JSRequestSecurityCodeType){
    JSRequestSecurityCodeTypeRegister = 1,
    JSRequestSecurityCodeTypeLogin,
    JSRequestSecurityCodeTypeResetpassword,
    JSRequestSecurityCodeTypeChangepassword,
    JSRequestSecurityCodeTypeAskteacher
};

@interface JSNetworkManager (Login)

//发验证码
+ (void)requestSecurityCodeWithPhoneNumber:(NSString *)phoneNumber type:(JSRequestSecurityCodeType)type complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

+ (void)loginAccountNumberWithPhoneNumber:(NSString *)phoneNumber securityCode:(NSString *)securityCode complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

+ (void)wechatLoginWithAuthCode:(NSString *)code appid:(NSString *)appid complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

+ (void)loginOutWithComplement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

//个人主页
+ (void)requestProfileDateWithComplement:(void(^)(BOOL isSuccess,NSDictionary *dataDict))complement;

//消息列表
+ (void)requestMessageListWithType:(NSInteger) type pageNum:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;
@end

NS_ASSUME_NONNULL_END
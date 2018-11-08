//
//  JSNetworkManager+Login.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Login.h"
const static NSString *getSecurityCodeUrl = @"/v1/sms/sendValidateCode";
const static NSString *loginAccountUrl = @"/v1/user/login";
const static NSString *wechatLoginPostUrl = @"/v1/thirdpt/login/wechat";
const static NSString *profilePostUrl = @"/v1/user/info/center";
const static NSString *profileMessageUrl = @"/v1/user/message/list";
const static NSString *loginOutUrl = @"/v1/user/logout";

@implementation JSNetworkManager (Login)

+ (void)requestSecurityCodeWithPhoneNumber:(NSString *)phoneNumber type:(JSRequestSecurityCodeType)type complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getSecurityCodeUrl];
    NSDictionary *param = @{@"mobile":phoneNumber,@"type":@(type)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        //测试用
        NSString *validCode = responseDict[@"validCode"];
        [self showErrorMessgae:validCode];
        
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)loginAccountNumberWithPhoneNumber:(NSString *)phoneNumber securityCode:(NSString *)securityCode complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,loginAccountUrl];
    NSDictionary *param = @{@"mobile":phoneNumber,@"validateCode":securityCode};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        
        if (isSuccess) {
            NSString *token = responseDict[@"token"];
            [JSAccountManager refreshAccountToken:token];
        }
        
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
+ (void)wechatLoginWithAuthCode:(NSString *)code appid:(NSString *)appid complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,wechatLoginPostUrl];
    NSDictionary *param = @{@"code":code,@"wechatAppId":appid};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
    
}

+ (void)requestProfileDateWithComplement:(void(^)(BOOL isSuccess,NSDictionary *dataDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,profilePostUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

//消息列表
+ (void)requestMessageListWithType:(NSInteger) type pageNum:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,profileMessageUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"type":@(type),@"pageNum":@(pageNumber)};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)loginOutWithComplement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,loginOutUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
@end

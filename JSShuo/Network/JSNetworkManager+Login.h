//
//  JSNetworkManager+Login.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"
#import "JSProfileUserModel.h"
#import "JSAccountModel.h"

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

//完善资料查询
+ (void)queryUserInformationWitchComplement:(void(^)(BOOL isSuccess,JSProfileUserModel *userModel))complement;

+ (void)modifyUserInfoWithDict:(NSDictionary *)dict complement:(void(^)(BOOL isSuccess, NSDictionary*contenDict))complement;

+ (void)uploadImage:(UIImage *)image complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complemnt;

+ (void)feedbackText:(NSString *)text images:(NSArray *)images complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement;

//查询提现规则
+ (void)queryWithdrawInfoWithComplement:(void(^)(BOOL isSuccess,NSDictionary *dataDict))complement;

//提现
+ (void)getMoneyWithMethod:(NSString *)method count:(NSInteger)amount complement:(void(^)(NSInteger code, NSString *message))complement;

//账户查询
+ (void)queryAccountInfoWithComplement:(void(^)(BOOL isSuccess,JSAccountModel *accountModel))complement;

//账户流水
+ (void)queryListWithTypeIndex:(NSInteger)index pageNumber:(NSInteger)pageIndex complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

//兑换
+ (void)exchangeWithMoney:(NSInteger)money complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement;
@end

NS_ASSUME_NONNULL_END

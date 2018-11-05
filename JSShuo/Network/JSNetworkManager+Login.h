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

+ (void)requestSecurityCodeWithPhoneNumber:(NSString *)phoneNumber type:(JSRequestSecurityCodeType)type complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;
@end

NS_ASSUME_NONNULL_END

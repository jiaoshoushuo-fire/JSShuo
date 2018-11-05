//
//  JSNetworkManager+Login.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Login.h"
const static NSString *getSecurityCodeUrl = @"/v1/sms/sendValidateCode";

@implementation JSNetworkManager (Login)

+ (void)requestSecurityCodeWithPhoneNumber:(NSString *)phoneNumber type:(JSRequestSecurityCodeType)type complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getSecurityCodeUrl];
    NSDictionary *param = @{@"mobile":phoneNumber,@"type":@(type)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        NSString *validCode = responseDict[@"validCode"];
        [self showErrorMessgae:validCode];
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
@end

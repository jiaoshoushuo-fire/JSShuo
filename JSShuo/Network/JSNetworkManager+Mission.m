//
//  JSNetworkManager+Mission.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/21.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Mission.h"
const static NSString *getSignRuleUrl = @"/v1/signin/rule";
const static NSString *getSignCreateUrl = @"/v1/signin/create";
const static NSString *getTaskListUrl = @"/v1/task/list";

@implementation JSNetworkManager (Mission)

+ (void)requestMissonRulComplement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getSignRuleUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (isSuccess) {
            if (complement) {
                complement(isSuccess,responseDict);
            }
        }
    }];
}

//签到
+ (void)requestSignCreateComplement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getSignCreateUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

//任务列表
+ (void)requestTaskListComplement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getTaskListUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
@end

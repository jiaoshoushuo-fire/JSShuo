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
const static NSString *postTaskDoneUrl = @"/v1/task/taskDoneTest";
const static NSString *getActivityUrl = @"/v1/activity/grabredpackage/info";
const static NSString *getCurrentActUrl = @"/v1/activity/grabredpackage/current";
const static NSString *getOpenedRedListUrl = @"/v1/activity/grabredpackage/rank";
const static NSString *postOpenPackageUrl = @"/v1/activity/grabredpackage/grab";

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

+ (void)requestActivityHomePageComplement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getActivityUrl];
//    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self GET:url parameters:nil complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

//当前活动
+ (void)requestCurrentActivityComplement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getCurrentActUrl];
    
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
+ (void)requestOpenedRedPackageListComplement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getOpenedRedListUrl];
    
    NSDictionary *param = @{@"limit":@"10"};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

//抢红包接口
+ (void)requestOpenedPackageWithID:(NSInteger)ID Complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,postOpenPackageUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"grabRedPackageId":@(ID)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)requestTaskDoneWithNo:(NSString *)taskNo complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,postTaskDoneUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"taskNo":taskNo};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
@end

//
//  JSNetworkManager+Mission.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/21.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNetworkManager (Mission)

//签到规则
+ (void)requestMissonRulComplement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;

//签到
+ (void)requestSignCreateComplement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;

//任务列表
+ (void)requestTaskListComplement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;
@end

NS_ASSUME_NONNULL_END

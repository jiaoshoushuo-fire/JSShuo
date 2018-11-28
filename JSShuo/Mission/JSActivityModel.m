//
//  JSActivityModel.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/25.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSActivityModel.h"

@implementation JSActivityModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"grabRedPackageId" : @"grabRedPackageId",
             @"amount" : @"amount",
             @"remainAmount" : @"remainAmount",
             @"num" : @"num",
             @"remainNum":@"remainNum",
             
             @"canGrab":@"canGrab",
             @"nextStartTime":@"nextStartTime"
             };
}
@end

@implementation JSActivityUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId" : @"userId",
             @"nickname" : @"nickname",
             @"portrait" : @"portrait",
             @"amount" : @"amount"
             };
}

@end

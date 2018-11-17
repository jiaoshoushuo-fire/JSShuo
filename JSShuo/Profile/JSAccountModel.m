//
//  JSAccountModel.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/16.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAccountModel.h"

@implementation JSAccountModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"accountId" : @"accountId",
             @"coin" : @"coin",
             @"exchangeRate" : @"exchangeRate",
             @"money" : @"money",
             @"todayCoin" : @"todayCoin",
             @"todayMoney" : @"todayMoney",
             @"totalMoney" : @"totalMoney"
             };
}

@end

@implementation JSDealModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"accountDetailId" : @"accountDetailId",
             @"accountId" : @"accountId",
             @"coin" : @"coin",
             @"money" : @"money",
             @"inOrOut" : @"inOrOut",
             @"type" : @"type",
             @"category" : @"category",
             @"createTime":@"createTime",
             @"dealdescription":@"description"
             };
}

@end

@implementation JSListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"friendNum" : @"friendNum",
             @"totalCoin" : @"totalCoin",
             @"userId" : @"userId"
             };
}


@end

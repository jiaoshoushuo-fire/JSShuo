//
//  JSWithdrawModel.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/13.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSWithdrawModel.h"

@implementation JSWithdrawItemModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"amount" : @"amount",
             @"money" : @"money",
             @"sort" : @"sort",
             @"withdrawRuleId" : @"withdrawRuleId"
             };
}

@end

@implementation JSWithdrawModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"amount" : @"amount",
             @"noteBody" : @"noteBody",
             @"noteTitle" : @"noteTitle",
             @"ruleList" : @"ruleList"
             };
}


+ (NSValueTransformer *)ruleListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JSWithdrawItemModel class]];
}
@end

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

//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
//    if ([key isEqualToString:@"amount"] || [key isEqualToString:@"money"]){
//        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//            return @([value integerValue]/100);
//        }];
//    }
//    return nil;
//}

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

//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
//    if ([key isEqualToString:@"amount"]){
//        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//            NSString *valueString = [NSString stringWithFormat:@"%.2f",[value integerValue]/100.00f];
//            return valueString;
//        }];
//    }
//    return nil;
//}
@end

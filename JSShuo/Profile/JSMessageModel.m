//
//  JSMessageModel.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMessageModel.h"

@implementation JSMessageModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userMessageId" : @"userMessageId",
             @"createTime" : @"createTime",
             @"content" : @"content",
             @"title" : @"title",
             @"type" : @"type",
             @"isRead" : @"isRead"
             };
}
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"isRead"]){
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            return @([value intValue] == 1);
        }];
    }
    return nil;
}

@end

@implementation JSMessageListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"list" : @"list",
             @"totalPage" : @"totalPage"
             };
}

+ (NSValueTransformer *)listJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JSMessageModel class]];
}
@end

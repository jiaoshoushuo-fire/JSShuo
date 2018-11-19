//
//  JSCollectModel.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/19.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSCollectModel.h"

@implementation JSCollectModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"collectId" : @"collectId",
             @"userId" : @"userId",
             @"type" : @"type",
             @"title" : @"title",
             @"channel" : @"channel",
             @"videoUrl" : @"videoUrl",
             @"createTime" : @"createTime",
             @"publishTime" : @"publishTime"
             };
}

@end

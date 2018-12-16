//
//  JSCollectModel.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/19.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSCollectModel.h"

@implementation JSCollectModel

//@property (nonatomic, assign)NSInteger collectId;
//@property (nonatomic, assign)NSInteger articleId;
//@property (nonatomic, assign)NSInteger userId;
//@property (nonatomic, assign)NSInteger type;
//@property (nonatomic, assign)NSInteger mediaType;
//@property (nonatomic, assign)NSInteger duration;
//@property (nonatomic, strong)NSArray *cover;
//@property (nonatomic, copy)NSString *title;
//@property (nonatomic, copy)NSString *summary;
//@property (nonatomic, copy)NSString *channel;
//@property (nonatomic, copy)NSString *videoUrl;
//@property (nonatomic, copy)NSString *createTime;
//@property (nonatomic, copy)NSString *publishTime;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"collectId" : @"collectId",
             @"articleId":@"articleId",
             @"userId":@"userId",
             @"mediaType":@"mediaType",
             @"duration":@"duration",
             @"cover":@"cover",
             @"summary":@"summary",
             @"type" : @"type",
             @"title" : @"title",
             @"channel" : @"channel",
             @"videoUrl" : @"videoUrl",
             @"createTime" : @"createTime",
             @"publishTime" : @"publishTime"
             };
}

@end

@implementation JSApprentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"apprenticeId" : @"apprenticeId",
             @"userId" : @"userId",
             @"masterId" : @"masterId",
             @"portrait" : @"portrait",
             @"nickname" : @"nickname",
             @"lastLoginTime" : @"lastLoginTime",
             @"wakeUpTime" : @"wakeUpTime",
             @"canWakeUp" : @"canWakeUp"
             };
}

@end

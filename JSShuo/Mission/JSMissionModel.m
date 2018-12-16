//
//  JSMissionModel.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/21.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMissionModel.h"

@implementation JSMissionRewardModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"amount" : @"amount",
             @"amountType" : @"amountType",
             @"coin" : @"coin",
             @"message" : @"message",
             @"money" : @"money",
             @"rewardCode" : @"rewardCode",
             @"rewardType" : @"rewardType"
             };
}

@end

@implementation JSMissionSignModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"continueDay" : @"continueDay",
             @"isValid" : @"isValid",
             @"rewardCoin" : @"rewardCoin",
             @"rewardMoney" : @"rewardMoney",
             @"signInRuleId" : @"signInRuleId"
             };
}

@end

@implementation JSMissionModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"misDescription" : @"description",
             @"isDone" : @"isDone",
             @"isHot" : @"isHot",
             @"rewardCoin" : @"rewardCoin",
             @"rewardDescription" : @"rewardDescription",
             @"rewardMoney":@"rewardMoney",
             @"rewardType":@"rewardType",
             @"taskId":@"taskId",
             @"taskNo":@"taskNo",
             @"title":@"title",
             @"type":@"type"
             };
}
@end

@implementation JSMissSubModel

- (instancetype)initWithModel:(JSMissionModel *)model{
    self = [super init];
    if (self) {
        self.misDescription = model.misDescription;
        self.isDone = model.isDone;
        self.taskId = model.taskId;
        self.taskNo = model.taskNo;
    }
    return self;
}

@end

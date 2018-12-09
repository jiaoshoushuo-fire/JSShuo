//
//  JSTool.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/12/9.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSTool.h"

@implementation JSTool

/**
 * 可评分评论，无次数限制
 */
+ (void)appStoreComent{
    NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"1242757440"];//替换为对应的APPID
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
    
}

+ (void)showAlertType:(JSALertType)alertType withRewardDictiony:(NSDictionary *)rewardDict{
    if (rewardDict) {
        JSMissionRewardModel *rewardModel = [MTLJSONAdapter modelOfClass:[JSMissionRewardModel class] fromJSONDictionary:rewardDict error:nil];
        if (rewardModel.rewardCode == 0) {
            [JSAlertView showAlertViewWithType:alertType rewardModel:rewardModel superView:[UIApplication sharedApplication].keyWindow handle:^{
                
            }];
        }
    }
}

@end

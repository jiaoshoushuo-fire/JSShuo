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

+ (void)showAlertWithRewardDictiony:(NSDictionary *)rewardDict handle:(void(^)(void))handle{
    if (rewardDict) {
        JSMissionRewardModel *rewardModel = [MTLJSONAdapter modelOfClass:[JSMissionRewardModel class] fromJSONDictionary:rewardDict error:nil];
        if (rewardModel.rewardCode == 0) {
            if (rewardModel.amountType == 1) {//金币
//                if (rewardModel.rewardType == 1) {//普通
//                    [JSAlertView showAlertViewWithType:JSALertTypeNomal rewardModel:rewardModel superView:[UIApplication sharedApplication].keyWindow handle:handle];
//                }else if (rewardModel.rewardType == 2){//彩蛋
//                    [JSAlertView showAlertViewWithType:JSALertTypeGold rewardModel:rewardModel superView:[UIApplication sharedApplication].keyWindow handle:handle];
//                }
            }else if (rewardModel.amountType == 2){//零钱
                [JSAlertView showAlertViewWithType:JSALertTypeFirstLoginIn rewardModel:rewardModel superView:[UIApplication sharedApplication].keyWindow handle:handle];
            }
        }
    }
}


#pragma mark - 时间显示
/**
*  显示几分钟前、几小时前等 str格式：yyyy-MM-dd HH:mm:ss
*/
+ (NSString *)compareCurrentTime:(NSString *)str{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0; NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
        
    } else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
        
    } else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
        
    } else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
        
    } else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
        
    } else{
        temp = temp/12; result = [NSString stringWithFormat:@"%ld年前",temp];
        
    } return result;
    
}

+ (NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}


@end

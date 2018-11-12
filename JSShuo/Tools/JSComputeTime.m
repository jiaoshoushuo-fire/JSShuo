//
//  JSComputeTime.m
//  JSShuo
//
//  Created by li que on 2018/11/7.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSComputeTime.h"

@implementation JSComputeTime

+ (void) distanceTimeWithPublistTime:(NSString *)publishTime complement:(void(^)(NSString *distanceTime))complent {
    // 获取当前时间，获得的时0市区的时间跟北京时间相差8小时
    //    NSDate *currentDate = [NSDate date]; // GMT
    
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:publishTime];
    
    NSTimeInterval intervalNow = fabs([date timeIntervalSinceNow]);
    //    NSLog(@"%f",intervalNow);
    
    float hoursToCurrentTime = intervalNow / 60 / 60; // 小时数
    float daysToCurrentTime = intervalNow / 60 / 60 / 24; // 天数
    float monthsToCurrentTime = intervalNow / 60 / 60 / 24 / 30; // 月份
    float yearsToCurrentTime = intervalNow / 60 / 60 / 24 / 30 / 12; // 年
    
    NSString *timer;
    int time;
    if (1 >= hoursToCurrentTime > 0) { // 分钟
        time = hoursToCurrentTime*60;
        timer = [NSString stringWithFormat:@"%d分钟",time];
    } else if ( 24 > hoursToCurrentTime ) { // 小时
        time = (int)hoursToCurrentTime;
        timer = [NSString stringWithFormat:@"%d小时",time];
    } else if ( 30 >= daysToCurrentTime >= 1 ) { // 天数
        time = (int) daysToCurrentTime;
        timer = [NSString stringWithFormat:@"%d天",time];
    } else if ( 12 >= monthsToCurrentTime >= 1 ) { // 月份
        time = (int)monthsToCurrentTime;
        timer = [NSString stringWithFormat:@"%f月",monthsToCurrentTime];
    } else if ( yearsToCurrentTime >= 1 ) { // 年
        time = (int)yearsToCurrentTime;
        timer = [NSString stringWithFormat:@"%f年前",yearsToCurrentTime];
    }
    if (complent) {
        complent(timer);
    }
}

- (NSString *) distanceTimeWithPublistTime:(NSString *)publishTime {
    // 获取当前时间，获得的时0市区的时间跟北京时间相差8小时
//    NSDate *currentDate = [NSDate date]; // GMT
    
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:publishTime];
    
    NSTimeInterval intervalNow = fabs([date timeIntervalSinceNow]);
//    NSLog(@"%f",intervalNow);
    
    float hoursToCurrentTime = intervalNow / 60 / 60; // 小时数
    float daysToCurrentTime = intervalNow / 60 / 60 / 24; // 天数
    float monthsToCurrentTime = intervalNow / 60 / 60 / 24 / 30; // 月份
    float yearsToCurrentTime = intervalNow / 60 / 60 / 24 / 30 / 12; // 年
    
    NSString *timer;
    int time;
    if (1 >= hoursToCurrentTime > 0) { // 分钟
        time = hoursToCurrentTime*60;
        timer = [NSString stringWithFormat:@"%d分钟前",time];
    } else if ( 24 > hoursToCurrentTime ) { // 小时
        time = (int)hoursToCurrentTime;
        timer = [NSString stringWithFormat:@"%d小时前",time];
    } else if ( 30 >= daysToCurrentTime >= 1 ) { // 天数
        time = (int) daysToCurrentTime;
        timer = [NSString stringWithFormat:@"%d天前",time];
    } else if ( 12 >= monthsToCurrentTime >= 1 ) { // 月份
        time = (int)monthsToCurrentTime;
        timer = [NSString stringWithFormat:@"%d月前",time];
    } else if ( yearsToCurrentTime >= 1 ) { // 年
        time = (int)yearsToCurrentTime;
        timer = [NSString stringWithFormat:@"%d年前",time];
    }
    return timer;
}

@end

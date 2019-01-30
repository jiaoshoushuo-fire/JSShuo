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



+(NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>640||height>640) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 640;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 640;
            width = height*scale;
        }
        //2.宽大于1280高小于1280
    }else if(width>640||height<640){
        CGFloat scale = height/width;
        width = 640;
        height = width*scale;
        //3.宽小于1280高大于1280
    }else if(width<640||height>640){
        CGFloat scale = width/height;
        height = 640;
        width = height*scale;
        //4.宽高都小于1280
    }else{
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    return data;
}


@end

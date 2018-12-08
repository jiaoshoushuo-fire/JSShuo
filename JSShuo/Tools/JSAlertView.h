//
//  JSAlertView.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/12/4.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMissionModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JSALertType){
    JSALertTypeFirstLoginIn,//邀请和d第一次登录注册  弹出
    JSALertTypeSignIn,
    JSALertTypeGold
};

@interface JSAlertView : UIView

+ (void)showAlertViewWithType:(JSALertType)alertType rewardModel:(JSMissionRewardModel *)model superView:(UIView *)superView handle:(void(^)(void)) handle;

+ (void)showCIQRCodeImageWithUrl:(NSString *)url superView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END

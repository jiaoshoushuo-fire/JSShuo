//
//  JSWithdrawAlertView.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/14.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , JSWithdrawAlertViewType){
    JSWithdrawAlertViewTypeAlipay,
    JSWithdrawAlertViewTypeWechat,
    JSWithdrawAlertViewTypeBindIPhone
};


NS_ASSUME_NONNULL_BEGIN

@interface JSWithdrawAlertView : UIView

+ (void)showAlertViewWithSuperView:(UIView *)superView type:(JSWithdrawAlertViewType)type isBind:(BOOL)isBind handle:(void(^)(BOOL isSuccess))hande;
@end

NS_ASSUME_NONNULL_END

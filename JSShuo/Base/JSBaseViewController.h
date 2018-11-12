//
//  JSBaseViewController.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSBaseViewController : UIViewController

- (void)userLoginSuccessNoti:(NSNotification *)notification;

- (void)showAutoDismissTextAlert:(NSString *)alert;

- (void)showWaitingHUD;
- (void)hideWaitingHUD;
@end

NS_ASSUME_NONNULL_END

//
//  JSInputBar.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/9.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , JSInputBarType){
    JSInputBarTypeNickname,
    JSInputBarTypeIntroduction
};

NS_ASSUME_NONNULL_BEGIN

@interface JSInputBar : UIView


+ (void)showInputBarWithView:(UIView *)superView type:(JSInputBarType)type complement:(void(^)(NSString *newNickName))complemnt;
@end

NS_ASSUME_NONNULL_END

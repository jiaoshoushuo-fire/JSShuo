//
//  JSAdjustButton.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JSImagePosition ) {
    JSImagePositionLeft    = 0,
    JSImagePositionRight   = 1,
    JSImagePositionUp      = 2,
    JSImagePositionBottom  = 3,
};


@interface JSAdjustButton : UIButton
@property (nonatomic, assign) JSImagePosition position;
@property (nonatomic, assign) CGFloat itemSpace;

@end

NS_ASSUME_NONNULL_END

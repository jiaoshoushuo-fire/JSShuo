//
//  UIColor+JSShuo.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JSShuo)

+ (instancetype)colorWithIndex:(NSInteger)index;
+ (instancetype)randomColor;
+ (instancetype)channelColorWithIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END

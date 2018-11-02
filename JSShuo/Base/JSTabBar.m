//
//  JSTabBar.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSTabBar.h"

@implementation JSTabBar

- (void)layoutSubviews {
    [super layoutSubviews];
    self.translucent = NO;
    Class TabBarButtonClass = NSClassFromString(@"UITabBarButton");
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:TabBarButtonClass]) {
            [subview removeFromSuperview];
        }
    }
}

@end

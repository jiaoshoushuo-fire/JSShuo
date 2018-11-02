//
//  JSNavigationBar.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNavigationBar.h"

@implementation JSNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImage *bgImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"f8f8f8"]];
        [self setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
        
        UIImage *lineImage = [UIImage imageWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.08f] size:CGSizeMake(kScreenWidth, 0.5f)];
        [self setShadowImage:lineImage];
    }
    return self;
}

@end

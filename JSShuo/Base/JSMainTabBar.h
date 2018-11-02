//
//  JSMainTabBar.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMainTabBar : JSTabBar

@property (nonatomic, strong, readonly) UILabel *homeBadge;
@property (nonatomic, strong, readonly) UILabel *newsBadge;

@property (nonatomic, strong, readonly) UIButton *homeButton;
@property (nonatomic, strong, readonly) UIButton *discoverButton;
@property (nonatomic, strong, readonly) UIButton *publishButton;
@property (nonatomic, strong, readonly) UIButton *newsButton;
@property (nonatomic, strong, readonly) UIButton *profileButton;

+ (instancetype)mainTabBarWithHandler:(void (^)(id sender))handler;
- (void)setSelectButtonAtIndex:(NSInteger)index;
- (void)setBadgeNumber:(NSUInteger)number atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END

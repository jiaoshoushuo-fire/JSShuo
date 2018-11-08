//
//  JSMainViewController.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseViewController.h"
#import "JSTabBarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMainViewController : JSTabBarViewController

- (void)switchToViewControllerAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END

//
//  JSLoginViewController.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/2.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSLoginMainViewController : JSBaseViewController

@property (nonatomic, copy)void(^loginComplementBlock)(BOOL isLogin);

@end

NS_ASSUME_NONNULL_END

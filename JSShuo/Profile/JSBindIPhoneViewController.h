//
//  JSBindIPhoneViewController.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/23.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseViewController.h"
#import "JSNetworkManager+Login.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBindIPhoneViewController : JSBaseViewController

@property (nonatomic, assign) JSRequestSecurityCodeType codeType;
@property (nonatomic, copy)void(^complement)(BOOL isFinished);
@end

NS_ASSUME_NONNULL_END

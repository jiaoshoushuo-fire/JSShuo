//
//  JSNotificationViewController.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNotificationViewController : JSBaseViewController

@property (nonatomic, assign)NSInteger messageType;

- (void)reloadListData;
@end

NS_ASSUME_NONNULL_END

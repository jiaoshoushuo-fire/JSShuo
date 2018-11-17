//
//  JSConvertViewController.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/16.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseViewController.h"
#import "JSAccountModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol JSConvertViewControllerDelegate <NSObject>

- (void)didRefreshWithdrawViewController;

@end

@interface JSConvertViewController : JSBaseViewController

@property (nonatomic, strong)JSAccountModel *accountModel;
@property (nonatomic, weak)id <JSConvertViewControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END

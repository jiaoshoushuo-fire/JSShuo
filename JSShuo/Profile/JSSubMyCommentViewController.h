//
//  JSSubMyCommentViewController.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/19.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseViewController.h"
#import "JSProfileUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JSSubMyCommentViewController : JSBaseViewController

@property (nonatomic, assign)BOOL isReceive;
@property (nonatomic, strong,readonly)NSMutableArray *dataArray;
@property (nonatomic, strong)JSProfileUserModel *userModel;
@end

NS_ASSUME_NONNULL_END

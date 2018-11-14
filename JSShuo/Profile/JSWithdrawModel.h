//
//  JSWithdrawModel.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/13.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "MTLModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSWithdrawItemModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign)NSInteger amount;
@property (nonatomic, assign)NSInteger money;
@property (nonatomic, assign)NSInteger sort;
@property (nonatomic, assign)NSInteger withdrawRuleId;
@end

@interface JSWithdrawModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign)NSInteger amount;
@property (nonatomic, copy)NSString *noteBody;
@property (nonatomic, copy)NSString *noteTitle;
@property (nonatomic, strong)NSArray <JSWithdrawItemModel *>*ruleList;
@end

NS_ASSUME_NONNULL_END

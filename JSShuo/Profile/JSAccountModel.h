//
//  JSAccountModel.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/16.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "MTLModel.h"

NS_ASSUME_NONNULL_BEGIN

//{
//    accountId = 1120965;
//    coin = 18;
//    exchangeRate = 20;
//    money = 111;
//    todayCoin = 0;
//    todayMoney = 0;
//    totalCoin = 18;
//    totalMoney = 111;
//}
@interface JSAccountModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, assign)NSInteger accountId;
@property (nonatomic, assign)NSInteger coin;
@property (nonatomic, assign)NSInteger exchangeRate;
@property (nonatomic, assign)NSInteger money;
@property (nonatomic, assign)NSInteger todayCoin;
@property (nonatomic, assign)NSInteger todayMoney;
@property (nonatomic, assign)NSInteger totalMoney;

@end

@interface JSDealModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign)NSInteger accountDetailId;
@property (nonatomic, assign)NSInteger accountId;
@property (nonatomic, assign)NSInteger coin;
@property (nonatomic, assign)NSInteger money;
@property (nonatomic, assign)NSInteger inOrOut;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)NSInteger category;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *dealdescription;

@end

@interface JSListModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign)NSInteger userId;
@property (nonatomic, assign)NSInteger totalCoin;
@property (nonatomic, assign)NSInteger friendNum;

@end

NS_ASSUME_NONNULL_END

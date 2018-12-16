//
//  JSMissionModel.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/21.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "MTLModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMissionRewardModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign)NSInteger amount;
@property (nonatomic, assign)NSInteger amountType;
@property (nonatomic, assign)NSInteger coin;
@property (nonatomic, copy)NSString *message;
@property (nonatomic, assign)NSInteger rewardCode;
@property (nonatomic, assign)NSInteger money;
@property (nonatomic, assign)NSInteger rewardType;

@end

@interface JSMissionSignModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign)NSInteger continueDay;
@property (nonatomic, assign)NSInteger isValid;
@property (nonatomic, assign)NSInteger rewardCoin;
@property (nonatomic, assign)NSInteger rewardMoney;
@property (nonatomic, assign)NSInteger signInRuleId;
@end

@interface JSMissionModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *misDescription;
@property (nonatomic, assign)NSInteger isDone;
@property (nonatomic, assign)NSInteger isHot;
@property (nonatomic, assign)NSInteger rewardCoin;
@property (nonatomic, copy)NSString *rewardDescription;
@property (nonatomic, assign)NSInteger rewardMoney;
@property (nonatomic, assign)NSInteger rewardType;
@property (nonatomic, assign)NSInteger taskId;
@property (nonatomic, copy)NSString *taskNo;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, assign)BOOL isOpen;
@end

@interface JSMissSubModel : NSObject

@property (nonatomic, copy)NSString *misDescription;
@property (nonatomic, assign)NSInteger isDone;
@property (nonatomic, assign)NSInteger taskId;
@property (nonatomic, copy)NSString *taskNo;

- (instancetype)initWithModel:(JSMissionModel *)model;

@end

NS_ASSUME_NONNULL_END

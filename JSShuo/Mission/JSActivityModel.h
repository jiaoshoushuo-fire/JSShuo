//
//  JSActivityModel.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/25.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "MTLModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSActivityModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign)NSInteger grabRedPackageId;
@property (nonatomic, assign)NSInteger amount;
@property (nonatomic, assign)NSInteger remainAmount;
@property (nonatomic, assign)NSInteger num;
@property (nonatomic, assign)NSInteger remainNum;
@property (nonatomic, assign)BOOL canGrab;
@property (nonatomic, copy)NSString *nextStartTime;
@end

@interface JSActivityUserModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign)NSInteger userId;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *portrait;
@property (nonatomic, assign)NSInteger amount;

@end

NS_ASSUME_NONNULL_END

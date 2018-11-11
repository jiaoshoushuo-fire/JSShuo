//
//  JSProfileUserModel.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/7.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "MTLModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface JSProfileUserModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign)NSInteger userId;
@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign)NSInteger age;
@property (nonatomic, assign)NSInteger sex;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign)NSInteger apprenticeNum;
@property (nonatomic, assign)NSInteger coin;
@property (nonatomic, assign)NSInteger money;
@property (nonatomic, assign)NSInteger readTime;
@end

NS_ASSUME_NONNULL_END

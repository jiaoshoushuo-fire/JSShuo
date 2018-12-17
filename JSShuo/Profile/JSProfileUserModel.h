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
@property (nonatomic, copy)NSString *money;
@property (nonatomic, assign)NSInteger readTime;

@property (nonatomic, copy)NSString *jobCategory;
@property (nonatomic, copy)NSString *jobInfo;
@property (nonatomic, copy)NSString *education;
@property (nonatomic, copy)NSString *wechatId;
@property (nonatomic, copy)NSString *alipayId;
@property (nonatomic, assign)NSInteger bindStatus;
@property (nonatomic, copy)NSString *wechatAccount;
@property (nonatomic, copy)NSString *alipayAccount;
@property (nonatomic, assign)NSInteger isWechatBind;
@property (nonatomic, assign)NSInteger isAlipayBind;
@end

NS_ASSUME_NONNULL_END

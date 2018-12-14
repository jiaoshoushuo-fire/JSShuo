//
//  JSProfileUserModel.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/7.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSProfileUserModel.h"

//"userId": 1120933,
//"inviteCode": "AB1120933",
//"portrait": "默认头像",
//"nickname": "张三",
//"age": 12,
//"sex": 2,
//"intro": "1",
//"apprenticeNum": 0,
//"coin": 56,
//"money": 204,
//"readTime": 0
//@property (nonatomic, copy)NSString *jobCategory;
//@property (nonatomic, copy)NSString *jobInfo;
//@property (nonatomic, copy)NSString *education;
//@property (nonatomic, copy)NSString *wechatId;
//@property (nonatomic, copy)NSString *alipayId;
//@property (nonatomic, assign)NSInteger bindStatus;


@implementation JSProfileUserModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId" : @"userId",
             @"inviteCode" : @"inviteCode",
             @"portrait" : @"portrait",
             @"nickname" : @"nickname",
             @"age" : @"age",
             @"sex" : @"sex",
             @"intro" : @"intro",
             @"apprenticeNum" : @"apprenticeNum",
             @"coin" : @"coin",
             @"money" : @"money",
             @"readTime" : @"readTime",
             @"jobCategory" : @"jobCategory",
             @"jobInfo" : @"jobInfo",
             @"education" : @"education",
             @"wechatId" : @"wechatOpenId",
             @"alipayId" : @"alipayId",
             @"bindStatus" : @"bindStatus"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"money"]){
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *valueString = [NSString stringWithFormat:@"%.2f",[value integerValue]/100.00f];
            return valueString;
        }];
    }
    return nil;
}
@end

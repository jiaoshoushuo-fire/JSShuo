//
//  JSNetworkManager+Login.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Login.h"
const static NSString *getSecurityCodeUrl = @"/v1/sms/sendValidateCode";
const static NSString *loginAccountUrl = @"/v1/user/login";
const static NSString *wechatLoginPostUrl = @"/v1/thirdpt/login/wechat";
const static NSString *profilePostUrl = @"/v1/user/info/center";
const static NSString *profileMessageUrl = @"/v1/user/message/list";
const static NSString *loginOutUrl = @"/v1/user/logout";
const static NSString *userInfoQueryUrl = @"/v1/user/info/query";
const static NSString *modifyUserInfoUrl = @"/v1/user/info/modify";
const static NSString *uploadImageUrl = @"/v1/upload/image";
const static NSString *feedbackUrl = @"/v1/user/feedback/create";
const static NSString *withdrawUrl = @"/v1/account/withdraw/queryRule";
const static NSString *getMoneyUrl = @"/v1/account/withdraw/apply";


@implementation JSNetworkManager (Login)

+ (void)requestSecurityCodeWithPhoneNumber:(NSString *)phoneNumber type:(JSRequestSecurityCodeType)type complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getSecurityCodeUrl];
    NSDictionary *param = @{@"mobile":phoneNumber,@"type":@(type)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        //测试用
        NSString *validCode = responseDict[@"validCode"];
        [self showErrorMessgae:validCode];
        
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)loginAccountNumberWithPhoneNumber:(NSString *)phoneNumber securityCode:(NSString *)securityCode complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,loginAccountUrl];
    NSDictionary *param = @{@"mobile":phoneNumber,@"validateCode":securityCode};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        
        if (isSuccess) {
            NSString *token = responseDict[@"token"];
            [JSAccountManager refreshAccountToken:token];
        }
        
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
+ (void)wechatLoginWithAuthCode:(NSString *)code appid:(NSString *)appid complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,wechatLoginPostUrl];
    NSDictionary *param = @{@"code":code,@"wechatAppId":appid};
    
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (isSuccess) {
            NSString *token = responseDict[@"token"];
            [JSAccountManager refreshAccountToken:token];
        }

        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
    
}

+ (void)requestProfileDateWithComplement:(void(^)(BOOL isSuccess,NSDictionary *dataDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,profilePostUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

//消息列表
+ (void)requestMessageListWithType:(NSInteger) type pageNum:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,profileMessageUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"type":@(type),@"pageNum":@(pageNumber)};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)loginOutWithComplement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,loginOutUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

//完善资料查询
+ (void)queryUserInformationWitchComplement:(void(^)(BOOL isSuccess,JSProfileUserModel *userModel))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,userInfoQueryUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            JSProfileUserModel *userInfoModel = nil;
            if (isSuccess) {
                NSError *error = nil;
                userInfoModel = [MTLJSONAdapter modelOfClass:[JSProfileUserModel class] fromJSONDictionary:responseDict error:&error];
            }
            complement(isSuccess,userInfoModel);
        }
    }];
}

+ (void)modifyUserInfoWithDict:(NSDictionary *)dict complement:(void(^)(BOOL isSuccess, NSDictionary*contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,modifyUserInfoUrl];

    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [newDict setValue:[JSAccountManager shareManager].accountToken forKey:@"token"];
    [self POST:url parameters:newDict complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)uploadImage:(UIImage *)image complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complemnt{
    [self upLoadImageWithType:1 image:image complement:complemnt];
}

+ (void)upLoadImageWithType:(NSInteger)type image:(UIImage *)image complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complemnt{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,uploadImageUrl];
    NSDictionary *param = @{@"type":@(type)};
    [self ImagePOST:url parameters:param image:image complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complemnt) {
            complemnt(isSuccess,responseDict);
        }
    }];
}
+ (void)feedbackText:(NSString *)text images:(NSArray *)images complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,feedbackUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"content":text};
    //先没有传图片，以后更新
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.jsshuo.feedback", DISPATCH_QUEUE_CONCURRENT);
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:param];
    if (images.count > 0) {
        for (UIImage *image in images) {
            dispatch_group_enter(group);
            [self upLoadImageWithType:2 image:image complement:^(BOOL isSuccess, NSDictionary *contentDict) {
                if (isSuccess) {
                    NSString *imageUrl = contentDict[@"url"];
                    [imageUrls addObject:imageUrl];
                    dispatch_group_leave(group);
                }else{
                    dispatch_group_leave(group);
                }
            }];
        }
        dispatch_group_notify(group, queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (imageUrls.count > 0) {
                    NSString *strig = [imageUrls componentsJoinedByString:@","];
                    [newParams setValue:strig forKey:@"image"];
                }
                [self POST:url parameters:newParams complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
                    if (complement) {
                        complement(isSuccess,responseDict);
                    }
                }];
            });
        });
        
    }else{
        [self POST:url parameters:newParams complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
            if (complement) {
                complement(isSuccess,responseDict);
            }
        }];
    }
    
    
}

+ (void)queryWithdrawInfoWithComplement:(void(^)(BOOL isSuccess,NSDictionary *dataDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,withdrawUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)getMoneyWithMethod:(NSString *)method count:(NSInteger)amount complement:(void(^)(NSInteger code, NSString *message))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getMoneyUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"method":method,@"amount":@(amount)};
    [[self shareManager] POST:url parameters:[self transformParameters:param] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *state = responseObject[@"code"];
        NSString *messageString = responseObject[@"message"];
        if (complement) {
            complement(state.integerValue,messageString);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complement) {
            complement(99,error.localizedDescription);
        }
    }];
}
@end

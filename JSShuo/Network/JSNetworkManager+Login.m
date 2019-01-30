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
const static NSString *bindWeachtPostUrl = @"/v1/thirdpt/auth/wechat";
const static NSString *bindAlipayPostUrl = @"/v1/user/info/bindAlipay";
const static NSString *bindMobilePostUrl = @"/v1/user/info/bindMobile";
const static NSString *profilePostUrl = @"/v1/user/info/center";
const static NSString *profileMessageUrl = @"/v1/user/message/list";
const static NSString *loginOutUrl = @"/v1/user/logout";
const static NSString *userInfoQueryUrl = @"/v1/user/info/query";
const static NSString *modifyUserInfoUrl = @"/v1/user/info/modify";

const static NSString *feedbackUrl = @"/v1/user/feedback/create";
const static NSString *withdrawUrl = @"/v1/account/withdraw/queryRule";
const static NSString *getMoneyUrl = @"/v1/account/withdraw/apply";
const static NSString *queryAccountUrl = @"/v1/account/query";
const static NSString *accountRunningwaterList = @"/v1/account/detail/list";
const static NSString *exchangerUrl = @"/v1/account/exchange";
const static NSString *rangkListUrl = @"/v1/ranking/list";
const static NSString *addPraiseUrl = @"/v1/user/praise/add";
const static NSString *deletePraiseUrl = @"/v1/user/praise/delete";

const static NSString *addCommentListUrl = @"/v1/user/comment/add";
const static NSString *commentListUrl = @"/v1/user/comment/list";
const static NSString *recvCommentListUrl = @"/v1/user/comment/recv";
const static NSString *clearCommentListUrl = @"/v1/user/comment/clear";
const static NSString *deleateCommentListUrl = @"/v1/user/comment/delete";
const static NSString *addCollectUrl = @"/v1/user/collect/add";
const static NSString *collectListUrl = @"/v1/user/collect/list";
const static NSString *deleateCollectUrl = @"/v1/user/collect/delete";
const static NSString *queryCollectUrl = @"/v1/user/collect/query";
const static NSString *apprenticeListUrl = @"/v1/user/apprentice/list";
const static NSString *messageClearUrl = @"/v1/user/message/clear";
const static NSString *createApprenticeUrl = @"/v1/user/apprentice/create";
const static NSString *shareSuccessUrl = @"/v1/user/share/success";

@implementation JSNetworkManager (Login)

+ (void)requestSecurityCodeWithPhoneNumber:(NSString *)phoneNumber type:(JSRequestSecurityCodeType)type complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getSecurityCodeUrl];
    NSDictionary *param = @{@"mobile":phoneNumber,@"type":@(type)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
//#ifdef DEBUG
//        //测试用
//        NSString *validCode = responseDict[@"validCode"];
//        [self showErrorMessgae:validCode];
//#endif
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

+ (void)bindWechatWithAuthCode:(NSString *)code appid:(NSString *)appid complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,bindWeachtPostUrl];
    NSDictionary *param = @{@"code":code,@"wechatAppId":appid,@"token":[JSAccountManager shareManager].accountToken};
    
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

//绑定支付宝
+ (void)bindAlipayWithAlipayId:(NSString *)alipayId realName:(NSString *)realName complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,bindAlipayPostUrl];
    NSDictionary *param = @{@"alipayId":alipayId,@"realName":realName,@"token":[JSAccountManager shareManager].accountToken};
    
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

//绑定手机号
+ (void)bindMobileWithMobile:(NSString *)mobile validateCode:(NSString *)validateCode complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,bindMobilePostUrl];
    NSDictionary *param = @{@"mobile":mobile,@"validateCode":validateCode,@"token":[JSAccountManager shareManager].accountToken};
    
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
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


+ (void)feedbackText:(NSString *)text images:(NSArray *)images complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,feedbackUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"content":text};
    
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

+ (void)getMoneyWithMethod:(NSString *)method count:(NSInteger)amount realName:(NSString *)realName alipayId:(NSString *)alipayId complement:(void(^)(NSInteger code, NSString *message))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,getMoneyUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"method":method,@"amount":@(amount),@"realName":realName};
    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:param];
    if (alipayId) {
        [newParam setValue:alipayId forKey:@"alipayId"];
    }
    [[self shareManager] POST:url parameters:[self transformParameters:newParam] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (void)queryAccountInfoWithComplement:(void(^)(BOOL isSuccess,JSAccountModel *accountModel))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,queryAccountUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            JSAccountModel *model = nil;
            if (isSuccess) {
                model = [MTLJSONAdapter modelOfClass:[JSAccountModel class] fromJSONDictionary:responseDict error:nil];
            }
            complement(isSuccess,model);
        }
    }];
}

+ (void)queryListWithTypeIndex:(NSInteger)index pageNumber:(NSInteger)pageIndex complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,accountRunningwaterList];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"category":@(index),@"pageNum":@(pageIndex),@"pageSize":@(10)};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)exchangeWithMoney:(NSInteger)money complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,exchangerUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"money":@(money)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)questListWithWeak:(BOOL)isWeak complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complemnt{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,rangkListUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"type":isWeak ? @"1":@"2"};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complemnt) {
            complemnt(isSuccess,responseDict);
        }
    }];
}

+ (void) deletePraiseWithArticleID:(NSInteger)articleId complement:(void(^)(BOOL isSuccess,NSDictionary *contentDic))complement {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,deletePraiseUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"articleId":@(articleId)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
    
}

+ (void) addPraise:(NSDictionary *)params complement:(void(^)(BOOL isSuccess,NSDictionary *contentDic))complement {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,addPraiseUrl];
    [self POST:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
            
        }
    }];
}

+ (void) addComment:(NSDictionary *)params complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,addCommentListUrl];
    [self POST:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
            
        }
    }];
}

//我的评论
+ (void)questCommentListWith:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complemnt{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,commentListUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"pageNum":@(pageNumber),@"pageSize":@(10)};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complemnt) {
            complemnt(isSuccess,responseDict);
        }
    }];
}

//收到的评论
+ (void)questRecvCommentListWith:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complemnt{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,recvCommentListUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"pageNum":@(pageNumber),@"pageSize":@(10)};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complemnt) {
            complemnt(isSuccess,responseDict);
        }
    }];
}

+ (void)clearCommentWithIs:(NSString *)ids Complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,clearCommentListUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"ids":ids};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)deleateCommentWithIs:(NSString *)ids Complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,deleateCommentListUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"ids":ids};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}


+ (void) addCollect:(NSDictionary *)params complement:(void(^)(BOOL isSuccess, NSDictionary *contentDic))complement {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,addCollectUrl];
    [self POST:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}


+ (void)requestCollectListWithType:(NSInteger)type pageNumber:(NSInteger)pageIndex complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,collectListUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"type":@(type),@"pageNum":@(pageIndex),@"pageSize":@(10)};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
+ (void)queryCollectWithArticleId:(NSInteger)collectId complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,queryCollectUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"articleId":@(collectId)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
+ (void)requestDeleateCollectWithArticleId:(NSInteger)collectId complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,deleateCollectUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"articleId":@(collectId)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
    
}

+ (void)requestDeleateCollectWithID:(NSInteger)collectId complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,deleateCollectUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"collectId":@(collectId)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
    
}

+ (void)requestApprenticeListWithPageIndex:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,apprenticeListUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"pageNum":@(pageNumber),@"pageSize":@(10)};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
    
}

+ (void)requestClearMessageType:(NSInteger)type complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,messageClearUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"type":@(type)};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
//createApprenticeUrl

+ (void)requestCreateApprenticeWithInvitateCode:(NSString *)invitate complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,createApprenticeUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"inviteCode":invitate};
    [self POST:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}

+ (void)requestShareSuccessWithUrl:(NSString *)shareUrl complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,shareSuccessUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"url":shareUrl};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess,responseDict);
        }
    }];
}
@end

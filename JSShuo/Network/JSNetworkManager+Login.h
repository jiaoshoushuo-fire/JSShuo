//
//  JSNetworkManager+Login.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"
#import "JSProfileUserModel.h"
#import "JSAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef  NS_ENUM(NSInteger, JSRequestSecurityCodeType){
    JSRequestSecurityCodeTypeRegister = 1,
    JSRequestSecurityCodeTypeLogin,
    JSRequestSecurityCodeTypeResetpassword,
    JSRequestSecurityCodeTypeChangepassword,
    JSRequestSecurityCodeTypeAskteacher,
    JSRequestSecurityCodeTypeBindIPhone
};

@interface JSNetworkManager (Login)

//发验证码
+ (void)requestSecurityCodeWithPhoneNumber:(NSString *)phoneNumber type:(JSRequestSecurityCodeType)type complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

+ (void)loginAccountNumberWithPhoneNumber:(NSString *)phoneNumber securityCode:(NSString *)securityCode complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

+ (void)wechatLoginWithAuthCode:(NSString *)code appid:(NSString *)appid complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

//绑定微信
+ (void)bindWechatWithAuthCode:(NSString *)code appid:(NSString *)appid complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

//绑定支付宝
+ (void)bindAlipayWithAlipayId:(NSString *)alipayId realName:(NSString *)realName complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

//绑定手机号
+ (void)bindMobileWithMobile:(NSString *)mobile validateCode:(NSString *)validateCode complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

+ (void)loginOutWithComplement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

//个人主页
+ (void)requestProfileDateWithComplement:(void(^)(BOOL isSuccess,NSDictionary *dataDict))complement;

//消息列表
+ (void)requestMessageListWithType:(NSInteger) type pageNum:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

//完善资料查询
+ (void)queryUserInformationWitchComplement:(void(^)(BOOL isSuccess,JSProfileUserModel *userModel))complement;

+ (void)modifyUserInfoWithDict:(NSDictionary *)dict complement:(void(^)(BOOL isSuccess, NSDictionary*contenDict))complement;

+ (void)uploadImage:(UIImage *)image complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complemnt;

+ (void)feedbackText:(NSString *)text images:(NSArray *)images complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement;

//查询提现规则
+ (void)queryWithdrawInfoWithComplement:(void(^)(BOOL isSuccess,NSDictionary *dataDict))complement;

//提现
+ (void)getMoneyWithMethod:(NSString *)method count:(NSInteger)amount complement:(void(^)(NSInteger code, NSString *message))complement;

//账户查询
+ (void)queryAccountInfoWithComplement:(void(^)(BOOL isSuccess,JSAccountModel *accountModel))complement;

//账户流水
+ (void)queryListWithTypeIndex:(NSInteger)index pageNumber:(NSInteger)pageIndex complement:(void(^)(BOOL isSuccess,NSDictionary *contenDict))complement;

//兑换
+ (void)exchangeWithMoney:(NSInteger)money complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement;

//排行榜
+ (void)questListWithWeak:(BOOL)isWeak complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complemnt;

// 点赞
+ (void) addPraise:(NSDictionary *)params complement:(void(^)(BOOL isSuccess,NSDictionary *contentDic))complement;

//取消点赞
+ (void) deletePraiseWithArticleID:(NSInteger)articleId complement:(void(^)(BOOL isSuccess,NSDictionary *contentDic))complement ;

//发送评论
+ (void) addComment:(NSDictionary *)params complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;

//我的评论
+ (void)questCommentListWith:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complemnt;

//收到的评论
+ (void)questRecvCommentListWith:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complemnt;

//清空评论
+ (void)clearCommentWithIs:(NSString *)ids Complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement;

//删除评论
+ (void)deleateCommentWithIs:(NSString *)ids Complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement;
// 添加收藏
+ (void) addCollect:(NSDictionary *)params complement:(void(^)(BOOL isSuccess, NSDictionary *contentDic))complement;

//s查询收藏
+ (void)queryCollectWithArticleId:(NSInteger)collectId complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;
//收藏列表
+ (void)requestCollectListWithType:(NSInteger)type pageNumber:(NSInteger)pageIndex complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;

// 删除收藏 -- 根据文章ID
+ (void)requestDeleateCollectWithArticleId:(NSInteger)collectId complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;

//删除收藏
+ (void)requestDeleateCollectWithID:(NSInteger)collectId complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;

//徒弟列表
+ (void)requestApprenticeListWithPageIndex:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;

//清空消息
+ (void)requestClearMessageType:(NSInteger)type complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;

//邀请好友
+ (void)requestCreateApprenticeWithInvitateCode:(NSString *)invitate complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;

//分享成功
+ (void)requestShareSuccessWithUrl:(NSString *)shareUrl complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complement;
@end

NS_ASSUME_NONNULL_END

//
//  JSNetworkManager.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/5.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

//const static NSString *Base_Url = @"http://api.jiaoshoutt.com";
const static NSString *Base_Url = @"http://apitest.jiaoshoutt.com";


@interface JSNetworkManager : NSObject

+ (AFHTTPSessionManager *)shareManager;

+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters complement:(void(^)(BOOL isSuccess,NSDictionary *responseDict))complement;

+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters complement:(void(^)(BOOL isSuccess,NSDictionary *responseDict))complement;

+ (void)showErrorMessgae:(NSString *)message;

+ (void)normalPOST:(NSString *)url parameters:(NSDictionary *)parameters complement:(void(^)(BOOL isSuccess,NSDictionary *responseDict))complement;

+ (void)normalGET:(NSString *)url parameters:(NSDictionary *)parameters complement:(void(^)(BOOL isSuccess,NSDictionary *responseDict))complement;

+ (void)ImagePOST:(NSString *)url parameters:(NSDictionary *)parameters image:(UIImage *)image complement:(void(^)(BOOL isSuccess,NSDictionary *responseDict))complement;

+ (NSDictionary *)transformParameters:(NSDictionary *)parameters;

+ (void)upLoadImageWithType:(NSInteger)type image:(UIImage *)image complement:(void(^)(BOOL isSuccess, NSDictionary *contentDict))complemnt;
@end

NS_ASSUME_NONNULL_END

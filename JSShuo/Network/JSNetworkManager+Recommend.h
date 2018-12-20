//
//  JSNetworkManager+Recommend.h
//  JSShuo
//
//  Created by li que on 2018/11/19.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"
#import "JSRecommendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNetworkManager (Recommend)

+ (void) requestRecommendListWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess,NSArray *modelsArray))complent;


+ (void) requestRewardArticleWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess,NSDictionary *contentDic))complent;

@end

NS_ASSUME_NONNULL_END

//
//  JSNetworkManager+LongVideo.h
//  JSShuo
//
//  Created by li que on 2018/11/6.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNetworkManager (LongVideo)

+ (void) requestLongVideoListWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess,NSNumber *totalPage,NSArray *modelsArray))complent;

+ (void) requestKeywordWihtParmas:(NSDictionary *)params complent:(void(^)(BOOL isSuccess, NSNumber *totalPage, NSArray *modelsArray))complent;

@end

NS_ASSUME_NONNULL_END

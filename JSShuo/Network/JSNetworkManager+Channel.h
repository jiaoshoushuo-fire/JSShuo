//
//  JSNetworkManager+Channel.h
//  JSShuo
//
//  Created by li que on 2018/11/6.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNetworkManager (Channel)

+ (void) requestChannelListWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess,NSDictionary *contentDic))complent;

/** 圈子list **/
+ (void) requestCircleWithChannel:(NSString *)channel pageNum:(NSString *)pageNum complent:(void(^)(BOOL isSuccess,NSArray *contentArray))complent;

@end

NS_ASSUME_NONNULL_END

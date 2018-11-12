//
//  JSNetworkManager+ShortVideo.h
//  JSShuo
//
//  Created by li que on 2018/11/11.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNetworkManager (ShortVideo)

+ (void) requestLongVideoListWithParams:(NSDictionary *)params complent:(void(^)(NSArray *modelsArray))complent;

@end

NS_ASSUME_NONNULL_END

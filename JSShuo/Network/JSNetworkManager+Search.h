//
//  JSNetworkManager+Search.h
//  JSShuo
//
//  Created by li que on 2018/11/16.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNetworkManager (Search)

+ (void) requestHotSearchWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess, NSArray *dicArray))complent;



@end

NS_ASSUME_NONNULL_END

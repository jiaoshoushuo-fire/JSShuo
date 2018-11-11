//
//  JSComputeTime.h
//  JSShuo
//
//  Created by li que on 2018/11/7.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSComputeTime : NSObject

- (NSString *) distanceTimeWithPublistTime:(NSString *)publishTime;

+ (void) distanceTimeWithPublistTime:(NSString *)publishTime complement:(void(^)(NSString *distanceTime))complent;

@end

NS_ASSUME_NONNULL_END

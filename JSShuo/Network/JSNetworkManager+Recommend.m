//
//  JSNetworkManager+Recommend.m
//  JSShuo
//
//  Created by li que on 2018/11/19.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Recommend.h"

const static NSString *recommendList = @"/v1/content/recommend";

@implementation JSNetworkManager (Recommend)

+ (void) requestRecommendListWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess,NSArray *modelsArray))complent {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,recommendList];
    [self GET:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            NSArray *array = [JSRecommendModel modelsWithArray:responseDict[@"list"]];
            complent(isSuccess,array);
        }
    }];
}

@end

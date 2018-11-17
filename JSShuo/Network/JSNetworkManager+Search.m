//
//  JSNetworkManager+Search.m
//  JSShuo
//
//  Created by li que on 2018/11/16.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Search.h"

const static NSString *hotSearch = @"/v1/content/allLookAt";

@implementation JSNetworkManager (Search)

+ (void) requestHotSearchWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess, NSArray *dicArray))complent {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,hotSearch];
    [self GET:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            complent(isSuccess,responseDict);
        }
    }];
}

@end

//
//  JSNetworkManager+LongVideo.m
//  JSShuo
//
//  Created by li que on 2018/11/6.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager+LongVideo.h"
#import "JSLongVideoModel.h"

const static NSString *longVideoList = @"/v1/content/list";
const static NSString *searchResult = @"/v1/content/search";

@implementation JSNetworkManager (LongVideo)

+ (void) requestLongVideoListWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess,NSNumber *totalPage,NSArray *modelsArray))complent {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,longVideoList];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];

    [self GET:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent && isSuccess) {
            NSArray *array = [JSLongVideoModel modelsWithArray:responseDict[@"list"]];
            
            complent(isSuccess,responseDict[@"totalPage"],array);
        } else {
            NSArray *tempArr = [NSArray array];
            complent(isSuccess,@0,tempArr);
        }
    }];
}

+ (void) requestKeywordWihtParmas:(NSDictionary *)params complent:(void(^)(BOOL isSuccess, NSNumber *totalPage, NSArray *modelsArray))complent {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,searchResult];
    [self GET:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent && isSuccess) {
            NSArray *array = [JSLongVideoModel modelsWithArray:responseDict[@"list"]];
            
            complent(true,responseDict[@"totalPage"],array);
        } else {
            NSArray *tempArr = [NSArray array];
            complent(false,@0,tempArr);
        }
    }];
}

@end

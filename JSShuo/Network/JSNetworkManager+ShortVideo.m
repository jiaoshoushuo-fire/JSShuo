//
//  JSNetworkManager+ShortVideo.m
//  JSShuo
//
//  Created by li que on 2018/11/11.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager+ShortVideo.h"
#import "JSShortVideoModel.h"

const static NSString *longVideoList = @"/v1/content/list";

@implementation JSNetworkManager (ShortVideo)

+ (void) requestLongVideoListWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess,NSNumber *totalPage,NSArray *modelsArray))complent {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,longVideoList];
    [self GET:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            NSArray *array = [JSShortVideoModel modelsWithArray:responseDict[@"list"]];
            
            complent(isSuccess,responseDict[@"totalPage"],array);
        } else {
            NSArray *tempArr = [NSArray array];
            complent(isSuccess,@0,tempArr);
        }
    }];
}

@end

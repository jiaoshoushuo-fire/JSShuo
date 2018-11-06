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

@implementation JSNetworkManager (LongVideo)

+ (void) requestLongVideoListWithParams:(NSDictionary *)params complent:(void(^)(NSArray *modelsArray))complent {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,longVideoList];
    [self GET:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            NSArray *array = [JSLongVideoModel modelsWithArray:responseDict[@"list"]];
            
            complent(array);
        }
    }];
}

@end

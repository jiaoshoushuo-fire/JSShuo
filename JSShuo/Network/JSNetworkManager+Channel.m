//
//  JSNetworkManager+Channel.m
//  JSShuo
//
//  Created by li que on 2018/11/6.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Channel.h"
const static NSString *channelList = @"/v1/content/channel/list";

@implementation JSNetworkManager (Channel)

+ (void) requestChannelListWithParams:(NSDictionary *)params complent:(void(^)(NSDictionary *contentDic))complent {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,channelList];
    [self GET:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            complent(responseDict);
        }
    }];
}

@end

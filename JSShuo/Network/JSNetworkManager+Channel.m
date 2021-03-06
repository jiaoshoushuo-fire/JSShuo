//
//  JSNetworkManager+Channel.m
//  JSShuo
//
//  Created by li que on 2018/11/6.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Channel.h"
#import "JSCircleListModel.h"

const static NSString *channelList = @"/v1/content/channel/list";
const static NSString *circleList = @"/v1/poster/list";
const static NSString *circleMy = @"/v1/poster/me";
const static NSString *notlook = @"/v1/content/notlook/article";
const static NSString *shield = @"/v1/content/notlook/author";

@implementation JSNetworkManager (Channel)

+ (void) requestChannelListWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess,NSDictionary *contentDic))complent {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,channelList];
    [self GET:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            complent(isSuccess,responseDict);
        }
    }];
}

+ (void) requestCircleWithChannel:(NSString *)channel pageNum:(NSString *)pageNum complent:(void(^)(BOOL isSuccess,NSArray *contentArray))complent {
    NSString *token = [JSAccountManager shareManager].accountToken;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (token) {
        [params setObject:token forKey:@"token"];
    }
    [params setObject:channel forKey:@"channel"];
    [params setObject:pageNum forKey:@"pageNum"];
    [params setObject:@"10" forKey:@"pageSize"];
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,circleList];
    [self POST:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            NSArray *array = [JSCircleListModel modelsWithArray:responseDict[@"list"]];
            complent(isSuccess,array);
        }
    }];
}

+ (void) requestCircleWithMyPageNum:(NSString *)pageNum complent:(void(^)(BOOL isSuccess,NSArray *contentArray))complent {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *token = [JSAccountManager shareManager].accountToken;
    if (token) {
        [params setObject:token forKey:@"token"];
    }
    [params setObject:pageNum forKey:@"pageNum"];
    [params setObject:@"10" forKey:@"pageSize"];
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,circleMy];
    [self POST:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            NSArray *array = [JSCircleListModel modelsWithArray:responseDict[@"list"]];
            complent(isSuccess,array);
        }
    }];
}

+ (void) requestNotlookArticle:(NSString *)atricleID complement:(void(^)(BOOL isSuccess))complement {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,notlook];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
    NSDictionary *params = @{@"token":token,@"articleId":atricleID};
    [self POST:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess);
        }
    }];
}

+ (void) requestShieldAuthor:(NSString *)authorName complement:(void(^)(BOOL isSuccess))complement {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,shield];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
    NSDictionary *params = @{@"token":token,@"author":authorName};
    [self POST:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complement) {
            complement(isSuccess);
        }
    }];
}

@end

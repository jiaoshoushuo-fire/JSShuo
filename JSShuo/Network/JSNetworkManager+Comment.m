//
//  JSNetworkManager+Comment.m
//  JSShuo
//
//  Created by li que on 2018/11/18.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Comment.h"

const static NSString *commentList = @"/v1/content/commentList";

@implementation JSNetworkManager (Comment)

+ (void) requestCommentListWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess, NSNumber *totalPage,NSArray *modelsArray))complent  {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,commentList];
    [self GET:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            NSArray *array = [JSCommentListModel modelsWithArray:responseDict[@"list"]];
            complent(isSuccess, responseDict[@"totalPage"],array);
        }
    }];
    
}

@end

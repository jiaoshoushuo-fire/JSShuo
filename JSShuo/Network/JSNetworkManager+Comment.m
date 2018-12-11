//
//  JSNetworkManager+Comment.m
//  JSShuo
//
//  Created by li que on 2018/11/18.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Comment.h"
#import "JSAccountManager.h"
#import "JSCommentView.h"

const static NSString *commentList = @"/v1/content/commentList";
const static NSString *detail = @"/v1/content/detail";

@implementation JSNetworkManager (Comment)

+ (void)requestVideoCommentDataWithArticleId:(NSInteger )articleId pageNumber:(NSInteger)pageNumber complement:(void(^)(BOOL isSuccess,NSArray *commentList,NSInteger totolNumber))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,commentList];
    NSDictionary *dict = @{@"articleId":@(articleId),@"pageNum":@(pageNumber),@"pageSize":@(10)};
    [self GET:url parameters:dict complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (isSuccess) {
            
            NSArray *listArray = responseDict[@"list"];
            NSInteger totolNumber = [responseDict[@"total"] integerValue];
            NSError *error = nil;
            NSArray *modelList = [MTLJSONAdapter modelsOfClass:[JSCommentModel class] fromJSONArray:listArray error:&error];
            
            if (complement) {
                complement(isSuccess,modelList,totolNumber);
            }
        }
    }];
    
}

+ (void) requestCommentListWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess, NSNumber *totalPage,NSArray *modelsArray))complent  {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,commentList];
    [self GET:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            NSArray *array = [JSCommentListModel modelsWithArray:responseDict[@"list"]];
            complent(isSuccess, responseDict[@"totalPage"],array);
        }
    }];
}

+ (void) requestDetailWithArticleID:(NSInteger)articleId complent:(void(^)(BOOL isSuccess,NSDictionary *contentDic))complent {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,detail];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"articleId":@(articleId)};
    [self GET:url parameters:param complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (complent) {
            complent(isSuccess,responseDict);
        }
    }];
}

@end

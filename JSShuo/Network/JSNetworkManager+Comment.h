//
//  JSNetworkManager+Comment.h
//  JSShuo
//
//  Created by li que on 2018/11/18.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"
#import "JSCommentListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNetworkManager (Comment)

+ (void) requestCommentListWithParams:(NSDictionary *)params complent:(void(^)(BOOL isSuccess, NSNumber *totalPage,NSArray *modelsArray))complent ;

@end

NS_ASSUME_NONNULL_END
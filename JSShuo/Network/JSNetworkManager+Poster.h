//
//  JSNetworkManager+Poster.h
//  JSShuo
//
//  Created by  乔中祥 on 2019/1/29.
//  Copyright © 2019年  乔中祥. All rights reserved.
//

#import "JSNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNetworkManager (Poster)

+ (void)postPublishTitle:(NSString *)title text:(NSString *)text images:(NSArray *)images complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement;

+ (void) deleteCircleWithID:(NSString *)ID complement:(void(^)(BOOL isSuccess,NSDictionary *contentDic ))complement;

@end

NS_ASSUME_NONNULL_END

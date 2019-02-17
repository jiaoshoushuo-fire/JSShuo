//
//  JSNetworkManager+Poster.m
//  JSShuo
//
//  Created by  乔中祥 on 2019/1/29.
//  Copyright © 2019年  乔中祥. All rights reserved.
//

#import "JSNetworkManager+Poster.h"

const static NSString *postPublishUrl = @"/v1/poster/publish";
const static NSString *deletePublishUrl = @"/v1/poster/delete";

@implementation JSNetworkManager (Poster)


+ (void)postPublishTitle:(NSString *)title text:(NSString *)text images:(NSArray *)images complement:(void(^)(BOOL isSuccess,NSDictionary *contentDict))complement{
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,postPublishUrl];
    NSDictionary *param = @{@"token":[JSAccountManager shareManager].accountToken,@"body":[text stringByURLEncode]};
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.jsshuo.postpublish", DISPATCH_QUEUE_CONCURRENT);
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:param];
   
    if (title.length > 0) {
        [newParams setValue:[title stringByURLEncode] forKey:@"title"];
    }
    
    if (images.count > 0) {
        for (UIImage *image in images) {
            dispatch_group_enter(group);
            [self upLoadImageWithType:3 image:image complement:^(BOOL isSuccess, NSDictionary *contentDict) {
                if (isSuccess) {
                    NSString *imageUrl = contentDict[@"url"];
                    [imageUrls addObject:imageUrl];
                    dispatch_group_leave(group);
                }else{
                    dispatch_group_leave(group);
                }
            }];
        }
        dispatch_group_notify(group, queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (imageUrls.count > 0) {
                    NSString *strig = [imageUrls componentsJoinedByString:@","];
                    [newParams setValue:strig forKey:@"images"];
                }
                [self POST:url parameters:newParams complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
                    if (complement) {
                        complement(isSuccess,responseDict);
                    }
                }];
            });
        });
        
    }else{
        [self POST:url parameters:newParams complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
            if (complement) {
                complement(isSuccess,responseDict);
            }
        }];
    }
    
    
}

+ (void) deleteCircleWithID:(NSString *)ID complement:(void(^)(BOOL isSuccess,NSDictionary *contentDic ))complement {
    NSString *url = [NSString stringWithFormat:@"%@%@",Base_Url,deletePublishUrl];
    NSDictionary *params = @{@"token":[JSAccountManager shareManager].accountToken,
                             @"posterId":ID
                             };
    [self POST:url parameters:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull responseDict) {
        if (isSuccess) {
            complement(isSuccess,responseDict);
        }
    }];
}

@end

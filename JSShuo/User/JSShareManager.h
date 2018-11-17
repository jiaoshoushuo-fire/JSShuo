//
//  JSShareManager.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/17.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSShareManager : NSObject

+ (instancetype)shareManager;

+(void)shareWithTitle:(NSString *)title Text:(NSString *)shareText Image:(UIImage *)shareImage Url:(NSString *)url complement:(void(^)(BOOL isSuccess))complement;
@end

NS_ASSUME_NONNULL_END

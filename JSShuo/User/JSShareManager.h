//
//  JSShareManager.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/17.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>
//http://api.jiaoshoutt.com/v1/page/invite

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,JSShareManagerType){
    JSShareManagerTypeQQWeChat,
    JSShareManagerTypeFour
};

@interface JSShareManager : NSObject

+ (instancetype)shareManager;

//正常分享Url
+(void)shareWithTitle:(NSString *)title Text:(NSString *)shareText Image:(UIImage *)shareImage Url:(NSString *)url complement:(void(^)(BOOL isSuccess))complement;

//有 qq 图片的 分享，懒得拆开了
+(void)shareWithTitle:(NSString *)title Text:(NSString *)shareText Image:(UIImage *)shareImage Url:(NSString *)url  QQImageURL:(NSString *)qqImageUrl shareType:(JSShareManagerType)shareType complement:(void(^)(BOOL isSuccess))complement;
@end

NS_ASSUME_NONNULL_END

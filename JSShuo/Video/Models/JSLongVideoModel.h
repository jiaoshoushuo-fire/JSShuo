//
//  JSLongVideoModel.h
//  JSShuo
//
//  Created by li que on 2018/11/5.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSLongVideoModel : NSObject

/** 文章ID */
@property (nonatomic,strong) NSNumber *articleId;
/** 封面图 */
@property (nonatomic,strong) NSArray *cover;
/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 展现形式 */
@property (nonatomic,copy) NSString *showType;
/** 描述 */
@property (nonatomic,copy) NSString *Description;
/** 来源 */
@property (nonatomic,copy) NSString *origin;
/** 作者 */
@property (nonatomic,copy) NSString *author;
/** 视频播放地址 */
@property (nonatomic,copy) NSString *videoUrl;
/** 时长 */
@property (nonatomic,strong) NSNumber *duration;
/**  */
@property (nonatomic,copy) NSString *bgSound;
/** 市场 */
@property (nonatomic,strong) NSNumber *mediaType;
/** 是否置顶 */
@property (nonatomic,strong) NSNumber *isTop;
/** 评论数 */
@property (nonatomic,strong) NSNumber *commentNum;

@property (nonatomic,strong) NSNumber *collectNum;

/** 点赞数 */
@property (nonatomic,strong) NSNumber *praiseNum;
/** 类型：文章、视频、短视频 **/
@property (nonatomic,strong) NSNumber *type;
/** 发布距离时间 */
@property (nonatomic,strong) NSString *publishTime;
/** 发布的时间戳 **/
@property (nonatomic,strong) NSString *publishTimeDesc;

+ (JSLongVideoModel *) modelWithDictionary:(NSDictionary *)dic;
+ (NSArray *) modelsWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END

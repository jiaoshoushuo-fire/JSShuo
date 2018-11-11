//
//  JSShortVideoModel.h
//  JSShuo
//
//  Created by li que on 2018/11/5.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSShortVideoModel : NSObject

/** 文章ID */
@property (nonatomic,strong) NSNumber *articleId;
/** 作者 */
@property (nonatomic,copy) NSString *author;
/**  */
@property (nonatomic,copy) NSString *bgSound;
/** 评论数 */
@property (nonatomic,strong) NSNumber *commentNum;
/** 封面图 */
@property (nonatomic,strong) NSArray *cover;
/** 描述 */
@property (nonatomic,copy) NSString *Description;
/** 时长 */
@property (nonatomic,strong) NSNumber *duration;
/** 是否置顶 */
@property (nonatomic,strong) NSNumber *isTop;
/** 视频类型 */
@property (nonatomic,strong) NSNumber *mediaType;
/** 来源 */
@property (nonatomic,copy) NSString *origin;
/** 点赞数 */
@property (nonatomic,strong) NSNumber *praiseNum;
/** 发布距离时间 */
@property (nonatomic,strong) NSString *publishTime;
/** 展现形式 */
@property (nonatomic,copy) NSString *showType;
/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 视频播放地址 */
@property (nonatomic,copy) NSString *videoUrl;

+ (JSShortVideoModel *) modelWithDictionary:(NSDictionary *)dic;
+ (NSArray *) modelsWithArray:(NSArray *)array;


@end

NS_ASSUME_NONNULL_END

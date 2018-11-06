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
/** 标题 */
@property (nonatomic,strong) NSString *title;
/** 视频图片的播放 */
@property (nonatomic,strong) NSString *imgURL;
/** 来源 */
@property (nonatomic,strong) NSString *source;
/** 发布距离时间 */
@property (nonatomic,strong) NSString *releaseTime;
/** 视频的时长 */
@property (nonatomic,strong) NSString *videoTime;
/** 评论数 */
@property (nonatomic,strong) NSNumber *praiseCount;
/** 评论数 */
@property (nonatomic,strong) NSNumber *commitCount;
/** 是否置顶 */
@property (nonatomic,assign) BOOL isHot;

+ (JSLongVideoModel *) modelWithDictionary:(NSDictionary *)dic;
+ (NSArray *) modelsWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END

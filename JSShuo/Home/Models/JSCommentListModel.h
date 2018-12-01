//
//  JSCommentListModel.h
//  JSShuo
//
//  Created by li que on 2018/11/18.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSCommentListModel : NSObject

@property (nonatomic,strong) NSNumber *articleId;
@property (nonatomic,strong) NSNumber *commentId;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,strong) NSNumber *level;
@property (nonatomic,copy) NSString *nickname;
/** 默认头像 */
@property (nonatomic,copy) NSString *portrait;
@property (nonatomic,strong) NSNumber *replyCommentId;
@property (nonatomic,strong) NSArray *replyList;
@property (nonatomic,copy) NSString *replyNickname;
@property (nonatomic,strong) NSNumber *replyUserId;
@property (nonatomic,strong) NSNumber *userId;

+ (JSCommentListModel *) modelWithDictionary:(NSDictionary *)dic;
+ (NSArray *) modelsWithArray:(NSArray *)array;

- (CGFloat) getReplayHeight:(JSCommentListModel *)model;

@end

NS_ASSUME_NONNULL_END

//
//  JSCommentView.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/12/10.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTLModel.h"
#import "JSShortVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, GGPVDirection) {
    JSPVDirectionNone,
    JSPVDirectionUp,
    JSPVDirectionDown,
    JSPVDirectionLeft,
    JSPVDirectionRight
};


@interface JSCommentModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign)NSInteger articleId;
@property (nonatomic, assign)NSInteger commentId;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, assign)NSInteger level;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *portrait;
@property (nonatomic, assign)NSInteger replyCommentId;
@property (nonatomic, strong)NSArray <JSCommentModel *>*replyList;
@property (nonatomic, copy)NSString *replyNickname;
@property (nonatomic, assign)NSInteger replyUserId;
@property (nonatomic, assign)NSInteger userId;
@end

@interface JSCommentView : UIView

+ (void)showCommentViewWithSuperView:(UIView *)superView authModel:(JSShortVideoModel *)model;

@end

NS_ASSUME_NONNULL_END

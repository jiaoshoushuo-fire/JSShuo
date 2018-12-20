//
//  JSMyCommentCell.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/19.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSMyCommentModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign)NSInteger commentId;
@property (nonatomic, assign)NSInteger userId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *portrait;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)NSInteger articleId;
@end

@class JSMyCommentModel;
@protocol JSMyCommentCellDelegate <NSObject>

- (void)didSelectedDeleateButton:(JSMyCommentModel *)model;

@end

@interface JSMyCommentCell : UITableViewCell

@property (nonatomic, strong)JSMyCommentModel *model;
@property (nonatomic, weak)id<JSMyCommentCellDelegate>delegate;

+ (CGFloat)heightForRowWithModel:(JSMyCommentModel *)model;
@end

NS_ASSUME_NONNULL_END

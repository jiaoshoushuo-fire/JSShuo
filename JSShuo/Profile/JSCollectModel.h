//
//  JSCollectModel.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/19.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "MTLModel.h"

NS_ASSUME_NONNULL_BEGIN

//"videoUrl":"视频地址",
//"createTime":"2018-07-23 12:22:22",
//"publishTime":"2018-07-23 12:22:22"

@class JSCollectModel;
@protocol JSMyCollectArticleCellDelegate <NSObject>

- (void)didSelectedDeleateButton:(JSCollectModel *)model;

@end


@interface JSCollectModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign)NSInteger collectId;
@property (nonatomic, assign)NSInteger userId;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *channel;
@property (nonatomic, copy)NSString *videoUrl;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *publishTime;
@end

NS_ASSUME_NONNULL_END

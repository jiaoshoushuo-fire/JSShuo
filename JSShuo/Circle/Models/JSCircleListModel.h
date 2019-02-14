//
//  JSCircleListModel.h
//  JSShuo
//
//  Created by li que on 2019/1/30.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCircleListModel : NSObject

@property (nonatomic,strong) NSNumber *articleId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,strong) NSNumber *authorId;
@property (nonatomic,assign) NSNumber *mediaType;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,strong) NSNumber *isTop;
@property (nonatomic,strong) NSNumber *isDelete;
@property (nonatomic,strong) NSNumber *commentNum;
@property (nonatomic,strong) NSNumber *collectNum;
@property (nonatomic,strong) NSNumber *praiseNum;
@property (nonatomic,strong) NSNumber *imageType;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,copy) NSString *portrait;
@property (nonatomic,strong) NSNumber *auditStatus;
@property (nonatomic,copy) NSString *auditStatusDesc;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic,copy) NSString *createTimeDesc;
@property (nonatomic,copy) NSString *Description;

+ (JSCircleListModel *) modelWithDictionary:(NSDictionary *)dic;
+ (NSArray *) modelsWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END

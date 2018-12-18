//
//  JSRecommendModel.h
//  JSShuo
//
//  Created by li que on 2018/11/19.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSRecommendModel : NSObject

@property (nonatomic,strong) NSNumber *articleId;
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *bgSound;
@property (nonatomic,strong) NSNumber *commentNum;
@property (nonatomic,strong) NSArray *cover;
@property (nonatomic,copy) NSString *Description;
@property (nonatomic,strong) NSNumber *duration;
@property (nonatomic,strong) NSNumber *isTop;
@property (nonatomic,strong) NSNumber *mediaType;
@property (nonatomic,copy) NSString *origin;
@property (nonatomic,strong) NSNumber *praiseNum;
@property (nonatomic,copy) NSString *publishTime;
@property (nonatomic,strong) NSNumber *showType;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic,copy) NSString *publishTimeDesc;

+ (JSRecommendModel *) modelWithDictionary:(NSDictionary *)dic;
+ (NSArray *) modelsWithArray:(NSArray *)array;


@end

NS_ASSUME_NONNULL_END

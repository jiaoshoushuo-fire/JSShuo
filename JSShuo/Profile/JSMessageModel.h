//
//  JSMessageModel.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "MTLModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface JSMessageModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy)NSString *userMessageId;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)BOOL isRead;
@end

@interface JSMessageListModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong)NSArray <JSMessageModel *>*list;
@property (nonatomic, assign)NSInteger totalPage;
@end


NS_ASSUME_NONNULL_END

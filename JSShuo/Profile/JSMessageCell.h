//
//  JSMessageCell.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMessageCell : UITableViewCell

@property (nonatomic, strong)JSMessageModel *messageModel;

+ (CGFloat)heightWithModel:(JSMessageModel *)model;
@end

NS_ASSUME_NONNULL_END

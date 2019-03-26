//
//  JSCircleRootCell.h
//  JSShuo
//
//  Created by  乔中祥 on 2019/3/25.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCircleListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCircleRootCell : UITableViewCell

@property (nonatomic,strong) JSCircleListModel *model;

@property (nonatomic,copy) void (^noInterestBlock)(void);
@property (nonatomic,copy) void (^shieldAuthor)(void);


@end

NS_ASSUME_NONNULL_END

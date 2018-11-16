//
//  JSMyWalletCell.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/16.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JSDealModel;
@interface JSMyWalletCell : UITableViewCell

@property (nonatomic, strong)JSDealModel *dealModel;

- (void)configDealModel:(JSDealModel *)model withType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END

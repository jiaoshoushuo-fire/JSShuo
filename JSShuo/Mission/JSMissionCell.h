//
//  JSMissionCell.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/22.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMissionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMissionSubCell : UITableViewCell
@property (nonatomic, copy)NSString *subText;

+ (CGFloat)heightForString:(NSString *)text;
@end

@interface JSMissionCell : UITableViewCell
@property (nonatomic, strong)JSMissionModel *model;

@property (nonatomic, assign)BOOL isOpen;
@end

NS_ASSUME_NONNULL_END

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

@protocol JSMissionSubCellDelegate <NSObject>

- (void)didSelectedGoFinishedCellWithModel:(JSMissSubModel *)subModel;

@end

@interface JSMissionSubCell : UITableViewCell
//@property (nonatomic, copy)NSString *subText;
@property (nonatomic, strong)JSMissSubModel *subModel;
@property (nonatomic, weak)id<JSMissionSubCellDelegate>delegate;

+ (CGFloat)heightForString:(NSString *)text;
@end

@interface JSMissionCell : UITableViewCell
@property (nonatomic, strong)JSMissionModel *model;

@property (nonatomic, assign)BOOL isOpen;
@end

NS_ASSUME_NONNULL_END

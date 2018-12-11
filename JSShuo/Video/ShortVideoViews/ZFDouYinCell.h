//
//  ZFDouYinCell.h
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSShortVideoModel.h"

@protocol ZFDouYinCellDelegate <NSObject>

- (void)didSelectedLikeButtonWithModel:(JSShortVideoModel *)model;
- (void)didSelectedShareButtonWithModel:(JSShortVideoModel *)model;
- (void)didSelectedCommentButtonWithModel:(JSShortVideoModel *)model;


@end

@interface ZFDouYinCell : UITableViewCell 

@property (nonatomic, strong) JSShortVideoModel *data;
@property (nonatomic, weak)id<ZFDouYinCellDelegate>delegate;

@end

//
//  JSActivityCell.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/28.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSActivityCenterModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign)NSInteger activityId;
@property (nonatomic, copy)NSString *image;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *url;

@end


@interface JSActivityCell : UICollectionViewCell
@property (nonatomic, strong)JSActivityCenterModel *model;
@end

NS_ASSUME_NONNULL_END

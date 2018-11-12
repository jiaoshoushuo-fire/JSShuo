//
//  JSPerfectUserInfoCell.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/9.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSPerfectUserInfoCellModel : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subTitle;
@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, assign)BOOL isHasAccessory;
@end



@interface JSPerfectUserInfoCell : UITableViewCell
@property (nonatomic, strong)JSPerfectUserInfoCellModel *model;

@property (nonatomic, strong)UIImage *avaterIconImage;
@end

NS_ASSUME_NONNULL_END

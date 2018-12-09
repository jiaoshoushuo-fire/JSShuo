//
//  JSMyApprenticeViewController.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/20.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseViewController.h"
#import "JSCollectModel.h"

typedef NS_ENUM(NSInteger,JSMyApprenticeCellType){
    JSMyApprenticeCellTypeWeakUpList,
    JSMyApprenticeCellTypeNormalList
};

NS_ASSUME_NONNULL_BEGIN

@protocol JSMyApprenticeCellDelegate <NSObject>

- (void)didSelectedWeakupButton:(JSApprentModel *)model;

@end


@interface JSMyApprenticeCell : UITableViewCell
@property (nonatomic, strong)UIImageView *iconImage;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIButton *weakupButton;
@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)JSApprentModel *model;

@property (nonatomic, weak)id<JSMyApprenticeCellDelegate>delegate;
@end



@interface JSMyApprenticeViewController : JSBaseViewController

@property (nonatomic, assign)JSMyApprenticeCellType celltype;
@end

NS_ASSUME_NONNULL_END

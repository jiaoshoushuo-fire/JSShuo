//
//  JSLoginViewController.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/2.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseViewController.h"

@protocol JSLoginViewControllerDelegate <NSObject>

- (void)didSelectedPageControllerWithIndex:(int)index;
- (void)didLoginSuccessComplement;

@end

@interface JSLoginBottomView : UIView

@property (nonatomic, strong)UIView *otherPlatformLeftLine;
@property (nonatomic, strong)UILabel *otherPlatfomTitle;
@property (nonatomic, strong)UIView *otherPlanformRightLine;

@property (nonatomic, strong)UIButton *wechatLoginButton;

@end


NS_ASSUME_NONNULL_BEGIN

@interface JSLoginViewController : JSBaseViewController

@property (nonatomic,weak)id <JSLoginViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

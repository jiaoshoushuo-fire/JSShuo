//
//  JSNavSearchView.h
//  JSShuo
//
//  Created by li que on 2018/11/4.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSNavSearchView : UIView

@property (nonatomic,strong) UIButton       *headButton;
@property (nonatomic,strong) UIButton       *redPocketButton;
@property (nonatomic,strong) UIView         *searchRectangle;

- (void) updateHeaderImage;

@end

NS_ASSUME_NONNULL_END

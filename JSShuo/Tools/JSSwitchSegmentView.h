//
//  JSSwitchSegmentView.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AKASegmentedControl.h>
#import "JSAdjustButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSSwitchSegmentView : UIView

@property (nonatomic, strong) JSAdjustButton *optionButtonRight;
@property (nonatomic, strong) JSAdjustButton *optionButtonLeft;
@property (nonatomic, strong) AKASegmentedControl *segmentControl;
@property (nonatomic, strong) CALayer *indicatorBar;

@property (nonatomic, copy) void (^selectedIndexChangedHandler)(NSUInteger index);
@property (nonatomic, readonly) NSUInteger selectedIndex;
- (void)setSelectedIndex:(NSUInteger)index;


@end

NS_ASSUME_NONNULL_END

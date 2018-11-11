//
//  JSSwitchSegmentView.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSSwitchSegmentView.h"
#import "UIImage+Extension.h"

@implementation JSSwitchSegmentView

- (CALayer *)indicatorBar {
    if (_indicatorBar == nil) {
        _indicatorBar = [[CALayer alloc] init];
        _indicatorBar.frame = CGRectMake(0, self.height - 2, self.width * 0.5, 2);
        _indicatorBar.backgroundColor = [UIColor colorWithHexString:@"F44336"].CGColor;
    }
    return _indicatorBar;
}
- (JSAdjustButton *)optionButtonRight {
    if (!_optionButtonRight) {
        _optionButtonRight = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        _optionButtonRight.frame = CGRectMake(0, 0, _segmentControl.width/2, _segmentControl.height - 2);
        _optionButtonRight.position = JSImagePositionLeft;
        _optionButtonRight.itemSpace = 7;
        [_optionButtonRight setImage:[UIImage imageNamed:@"js_profile_no_selected"] forState:UIControlStateNormal];
        [_optionButtonRight setImage:[UIImage imageNamed:@"js_profile_no_selected"] forState:UIControlStateSelected];
        _optionButtonRight.titleLabel.font = [UIFont systemFontOfSize:15];
        [_optionButtonRight setTitleColor:[UIColor colorWithHexString:@"F44336"] forState:UIControlStateSelected];
        [_optionButtonRight setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    }
    return _optionButtonRight;
}

- (JSAdjustButton *)optionButtonLeft {
    if (!_optionButtonLeft) {
        _optionButtonLeft = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        _optionButtonLeft.frame = CGRectMake(_segmentControl.width/2, 0, _segmentControl.width/2, _segmentControl.height - 2);
        _optionButtonLeft.position = JSImagePositionLeft;
        _optionButtonLeft.itemSpace = 7;
        [_optionButtonLeft setImage:[UIImage imageNamed:@"js_profile_message_selected"] forState:UIControlStateNormal];
        [_optionButtonLeft setImage:[UIImage imageNamed:@"js_profile_message_selected"] forState:UIControlStateSelected];
        _optionButtonLeft.titleLabel.font = [UIFont systemFontOfSize:15];
        [_optionButtonLeft setTitleColor:[UIColor colorWithHexString:@"F44336"] forState:UIControlStateSelected];
        [_optionButtonLeft setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    }
    return _optionButtonLeft;
}

- (AKASegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[AKASegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-2)];
//        _segmentControl.separatorImage = [UIImage imageFromColor:[UIColor lightGrayColor] size:CGSizeMake(0.5, 30)];
        _segmentControl.center = self.center;
    }
    return _segmentControl;
}

- (NSUInteger)selectedIndex {
    return [self.segmentControl.selectedIndexes firstIndex];
}

- (void)setSelectedIndex:(NSUInteger)index {
    [self.segmentControl setSelectedIndex:index];
    [self updateIndicatorBarPosition];
}

- (void)updateIndicatorBarPosition {
    NSUInteger selectedIndex = [self.segmentControl.selectedIndexes firstIndex];
    
    CGFloat centerX = 0.f;
    if (selectedIndex == 1) {
        centerX = self.optionButtonRight.centerX;
    } else if (selectedIndex == 0) {
        centerX = self.optionButtonLeft.centerX;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorBar.centerX = centerX;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.segmentControl.buttonsArray = @[self.optionButtonLeft, self.optionButtonRight];
        [self addSubview:self.segmentControl];
        [self.segmentControl setSelectedIndex:0];
        [self updateIndicatorBarPosition];
        
        [self.layer addSublayer:self.indicatorBar];
        self.indicatorBar.centerX = self.width/4.0f;
        
        @weakify(self)
        [self.segmentControl bk_addEventHandler:^(id sender) {
            @strongify(self)
            
            [self updateIndicatorBarPosition];
            if (self.selectedIndexChangedHandler) {
                self.selectedIndexChangedHandler([self.segmentControl.selectedIndexes firstIndex]);
            }
        } forControlEvents:UIControlEventValueChanged];
    }
    return self;
}


@end

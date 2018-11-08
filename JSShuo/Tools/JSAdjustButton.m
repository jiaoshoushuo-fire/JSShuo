//
//  JSAdjustButton.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAdjustButton.h"

@implementation JSAdjustButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    switch (self.position) {
        case JSImagePositionRight: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.width + self.itemSpace, 0, - self.titleLabel.width - self.itemSpace);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.width, 0, self.imageView.width);
            break;
        }
        case JSImagePositionLeft: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -self.itemSpace/2.0, 0, self.itemSpace/2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, self.itemSpace/2.0, 0, -self.itemSpace/2.0);
            break;
        }
        case JSImagePositionBottom: {
            self.imageEdgeInsets = UIEdgeInsetsMake(self.titleLabel.height + self.itemSpace,0, - self.titleLabel.height - self.itemSpace, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.height,0, self.titleLabel.height + 5, 0);
            break;
        }
        case JSImagePositionUp: {
            self.imageEdgeInsets = UIEdgeInsetsMake(- self.titleLabel.height + self.itemSpace,0, self.titleLabel.height + self.itemSpace, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(self.titleLabel.height,0, -self.titleLabel.height, 0);
            break;
        }
        default:
            break;
    }
}

@end

//
//  JSCommentTableView.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/12/10.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSCommentTableView.h"

@implementation JSCommentTableView

//手指触碰屏幕，触摸开始
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//}
//
////手指在屏幕上移动
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
//    [self touchesMoved:touches withEvent:event];
//}
////手指离开屏幕，触摸结束
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
//    [self touchesEnded:touches withEvent:event];
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];

    for (UITouch *touch in event.allTouches) {
        NSLog(@"------ %@---",touch.gestureRecognizers);
    }

    
    return view;
}

@end

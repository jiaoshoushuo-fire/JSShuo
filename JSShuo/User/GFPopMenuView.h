//
//  GFPopMenuView.h
//  GetFun
//
//  Created by liupeng on 16/4/9.
//  Copyright © 2016年 17GetFun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFPopMenuView;
@protocol GFPopMenuViewDelegate <NSObject>
- (void)popMenu:(GFPopMenuView *)popMenu clickItemAtIndex:(NSUInteger)itemIndex;
@end

@interface GFPopMenuView : UIView

@property (nonatomic, weak) id<GFPopMenuViewDelegate> delegate;
@property (nonatomic, assign) CGPoint menuButtonCenter; //menuButton在当前view中的中心位置

+ (void)showInView:(UIView *)view delegate:(id<GFPopMenuViewDelegate>)delegate;

@end

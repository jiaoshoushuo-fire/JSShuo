//
//  JSBottomPopSendCommentView.h
//  JSShuo
//
//  Created by li que on 2018/11/27.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSBottomPopSendCommentView : UIView

@property (nonatomic,strong) UITextView *textView;

- (void) appearView;

- (void) dismissView;

@end

NS_ASSUME_NONNULL_END

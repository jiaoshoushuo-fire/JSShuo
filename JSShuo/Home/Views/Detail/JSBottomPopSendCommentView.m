//
//  JSBottomPopSendCommentView.m
//  JSShuo
//
//  Created by li que on 2018/11/27.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSBottomPopSendCommentView.h"

@interface PopBottomView : UIView
@property (nonatomic,strong) UIButton *cancleBtn;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) UITextView *textView;
@end

@implementation PopBottomView

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [UIColor grayColor];
        _sendBtn.layer.cornerRadius = 5;
    }
    return _sendBtn;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _cancleBtn.layer.cornerRadius = 5;
    }
    return _cancleBtn;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor yellowColor];
        //设置placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请文明发言，遵守评论规则。";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        [_textView addSubview:placeHolderLabel];
        _textView.font = [UIFont systemFontOfSize:13.f];
        placeHolderLabel.font = [UIFont systemFontOfSize:13.f];
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _textView;
}

@end



@interface JSBottomPopSendCommentView()
@property (nonatomic,strong) UIView *deliverView; // 底部的view
@property (nonatomic,strong) UIView *BGView; // 遮罩view
@end


@implementation JSBottomPopSendCommentView

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void) appearView {
    self.BGView = [[UIView alloc] init];
    self.BGView.frame = [[UIScreen mainScreen] bounds];
    self.BGView.tag = 100;
    self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.BGView.opaque = NO;
    
    //--UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self.BGView];
    
    
    // ------给全屏遮罩添加的点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [self.BGView addGestureRecognizer:gesture];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];
    
    // ------底部弹出的View
    self.deliverView                 = [[UIView alloc] init];
    self.deliverView.backgroundColor = [UIColor whiteColor];
    [appWindow addSubview:self.deliverView];
    
    
    self.textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor yellowColor];
    //设置placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请文明发言，遵守评论规则。";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [_textView addSubview:placeHolderLabel];
    _textView.font = [UIFont systemFontOfSize:13.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:13.f];
    [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    [self.deliverView addSubview:self.textView];
    
    // ------View出现动画
    self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, ScreenHeight);
    [UIView animateWithDuration:0.3 animations:^{
        self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.textView becomeFirstResponder];
    
    self.BGView.alpha = 1.0;
    self.textView.alpha = 1.0;
    self.deliverView.alpha = 1.0;
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    NSLog(@"height----:%d",height);
    
    self.deliverView.frame = CGRectMake(0, ScreenHeight-80-height, ScreenWidth, 80+height);
    self.textView.frame = CGRectMake(0, 0, ScreenWidth, 80);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    NSLog(@"keyboardWillHide");
}

- (void) dismissView {
    [UIView animateWithDuration:0.3 animations:^{
        self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, ScreenHeight);
        self.deliverView.alpha = 0.2;
        self.BGView.alpha = 0;
        self.textView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.textView removeFromSuperview];
        [self.BGView removeFromSuperview];
        [self.deliverView removeFromSuperview];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

//
//  JSBottomPopSendCommentView.m
//  JSShuo
//
//  Created by li que on 2018/11/27.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSBottomPopSendCommentView.h"
#import "JSNetworkManager+Login.h"

@interface JSBottomPopSendCommentView() <YYTextKeyboardObserver,YYTextViewDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *complementBtn;
@property (nonatomic, strong) UIView *levelLine;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *textBackgroundView;

@property (nonatomic, copy) NSString *articleID;

@property (nonatomic, copy) void(^finishBlock)(NSDictionary *responseDic);


@end

@implementation JSBottomPopSendCommentView

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIView *)textBackgroundView {
    if (!_textBackgroundView) {
        _textBackgroundView = [[UIView alloc] init];
        _textBackgroundView.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
        
    }
    return _textBackgroundView;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        @weakify(self)
        [_cancleBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            [self.textView resignFirstResponder];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UIButton *)complementBtn {
    if (!_complementBtn) {
        _complementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_complementBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_complementBtn setTitleColor:[UIColor colorWithHexString:@"59BA78"] forState:UIControlStateNormal];
        _complementBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        @weakify(self)
        [_complementBtn bk_addEventHandler:^(id sender) {
             @strongify(self);
            if (self.textView.text.length > 0) {
                NSLog(@"要调用发送评论的接口");
                NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
                NSDictionary *params = @{@"token":token,@"articleId":self.articleID,@"content":self.textView.text};
                [JSNetworkManager addComment:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
                    if (isSuccess) {
                        [self.textView resignFirstResponder];
                        if (self.finishBlock) {
                            self.finishBlock(contentDict);
                        }
                    }
                }];
            }else{
                [self showAutoDismissTextAlert:@"请输入您要评论的内容"];
            }
         } forControlEvents:UIControlEventTouchUpInside];
    }
    return _complementBtn;
}

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc] init];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.allowsCopyAttributedString = YES;
        _textView.allowsPasteAttributedString = YES;
        _textView.font = [UIFont systemFontOfSize:15];
        
        _textView.placeholderText = @"请文明发言，遵守评论规则。";
        _textView.delegate = self;
    }
    return _textView;
}

- (void)showAutoDismissTextAlert:(NSString *)alert{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = alert;
    [hud hideAnimated:YES afterDelay:2.f];
}

- (UIView *)levelLine{
    if (!_levelLine) {
        _levelLine = [[UIView alloc]init];
        _levelLine.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    }
    return _levelLine;
}
- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc]init];
        _verticalLine.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    }
    return _verticalLine;
}

+ (void) showInputBarWithView:(UIView *)superView articleId:(NSString *)articleID complement:(void(^)(NSDictionary *comment))complement {
    JSBottomPopSendCommentView *sendView = [[JSBottomPopSendCommentView alloc] initWithFrame:superView.bounds];
    sendView.finishBlock = complement;
    [sendView setupID:articleID];
    [sendView inputbarBecomeFirstResponder];
    [superView addSubview:sendView];
}

- (void) setupID:(NSString *)ID {
    _articleID = ID;
}

- (void) inputbarBecomeFirstResponder {
    [self.textView becomeFirstResponder];
}



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:169/255.0f green:169/255.0f blue:169/255.0f alpha:0.5];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.textBackgroundView];
        
        [self.contentView addSubview:self.textView];
        [self.contentView addSubview:self.levelLine];
        [self.contentView addSubview:self.cancleBtn];
        [self.contentView addSubview:self.complementBtn];
        [self.contentView addSubview:self.verticalLine];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//            [self.textView resignFirstResponder];
//        }];
//        [self addGestureRecognizer:tap];
        
        CGFloat height = 140;
        if (IS_IPHONE_X) {
            height += 34;
        }
        self.contentView.frame = CGRectMake(0, self.height-height, self.width, height);
        
        [self.textBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(80);
            make.top.mas_equalTo(5);
        }];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textBackgroundView).offset(10);
            make.right.equalTo(self.textBackgroundView).offset(-10);
            make.height.mas_equalTo(70);
            make.centerY.mas_equalTo(self.textBackgroundView.mas_centerY);
        }];
        [self.levelLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.textBackgroundView.mas_bottom).offset(5);
        }];
        
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.width.equalTo(self.contentView).dividedBy(2.0);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(self.levelLine.mas_bottom);
        }];
        [self.complementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.width.equalTo(self.contentView).dividedBy(2.0);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(self.levelLine.mas_bottom);
        }];
        [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1, 30));
            make.left.mas_equalTo(self.complementBtn.mas_left);
            make.centerY.mas_equalTo(self.complementBtn.mas_centerY);
        }];
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    return self;
}

#pragma mark YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    //    [self.inputToolbar controlInputViewWithFirstResponder:[self.inputToolbar gg_isFirstResponder]];
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self];
    if (transition.animationDuration == 0) {
        self.contentView.bottom = CGRectGetMinY(toFrame);
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.contentView.bottom = CGRectGetMinY(toFrame);
        } completion:^(BOOL finished) {
            if (toFrame.origin.y == kScreenHeight) {
                [self removeFromSuperview];
            }
        }];
    }
    
}



@end

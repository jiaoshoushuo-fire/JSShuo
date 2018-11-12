//
//  JSInputBar.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/9.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSInputBar.h"
#import "JSNetworkManager+Login.h"
@interface JSInputBar()<YYTextKeyboardObserver,YYTextViewDelegate>
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, strong)UIButton *complementButton;
@property (nonatomic, strong)UIView *levelLine;
@property (nonatomic, strong)UIView *verticalLine;
@property (nonatomic, strong)YYTextView *textView;
@property (nonatomic, strong)UIView *textBackgroundView;

@property (nonatomic, copy)void(^finishBlcok)(NSString *text);
@property (nonatomic, assign)JSInputBarType inputBarType;
@property (nonatomic, strong)UILabel *textNumberLabel;

@end

@implementation JSInputBar

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
//        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.placeholder = @"请输入您的昵称";
    }
    return _textField;
}
- (UIView *)textBackgroundView{
    if (!_textBackgroundView) {
        _textBackgroundView = [[UIView alloc]init];
        _textBackgroundView.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
    }
    return _textBackgroundView;
}
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        @weakify(self)
        [_cancelButton bk_addEventHandler:^(id sender) {
            @strongify(self)
 
            [self inputBarResignFirstResponder];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)complementButton{
    if (!_complementButton) {
        _complementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_complementButton setTitle:@"完成" forState:UIControlStateNormal];
        [_complementButton setTitleColor:[UIColor colorWithHexString:@"59BA78"] forState:UIControlStateNormal];
        _complementButton.titleLabel.font = [UIFont systemFontOfSize:15];
        @weakify(self)
        [_complementButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            
            if (self.inputBarType == JSInputBarTypeNickname) {
                
                if (self.textField.text.length > 0 && self.textField.text.length < 16) {
                    [JSNetworkManager modifyUserInfoWithDict:@{@"nickName":self.textField.text} complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
                        if (isSuccess) {
                            [self inputBarResignFirstResponder];
                            if (self.finishBlcok) {
                                self.finishBlcok(self.textField.text);
                            }
                        }
                    }];
                }else{
                    [self showAutoDismissTextAlert:@"请输入16个字符之内的昵称"];
                }
            }else{
                [JSNetworkManager modifyUserInfoWithDict:@{@"intro":self.textView.text} complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
                    if (isSuccess) {
                        [self inputBarResignFirstResponder];
                        if (self.finishBlcok) {
                            self.finishBlcok(self.textView.text);
                        }
                    }
                }];
                
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _complementButton;
}
- (YYTextView *)textView{
    if (!_textView) {
        _textView = [[YYTextView alloc]init];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.allowsCopyAttributedString = YES;
        _textView.allowsPasteAttributedString = YES;
        _textView.font = [UIFont systemFontOfSize:15];
        
        _textView.placeholderText = @"请输入个人简介，50个字符以内";
        _textView.returnKeyType = UIReturnKeySend;
//        _textView.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        
        _textView.delegate = self;
    }
    return _textView;
}
- (UILabel *)textNumberLabel{
    if (!_textNumberLabel) {
        _textNumberLabel = [[UILabel alloc]init];
        _textNumberLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _textNumberLabel.textAlignment = NSTextAlignmentRight;
        _textNumberLabel.font = [UIFont systemFontOfSize:12];
        _textNumberLabel.text = @"0";
    }
    return _textNumberLabel;
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
+ (void)showInputBarWithView:(UIView *)superView type:(JSInputBarType)type complement:(void(^)(NSString *newNickName))complemnt{
    JSInputBar *inputBar = [[JSInputBar alloc]initWithFrame:superView.bounds withType:type];
    inputBar.finishBlcok = complemnt;
    inputBar.inputBarType = type;
    [inputBar inputbarBecomeFirstResponder];
    [superView addSubview:inputBar];
}
- (void)inputBarResignFirstResponder{
    if (self.inputBarType == JSInputBarTypeNickname) {
        [self.textField resignFirstResponder];
    }else{
        [self.textView resignFirstResponder];
    }
}
- (void)inputbarBecomeFirstResponder{
    if (self.inputBarType == JSInputBarTypeNickname) {
        [self.textField becomeFirstResponder];
    }else{
        [self.textView becomeFirstResponder];
    }
}
- (instancetype)initWithFrame:(CGRect)frame withType:(JSInputBarType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:169/255.0f green:169/255.0f blue:169/255.0f alpha:0.5];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.textBackgroundView];
        
        if (type == JSInputBarTypeNickname) {
            [self.contentView addSubview:self.textField];
        }else{
            [self.contentView addSubview:self.textView];
            [self.contentView addSubview:self.textNumberLabel];
        }
        
        [self.contentView addSubview:self.levelLine];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.complementButton];
        [self.contentView addSubview:self.verticalLine];
        
        CGFloat height = type == JSInputBarTypeNickname ? 100 : 140;
        if (IS_IPHONE_X) {
            height += 34;
        }
        
        self.contentView.frame = CGRectMake(0, self.height-height, self.width, height);
        
        [self.textBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            CGFloat b_height = type == JSInputBarTypeNickname ? 40 : 80;
            make.height.mas_equalTo(b_height);
            make.top.equalTo(self.contentView).offset(5);
        }];
        if (type == JSInputBarTypeNickname) {
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.textBackgroundView).offset(10);
                make.right.equalTo(self.textBackgroundView).offset(-10);
                make.height.mas_equalTo(30);
                make.centerY.mas_equalTo(self.textBackgroundView.mas_centerY);
            }];
        }else{
            [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.textBackgroundView).offset(10);
                make.right.equalTo(self.textBackgroundView).offset(-10);
                make.height.mas_equalTo(70);
                make.centerY.mas_equalTo(self.textBackgroundView.mas_centerY);
            }];
            [self.textNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(self.textBackgroundView).offset(-5);
                make.size.mas_equalTo(CGSizeMake(20, 10));
            }];
            
        }
        [self.levelLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.textBackgroundView.mas_bottom).offset(5);
        }];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.width.equalTo(self.contentView).dividedBy(2.0);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(self.levelLine.mas_bottom);
        }];
        [self.complementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.width.equalTo(self.contentView).dividedBy(2.0);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(self.levelLine.mas_bottom);
        }];
        [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1, 30));
            make.left.mas_equalTo(self.complementButton.mas_left);
            make.centerY.mas_equalTo(self.complementButton.mas_centerY);
        }];
        [[YYTextKeyboardManager defaultManager] addObserver:self];
        
    }
    return self;
}
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@""]) {
        return YES;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];

    if (str.length > 50) {
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:50];
        if (rangeIndex.length == 1)//字数超限
        {
            textView.text = [str substringToIndex:50];
            //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
//            self.textNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)textView.text.length];

        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 50)];
            textView.text = [str substringWithRange:rangeRange];

        }
        return NO;

    }
    return YES;
    
}
- (void)textViewDidChange:(YYTextView *)textView{
    self.textNumberLabel.text = @(textView.text.length).stringValue;
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

- (void)showAutoDismissTextAlert:(NSString *)alert{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = alert;
    [hud hideAnimated:YES afterDelay:2.f];
}
@end

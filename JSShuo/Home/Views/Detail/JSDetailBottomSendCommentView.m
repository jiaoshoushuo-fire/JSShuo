//
//  JSDetailBottomSendCommentView.m
//  JSShuo
//
//  Created by li que on 2018/11/20.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSDetailBottomSendCommentView.h"

@implementation JSDetailBottomSendCommentView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        topLineView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [self addSubview:topLineView];
        
        [self addSubview:self.sendCommentContentView];
        [self.sendCommentContentView addSubview:self.editImgView];
        [self.sendCommentContentView addSubview:self.sendCommentLabel];
//        [self.sendCommentContentView addSubview:self.expressionImgView];
//        [self addSubview:self.chatBtn];
        [self addSubview:self.praiseBtn];
        [self addSubview:self.collectionBtn];
        [self addSubview:self.shareBtn];
        
        [self.sendCommentContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.praiseBtn.mas_left).offset(-22);
            make.top.mas_equalTo((40-28)*0.5);
            make.height.mas_equalTo(28);
        }];
        [self.editImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.top.mas_equalTo((28-18)*0.5);
        }];
        [self.sendCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.editImgView.mas_right).offset(9);
            make.right.mas_equalTo(self.sendCommentContentView.mas_right).offset(0);
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(18);
        }];
//        [self.expressionImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(16, 16));
//            make.top.mas_equalTo((28-16)*0.6);
//            make.right.mas_equalTo(self.sendCommentContentView.mas_right).offset(-10);
//        }];
        
        
//        [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            // 23 * 22
//            make.size.mas_equalTo(CGSizeMake(23, 22));
//            make.top.mas_equalTo((40-22)*0.5);
//            make.right.mas_equalTo(self.praiseBtn.mas_left).offset(-20);
//        }];
        [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            // 21 * 22
            make.right.mas_equalTo(self.collectionBtn.mas_left).offset(-24);
            make.size.mas_equalTo(CGSizeMake(21, 22));
            make.top.mas_equalTo((40-22)*0.5);
        }];
        [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            // 24 * 23
            make.size.mas_equalTo(CGSizeMake(24, 23));
            make.top.mas_equalTo((40-23)*0.5);
            make.right.mas_equalTo(self.shareBtn.mas_left).offset(-20);
        }];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            // 23 * 22
            make.size.mas_equalTo(CGSizeMake(23, 22));
            make.top.mas_equalTo((40-22)*0.5);
            make.right.mas_equalTo(-15);
        }];
        
//        [self addSubview:self.commentNum];
        [self addSubview:self.praiseNum];
//        [self.commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(26, 16));
//            make.top.mas_equalTo(5);
//            make.left.mas_equalTo(self.chatBtn.mas_right).offset(-7);
//        }];
        [self.praiseNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 16));
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(self.praiseBtn.mas_right).offset(-7);
        }];
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldShouldBeginEditing");
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing");
}

- (UIView *)sendCommentContentView {
    if (!_sendCommentContentView) {
        _sendCommentContentView = [[UIView alloc] init];
        _sendCommentContentView.layer.cornerRadius = 15;
        _sendCommentContentView.layer.borderWidth = 1;
        _sendCommentContentView.layer.borderColor = [[UIColor colorWithHexString:@"E8E8E8"] CGColor];
        _sendCommentContentView.backgroundColor = [UIColor colorWithHexString:@"F4F5F6"];
    }
    return _sendCommentContentView;
}

- (UIImageView *)editImgView {
    if (!_editImgView) {
        // 18 * 18
        _editImgView = [[UIImageView alloc] init];
        _editImgView.image = [UIImage imageNamed:@"editIcon"];
    }
    return _editImgView;
}

- (UILabel *)sendCommentLabel {
    if (!_sendCommentLabel) {
        _sendCommentLabel = [[UILabel alloc] init];
        _sendCommentLabel.text = @"我来说两句";
        _sendCommentLabel.userInteractionEnabled = YES;
        _sendCommentLabel.font = [UIFont systemFontOfSize:15];
        _sendCommentLabel.textColor = [UIColor colorWithHexString:@"A8A8A8"];
    }
    return _sendCommentLabel;
}

- (UIImageView *)expressionImgView {
    if (!_expressionImgView) {
        // 16 * 16
        _expressionImgView = [[UIImageView alloc] init];
        _expressionImgView.image = [UIImage imageNamed:@"expressionIcon"];
    }
    return _expressionImgView;
}

- (UIButton *)chatBtn {
    if (!_chatBtn) {
        // 23 * 22
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatBtn setImage:[UIImage imageNamed:@"commentIcon"] forState:UIControlStateNormal];
        [_chatBtn setImage:[UIImage imageNamed:@"commentIcon_selected"] forState:UIControlStateSelected];
    }
    return _chatBtn;
}

- (UILabel *)commentNum {
    if (!_commentNum) {
        _commentNum = [[UILabel alloc] init];
        _commentNum.backgroundColor = [UIColor redColor];
        _commentNum.textColor = [UIColor whiteColor];
        _commentNum.font = [UIFont systemFontOfSize:10];
        _commentNum.textAlignment = NSTextAlignmentCenter;
        _commentNum.layer.cornerRadius = 8;
        _commentNum.layer.masksToBounds = YES;
    }
    return _commentNum;
}

- (UIButton *)praiseBtn {
    if (!_praiseBtn) {
        // 21 * 22
        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
//        [_praiseBtn setImage:[UIImage imageNamed:@"praise_selected"] forState:UIControlStateHighlighted];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise_selected"] forState:UIControlStateSelected];
    }
    return _praiseBtn;
}

- (UILabel *)praiseNum {
    if (!_praiseNum) {
        _praiseNum = [[UILabel alloc] init];
        _praiseNum.backgroundColor = [UIColor redColor];
        _praiseNum.textColor = [UIColor whiteColor];
        _praiseNum.font = [UIFont systemFontOfSize:10];
        _praiseNum.textAlignment = NSTextAlignmentCenter;
        _praiseNum.layer.cornerRadius = 8;
        _praiseNum.layer.masksToBounds = YES;
    }
    return _praiseNum;
}

- (UIButton *)collectionBtn {
    if (!_collectionBtn) {
        // 24 * 23
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBtn setImage:[UIImage imageNamed:@"collectionIcon"] forState:UIControlStateNormal];
        [_collectionBtn setImage:[UIImage imageNamed:@"collectionIcon_selected"] forState:UIControlStateSelected];
//        [_collectionBtn setImage:[UIImage imageNamed:@"collectionIcon_selected"] forState:UIControlStateHighlighted];
    }
    return _collectionBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        // 23 * 22
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}



@end

//
//  JSSearchTopNavView.m
//  JSShuo
//
//  Created by li que on 2018/11/15.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSSearchTopNavView.h"

@implementation JSSearchTopNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backBtn];
        [self.searchContentView addSubview:self.mirrorImgView];
        [self.searchContentView addSubview:self.searchTextField];
        [self addSubview:self.searchContentView];
        [self addSubview:self.cancleBtn];
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(9);
            make.height.mas_equalTo(16);
            make.top.mas_equalTo(20+(44-16)*0.5);
        }];
        [self.searchContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backBtn.mas_right).offset(15);
            make.right.mas_equalTo(self.cancleBtn.mas_left).offset(-15);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(20+(44-29)*0.5);
        }];
        [self.mirrorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.height.mas_equalTo(17);
            make.top.mas_equalTo((28-17)*0.5);
        }];
        [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mirrorImgView.mas_right).offset(10);
            make.right.mas_equalTo(self.searchContentView);
            make.top.mas_equalTo((28-17)*0.5);
            make.height.mas_equalTo(17);
        }];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(self.searchContentView);
            make.width.mas_equalTo(40);
        }];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.delegate && textField.text.length > 0) {
        [self.delegate passKeyword:textField.text];
        return YES;
    }
    return YES;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"searchBack"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIView *)searchContentView {
    if (!_searchContentView) {
        _searchContentView = [[UIView alloc] init];
        _searchContentView.layer.cornerRadius = 10;
        _searchContentView.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    }
    return _searchContentView;
}

- (UIImageView *)mirrorImgView {
    if (!_mirrorImgView) {
        _mirrorImgView = [[UIImageView alloc] init];
        _mirrorImgView.image = [UIImage imageNamed:@"nav_headr_search"];
    }
    return _mirrorImgView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.placeholder = @"搜索您感兴趣的内容";
        _searchTextField.font = [UIFont systemFontOfSize:12];
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor colorWithHexString:@"E81E2D"] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
    }
    return _cancleBtn;
}

@end

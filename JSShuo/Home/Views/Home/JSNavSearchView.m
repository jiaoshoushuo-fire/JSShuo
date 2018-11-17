//
//  JSNavSearchView.m
//  JSShuo
//
//  Created by li que on 2018/11/4.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSNavSearchView.h"

@interface JSNavSearchView ()
@property (nonatomic,strong) UILabel *searchTitleLabel;
@property (nonatomic,strong) UIImageView *searchImgView;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation JSNavSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [self addSubview:self.headButton];
        [self addSubview:self.searchRectangle];
        [self addSubview:self.redPocketButton];
        
        [self.headButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 26));
            make.left.mas_equalTo(self).offset(15);
            // (44-26)/2 = 8;
            make.bottom.mas_equalTo(self).offset(-8);
        }];
        
        [self.redPocketButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(27, 22));
            make.bottom.mas_equalTo(self).offset(-10);
            make.right.mas_equalTo(self).offset(-15);
        }];
        
        [self.searchRectangle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headButton.mas_right).offset(16);
            make.right.mas_equalTo(self.redPocketButton.mas_left).offset(-16);
            make.bottom.mas_equalTo(-8);
            make.height.mas_equalTo(26);
        }];
        
        [self.searchRectangle addSubview:self.searchTitleLabel];
        [self.searchRectangle addSubview:self.searchImgView];
        [self.searchRectangle addSubview:self.lineView];
        [self.searchTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.searchRectangle).offset(12);
            make.size.mas_equalTo(CGSizeMake(120, 20));
            make.top.mas_equalTo(self.searchRectangle).offset(3);
        }];
        [self.searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.centerY.mas_equalTo(self.searchTitleLabel);
            make.right.mas_equalTo(self.searchRectangle.mas_right).offset(-12);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1, 20));
            make.top.mas_equalTo(self.searchRectangle.mas_top).offset(3);
            make.right.mas_equalTo(self.searchImgView.mas_left).offset(-10);
        }];
        
    }
    return self;
}

// 红包按钮
- (UIButton *)redPocketButton {
    if (!_redPocketButton) {
        _redPocketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _redPocketButton.size = CGSizeMake(27, 22);
        [_redPocketButton setImage:[UIImage imageNamed:@"nav_headr_redpocket"] forState:UIControlStateNormal];
    }
    return _redPocketButton;
}

// 左边的登录按钮
- (UIButton *)headButton {
    if (!_headButton) {
        _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headButton.size = CGSizeMake(26, 26);
        [_headButton setImage:[UIImage imageNamed:@"nav_header_login_normal"] forState:UIControlStateNormal];
        [_headButton setImage:[UIImage imageNamed:@"nav_header_login_selected"] forState:UIControlStateSelected];
    }
    return _headButton;
}


// 搜索框
- (UIView *)searchRectangle {
    if (!_searchRectangle) {
        _searchRectangle = [[UIView alloc] init];
        _searchRectangle.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
        _searchRectangle.layer.cornerRadius = 10;
    }
    return _searchRectangle;
}

// 搜索框上的字
- (UILabel *) searchTitleLabel {
    if (!_searchTitleLabel) {
        _searchTitleLabel = [[UILabel alloc] init];
        _searchTitleLabel.font = [UIFont systemFontOfSize:12];
        _searchTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _searchTitleLabel.textAlignment = NSTextAlignmentLeft;
        _searchTitleLabel.text = @"搜索您感兴趣的内容";
        _searchTitleLabel.userInteractionEnabled = YES;
    }
    return _searchTitleLabel;
}

- (UIImageView *)searchImgView {
    if (!_searchImgView) {
        _searchImgView = [[UIImageView alloc] init];
        _searchImgView.image = [UIImage imageNamed:@"nav_headr_search"];
        _searchImgView.userInteractionEnabled = YES;
    }
    return _searchImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"C6C6C6"];
    }
    return _lineView;
}




@end

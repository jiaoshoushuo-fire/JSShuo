//
//  JSMainTabBar.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMainTabBar.h"

@interface JSMainTabBar ()

@property (nonatomic, copy) void (^handler)(id sender);

@property (nonatomic, strong, readwrite) UILabel *homeBadge;
@property (nonatomic, strong, readwrite) UILabel *newsBadge;

@property (nonatomic, strong, readwrite) UIButton *homeButton;
@property (nonatomic, strong, readwrite) UIButton *discoverButton;
//@property (nonatomic, strong, readwrite) UIButton *publishButton;
@property (nonatomic, strong, readwrite) UIButton *newsButton;
@property (nonatomic, strong, readwrite) UIButton *profileButton;

@end


@implementation JSMainTabBar

+ (instancetype)mainTabBarWithHandler:(void (^)(id))handler {
    JSMainTabBar *tabBar = [[JSMainTabBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    tabBar.barStyle = UIBarStyleDefault;
    tabBar.translucent = YES;
    tabBar.handler = handler;
    return tabBar;
}

- (UILabel *)homeBadge {
    if (!_homeBadge) {
        _homeBadge = [[self class] badgeLabel];
    }
    return _homeBadge;
}

- (UILabel *)newsBadge {
    if (!_newsBadge) {
        _newsBadge = [[self class] badgeLabel];
    }
    return _newsBadge;
}

+ (UILabel *)badgeLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.backgroundColor = [UIColor colorWithIndex:7];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 10;
    label.layer.borderColor = [UIColor whiteColor].CGColor;
    label.layer.borderWidth = 1.5f;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:8];
    return label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupButtons];
        [self setupBadges];
    }
    return self;
}

- (void)setupButtons {
    
    CGSize itemSize = CGSizeMake(self.width / 4.0f, self.height);
    self.homeButton = [self buttonWithNormalImage:[UIImage imageNamed:@"tab_home_normal"]
                                    selectedImage:[UIImage imageNamed:@"tab_home_selected"]
                                            title:@"推荐"
                                             size:itemSize];
    self.discoverButton = [self buttonWithNormalImage:[UIImage imageNamed:@"tab_discover_normal"]
                                        selectedImage:[UIImage imageNamed:@"tab_discover_selected"]
                                                title:@"视频"
                                                 size:itemSize];
//    self.publishButton = [self buttonWithNormalImage:[UIImage imageNamed:@"tab_publish"]
//                                       selectedImage:[UIImage imageNamed:@"tab_publish"]
//                                               title:@""
//                                                size:CGSizeMake(self.width / 5, self.width / 5 / 1.27)];
    self.newsButton = [self buttonWithNormalImage:[UIImage imageNamed:@"tab_news_normal"]
                                    selectedImage:[UIImage imageNamed:@"tab_news_selected"]
                                            title:@"任务"
                                             size:itemSize];
    self.profileButton = [self buttonWithNormalImage:[UIImage imageNamed:@"tab_profile_normal"]
                                       selectedImage:[UIImage imageNamed:@"tab_profile_selected"]
                                               title:@"我的"
                                                size:itemSize];
    
    self.homeButton.origin = CGPointMake(0, 0);
    self.discoverButton.origin = CGPointMake(self.homeButton.right, 0);
//    self.publishButton.origin = CGPointMake(self.discoverButton.right, -8);
    self.newsButton.origin = CGPointMake(self.discoverButton.right, 0);
    self.profileButton.origin = CGPointMake(self.newsButton.right, 0);
    
    self.homeButton.selected = YES;
    
    [self addSubview:self.homeButton];
    [self addSubview:self.discoverButton];
//    [self addSubview:self.publishButton];
    [self addSubview:self.newsButton];
    [self addSubview:self.profileButton];
}

- (UIButton *)buttonWithNormalImage:(UIImage *)normalImage
                      selectedImage:(UIImage *)selectedImage
                              title:(NSString *)title
                               size:(CGSize)size {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = size;
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"98a4ab"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"F44336"] forState:UIControlStateSelected];
    if (SYSTEM_VERSION_NOT_LESS_THAN(@"8.2")) {
        button.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightLight];
    } else {
        button.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    
    if ([title isNotBlank]) {
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.width, -button.imageView.height-1, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.height-1, 0, 0, -button.titleLabel.width);
    }
    
    [button addTarget:self action:@selector(didSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setupBadges {
    {
        CGRect rect = [self.homeButton convertRect:self.homeButton.imageView.frame toView:self];
        self.homeBadge.center = CGPointMake(CGRectGetMaxX(rect) + 3, self.homeButton.top + self.homeBadge.height/2);
        self.homeBadge.hidden = YES;
        [self addSubview:self.homeBadge];
    }
    {
        CGRect rect = [self.newsButton convertRect:self.newsButton.imageView.frame toView:self];
        self.newsBadge.center = CGPointMake(CGRectGetMaxX(rect) + 3, self.newsButton.top + self.newsBadge.height/2);
        self.newsBadge.hidden = YES;
        [self addSubview:self.newsBadge];
    }
}

- (void)didSelectedButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button == self.newsButton || button == self.profileButton) {
        [JSAccountManager checkLoginStatusComplement:^(BOOL isLogin) {
            if (isLogin) {
                [self processButtonAction:sender];
            }
        }];
    } else {
        [self processButtonAction:sender];
    }
}

- (void)processButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (button == self.homeButton) {
        [self setSelectButtonAtIndex:0];
    } else if (button == self.discoverButton) {
        [self setSelectButtonAtIndex:1];
    } /*else if (button == self.publishButton){
        [self setSelectButtonAtIndex:2];
    }*/else if (button == self.newsButton) {
        [self setSelectButtonAtIndex:2];
    } else if (button == self.profileButton) {
        [self setSelectButtonAtIndex:3];
    }
    
    if (self.handler) {
        self.handler(button);
    }
}

- (void)setSelectButtonAtIndex:(NSInteger)index {
    self.homeButton.selected = (index == 0);
    self.discoverButton.selected = (index == 1);
//    self.publishButton.selected = (index == 2);
    self.newsButton.selected = (index == 2);
    self.profileButton.selected = (index == 3);
}

- (void)setBadgeNumber:(NSUInteger)number atIndex:(NSInteger)index {
    if (index == 0) {
        self.homeBadge.hidden = (number == 0);
        NSString *text = @"";
        if (number > 99) {
            self.homeBadge.font = [UIFont systemFontOfSize:9];
            text = @"99+";
        } else {
            self.homeBadge.font = [UIFont systemFontOfSize:12];
            text = [NSString stringWithFormat:@"%lu", (unsigned long)number];
        }
        self.homeBadge.text = text;
    } else if (index == 3) {
        self.newsBadge.hidden = (number == 0);
        NSString *text = @"";
        if (number > 99) {
            self.newsBadge.font = [UIFont systemFontOfSize:9];
            text = @"99+";
        } else {
            self.newsBadge.font = [UIFont systemFontOfSize:12];
            text = [NSString stringWithFormat:@"%lu", (unsigned long)number];
        }
        self.newsBadge.text = text;
    }
}


@end

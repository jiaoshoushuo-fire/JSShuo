//
//  ZFDouYinCell.m
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFDouYinCell.h"
//#import <ZFPlayer/UIImageView+ZFCache.h>
//#import "ZFPlayer/Classes/ControlView/UIImageView+ZFCache.h"
#import "UIImageView+ZFCache.h"
//#import <ZFPlayer/UIView+ZFFrame.h>
#import "UIView+ZFFrame.h"
//#import <ZFPlayer/UIImageView+ZFCache.h>
#import "UIImageView+ZFCache.h"
//#import <ZFPlayer/ZFUtilities.h>
#import "ZFUtilities.h"
#import "JSNetworkManager+Login.h"
#import "ZFLoadingView.h"

@interface ZFDouYinCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation ZFDouYinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.shareBtn];
        @weakify(self)
        [self.likeBtn bk_addEventHandler:^(UIButton *sender) {
            @strongify(self)
            sender.userInteractionEnabled = NO;
            if (sender.selected) { // 取消点赞
                [JSNetworkManager deletePraiseWithArticleID:self.data.articleId.integerValue complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
                    NSLog(@"取消点赞 -- %@",contentDic);
                    sender.userInteractionEnabled = YES;
                    if (isSuccess) {
                        sender.selected = NO;
                    }
                }];
            } else { // 点赞
                NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
                NSDictionary *params = @{@"token":token,@"articleId":self.data.articleId};
                [JSNetworkManager addPraise:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
                    NSLog(@"点赞 -- %@",contentDic);
                    sender.userInteractionEnabled = YES;
                    if (isSuccess) {
                        sender.selected = YES;
                    }
                }];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedLikeButtonWithModel:)]) {
                [self.delegate didSelectedLikeButtonWithModel:self.data];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self.commentBtn bk_addEventHandler:^(id sender) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedCommentButtonWithModel:)]) {
                [self.delegate didSelectedCommentButtonWithModel:self.data];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self.shareBtn bk_addEventHandler:^(id sender) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedShareButtonWithModel:)]) {
                [self.delegate didSelectedShareButtonWithModel:self.data];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.contentView.bounds;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.width;
    CGFloat min_view_h = self.height;
    CGFloat margin = 30;
    
    min_w = 30;
    min_h = min_w;
    min_x = min_view_w - min_w - 20;
    min_y = min_view_h - min_h - 80;
    self.shareBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = CGRectGetWidth(self.shareBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.shareBtn.frame);
    min_y = CGRectGetMinY(self.shareBtn.frame) - min_h - margin;
    self.commentBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = CGRectGetWidth(self.shareBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.commentBtn.frame);
    min_y = CGRectGetMinY(self.commentBtn.frame) - min_h - margin;
    self.likeBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 20;
    min_h = 20;
    min_y = min_view_h - min_h - 50;
    min_w = self.likeBtn.left - margin;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"adfkljaklfja";
    }
    return _titleLabel;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"js_shortvideo_dianzan"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"praise_selected"] forState:UIControlStateSelected];
    }
    return _likeBtn;
}


- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"js_shortvideo_xiaoxi"] forState:UIControlStateNormal];
    }
    return _commentBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"js_shortvideo_fenxiang"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)];
    }
    return _placeholderImage;
}

- (void)setData:(JSShortVideoModel *)data {
    _data = data;
    [self.coverImageView setImageWithURLString:data.cover[0] placeholder:[UIImage imageNamed:@"loading_bgView"]];
    self.titleLabel.text = data.title;
    
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.backgroundColor = [UIColor blackColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}
- (void)prepareForReuse{
    self.likeBtn.selected = NO;
    self.data = nil;
}
@end

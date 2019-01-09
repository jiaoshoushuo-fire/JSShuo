//
//  JSCommentView.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/12/10.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSCommentView.h"
#import "JSCommentTableView.h"
#import "JSNetworkManager+Login.h"
#import "JSNetworkManager+Comment.h"

@interface JSCommentInputBar : UIView
@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)YYTextView *inputTextView;

@property (nonatomic, strong)UIButton *faceButton;
@property (nonatomic, strong)JSCommentModel *commentModel;
@end
@implementation JSCommentInputBar

- (YYTextView *)inputTextView{
    if (!_inputTextView) {
        _inputTextView = [[YYTextView alloc]init];
        _inputTextView.showsVerticalScrollIndicator = NO;
        _inputTextView.showsHorizontalScrollIndicator = NO;
        _inputTextView.allowsCopyAttributedString = YES;
        _inputTextView.allowsPasteAttributedString = YES;
        _inputTextView.font = [UIFont systemFontOfSize:15];
        _inputTextView.textColor = [UIColor colorWithHexString:@"333333"];
        _inputTextView.placeholderTextColor = [UIColor colorWithHexString:@"999999"];
        _inputTextView.placeholderText = @"留下您精彩的评论吧";
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        
    }
    return _inputTextView;
}
- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"js_comment_xie"] forState:UIControlStateNormal];
        _leftButton.size = CGSizeMake(30, 30);
    }
    return _leftButton;
}
- (UIButton *)faceButton{
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton setImage:[UIImage imageNamed:@"js_comment_biaoqing"] forState:UIControlStateNormal];
        _faceButton.size = CGSizeMake(30, 30);
    }
    return _faceButton;
}
- (void)setCommentModel:(JSCommentModel *)commentModel{
    _commentModel = commentModel;
    if (commentModel) {
        
        self.inputTextView.placeholderText = [NSString stringWithFormat:@"回复 %@ ",commentModel.nickname];
//        [self.inputTextView becomeFirstResponder];
    }else{
        //留下您精彩的评论吧
//        self.inputTextView.placeholderText = [NSString stringWithFormat:@"%@",@"回复 张三"];
        self.inputTextView.placeholderText = [NSString stringWithFormat:@"%@ ",@"留下您精彩的评论吧"];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftButton];
        [self addSubview:self.inputTextView];
        [self addSubview:self.faceButton];
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.size.mas_equalTo(self.leftButton.size);
        }];
        [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(10);
            make.size.mas_equalTo(self.faceButton.size);
        }];
        [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftButton.mas_right).offset(10);
            make.right.equalTo(self.faceButton.mas_left).offset(-10);
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
        }];
        
    }
    return self;
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    self.leftButton.left = 10;
//    self.leftButton.top = 10;
//    self.faceButton.right = kScreenWidth - 10;
//    self.faceButton.top = 10;
//
//    self.inputTextView.left = self.leftButton.right + 10;
//    self.inputTextView.right = self.faceButton.left - 10;
//    self.inputTextView.top = 10;
//    self.inputTextView.bottom = self.height - 10;
//}

@end

@interface JSCommentViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *nickNameLabel;
@property (nonatomic, strong)UILabel *timelabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIButton *likeButton;
@property (nonatomic, strong)UILabel *likeNumberLabel;
//@property (nonatomic, strong)UIButton *replyButton;
//@property (nonatomic, strong)UILabel *replayNumberLabel;
@property (nonatomic, strong)JSCommentModel *commentModel;
@end

@implementation JSCommentViewCell

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView  = [[UIImageView alloc]init];
        _iconImageView.size = CGSizeMake(40, 40);
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = _iconImageView.height/2.0f;
    }
    return _iconImageView;
}
- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
        _nickNameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        
    }
    return _nickNameLabel;
}
- (UILabel *)timelabel{
    if (!_timelabel) {
        _timelabel = [[UILabel alloc]init];
        _timelabel.font = [UIFont systemFontOfSize:12];
        _timelabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _timelabel;
}
- (UILabel *)likeNumberLabel{
    if (!_likeNumberLabel) {
        _likeNumberLabel = [[UILabel alloc]init];
        _likeNumberLabel.font = [UIFont systemFontOfSize:12];
        _likeNumberLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _likeNumberLabel;
}

//- (UILabel *)replayNumberLabel{
//    if (!_replayNumberLabel) {
//        _replayNumberLabel = [[UILabel alloc]init];
//        _replayNumberLabel.font = [UIFont systemFontOfSize:12];
//        _replayNumberLabel.textColor = [UIColor colorWithHexString:@"999999"];
//    }
//    return _replayNumberLabel;
//}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _contentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _contentLabel;
}
- (UIButton *)likeButton{
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"praise_selected"] forState:UIControlStateSelected];
        _likeButton.size = CGSizeMake(30, 30);
    }
    return _likeButton;
}
//- (UIButton *)replyButton{
//    if (!_replyButton) {
//        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_replyButton setImage:[UIImage imageNamed:@"commentIcon"] forState:UIControlStateNormal];
//        _replyButton.size = CGSizeMake(30, 30);
//    }
//    return _replyButton;
//}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.timelabel];
        [self.contentView addSubview:self.contentLabel];
//        [self.contentView addSubview:self.likeButton];
//        [self.contentView addSubview:self.likeNumberLabel];
//        [self.contentView addSubview:self.replyButton];
//        [self.contentView addSubview:self.replayNumberLabel];
    }
    return self;
}

+ (CGFloat)heightForModel:(JSCommentModel *)model{
    CGFloat height = 10;
    height += 40;
    height += 10;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth-40-10-10-10,MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    CGFloat contentHeight = rect.size.height;
    height += contentHeight;
    
    return height;
}

- (void)setCommentModel:(JSCommentModel *)commentModel{
    _commentModel = commentModel;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:commentModel.portrait] placeholder:[UIImage imageNamed:@"js_profile_default_icon"]];
    self.nickNameLabel.text = commentModel.nickname;
    [self.nickNameLabel sizeToFit];
    self.timelabel.text = commentModel.createTime;
    [self.timelabel sizeToFit];
    
    self.contentLabel.text = commentModel.content;
    
    self.likeNumberLabel.text = @"1000";
//    self.replayNumberLabel.text = @"1000";
    [self.likeNumberLabel sizeToFit];
//    [self.replayNumberLabel sizeToFit];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconImageView.left = self.iconImageView.top = 10;
    self.nickNameLabel.left = self.iconImageView.right + 10;
    self.nickNameLabel.top = self.iconImageView.top;
    
    self.timelabel.left = self.nickNameLabel.left;
    self.timelabel.top = self.nickNameLabel.bottom+5;
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(kScreenWidth-40-10-10-10, MAXFLOAT)];
    self.contentLabel.size = size;
    
    self.contentLabel.left = self.nickNameLabel.left;
    self.contentLabel.top = self.iconImageView.bottom + 10;
    
//    self.replayNumberLabel.right = kScreenWidth - 10;
//    self.replyButton.right = self.replayNumberLabel.left - 5;
    self.likeNumberLabel.right = kScreenWidth - 10;
    self.likeButton.right = self.likeNumberLabel.left - 5;
    
//    self.replayNumberLabel.centerY = self.replyButton.centerY = self.likeNumberLabel.centerY = self.likeButton.centerY = self.iconImageView.centerY;
    self.likeNumberLabel.centerY = self.likeButton.centerY = self.iconImageView.centerY;
}

@end

@interface JSCommentViewSubCell : UITableViewCell
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *nickNameLabel;
@property (nonatomic, strong)UILabel *timelabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)JSCommentModel *commentModel;


@end

@implementation JSCommentViewSubCell

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView  = [[UIImageView alloc]init];
        _iconImageView.size = CGSizeMake(25, 25);
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = _iconImageView.height/2.0f;
    }
    return _iconImageView;
}
- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
        _nickNameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        
    }
    return _nickNameLabel;
}
- (UILabel *)timelabel{
    if (!_timelabel) {
        _timelabel = [[UILabel alloc]init];
        _timelabel.font = [UIFont systemFontOfSize:12];
        _timelabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _timelabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _contentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _contentLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.timelabel];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

+ (CGFloat)heightForModel:(JSCommentModel *)model{
    CGFloat height = 5;
    height += 25;
    height += 5;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSString *contentString = model.content;
    if (model.replyNickname.length > 0) {
        contentString = [NSString stringWithFormat:@"回复 %@ %@",model.replyNickname,model.content];
    }
    
    CGRect rect = [contentString boundingRectWithSize:CGSizeMake(kScreenWidth-40-10-10 -20-10-10,MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    CGFloat contentHeight = rect.size.height;
    height += contentHeight;
    
    return height;
}

- (void)setCommentModel:(JSCommentModel *)commentModel{
    _commentModel = commentModel;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:commentModel.portrait] placeholder:[UIImage imageNamed:@"js_profile_default_icon"]];
    self.nickNameLabel.text = commentModel.nickname;
    [self.nickNameLabel sizeToFit];
    self.timelabel.text = commentModel.createTime;
    [self.timelabel sizeToFit];
    
    NSString *contentString = commentModel.content;
    if (commentModel.replyNickname.length > 0) {
        contentString = [NSString stringWithFormat:@"回复 %@ %@",commentModel.replyNickname,commentModel.content];
        
        NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc]initWithString:contentString];
        [contentText addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHexString:@"999999"]
                              range:[contentString rangeOfString:commentModel.replyNickname]];
        self.contentLabel.attributedText = contentText;
    }else{
        self.contentLabel.text = commentModel.content;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconImageView.left = 10 + 40 + 10;
    self.iconImageView.top = 5;
    self.nickNameLabel.left = self.iconImageView.right + 10;
    
    
    
    self.timelabel.left = self.nickNameLabel.right + 10;
    self.nickNameLabel.centerY = self.timelabel.centerY = self.iconImageView.centerY;
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(kScreenWidth-40-10-10 -20-10-10, MAXFLOAT)];
    self.contentLabel.size = size;
    
    self.contentLabel.left = self.nickNameLabel.left;
    self.contentLabel.top = self.iconImageView.bottom + 5;
    
}
@end

@interface JSCommentViewMoreCell : UITableViewCell

@end

@implementation JSCommentViewMoreCell


@end

@implementation JSCommentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"articleId" : @"articleId",
             @"commentId" : @"commentId",
             @"content" : @"content",
             @"createTime" : @"createTime",
             @"level" : @"level",
             @"nickname" : @"nickname",
             @"portrait" : @"portrait",
             @"replyCommentId" : @"replyCommentId",
             @"replyList" : @"replyList",
             @"replyNickname" : @"replyNickname",
             @"replyUserId" : @"replyUserId",
             @"userId" : @"userId"
             };
}
//compareCurrentTime
+ (NSValueTransformer *)replyListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JSCommentModel class]];
}
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"createTime"]){
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            return [JSTool compareCurrentTime:value];
        }];
    }else if ([key isEqualToString:@"content"]){
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            return [value stringByURLDecode];
        }];
    }
    return nil;
}

@end
@interface JSCommentView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,YYTextKeyboardObserver,YYTextViewDelegate>
@property (nonatomic, strong)NSMutableArray *commentList;
@property (nonatomic, strong)UIView *commentView;
@property (nonatomic, strong)JSCommentTableView *commentTableView;
@property (nonatomic, strong)JSCommentInputBar *inputBar;

@property (nonatomic, assign)NSInteger totolNumber;
@property (nonatomic, strong)UIButton *closeButton;

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, assign)CGPoint currentPoint;

@property (nonatomic, assign)CGFloat originalTop;
@property (nonatomic, assign)CGFloat contentOffsetY;

@property (nonatomic, strong)JSShortVideoModel *videoModel;
@property (nonatomic, assign)NSInteger currentPage;

@end
@implementation JSCommentView

- (NSMutableArray *)commentList{
    if (!_commentList) {
        _commentList = [NSMutableArray array];
    }
    return _commentList;
}
- (UITableView *)commentTableView{
    if (!_commentTableView) {
        _commentTableView = [[JSCommentTableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        [_commentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        [_commentTableView registerClass:[JSCommentViewCell class] forCellReuseIdentifier:@"JSCommentViewCell"];
        [_commentTableView registerClass:[JSCommentViewSubCell class] forCellReuseIdentifier:@"JSCommentViewSubCell"];
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        @weakify(self)
        _commentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self refreshDataListWithHeaderRefresh:YES];
        }];
        
        _commentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self refreshDataListWithHeaderRefresh:NO];
        }];
    }
    return _commentTableView;
}
- (JSCommentInputBar *)inputBar{
    if (!_inputBar) {
        _inputBar = [[JSCommentInputBar alloc]initWithFrame:CGRectMake(0, self.height - 50, self.width, 50)];
        _inputBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _inputBar.inputTextView.delegate = self;
    }
    return _inputBar;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"545454"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"js_alert_cancel"] forState:UIControlStateNormal];
        _closeButton.size = CGSizeMake(30, 30);
        @weakify(self)
        [_closeButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            
            [self hiddenCommentView];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIView *)commentView{
    if (!_commentView) {
        _commentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, self.height/4.0f * 3.0f)];
        _commentView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_commentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.frame = _commentView.bounds;
        
        maskLayer.path = maskPath.CGPath;
        
        _commentView.layer.mask = maskLayer;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [self.commentView addGestureRecognizer:pan];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
        swipe.direction = UISwipeGestureRecognizerDirectionDown;
        swipe.delegate = self;
        [self.commentView addGestureRecognizer:swipe];
        [swipe requireGestureRecognizerToFail:pan];
        

    }
    return _commentView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.commentView];
        
        [self.commentView addSubview:self.titleLabel];
        [self.commentView addSubview:self.closeButton];
        [self.commentView addSubview:self.commentTableView];
        [self.commentView addSubview:self.inputBar];
        [[YYTextKeyboardManager defaultManager] addObserver:self];
        
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.equalTo(self.commentView).offset(-10);
            make.top.equalTo(self.commentView).offset(10);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 30));
            make.top.equalTo(self.commentView).offset(10);
            make.centerX.equalTo(self.commentView);
        }];
        
        [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.commentView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.commentView).offset(-50);
        }];
        
        self.inputBar.frame = CGRectMake(0, self.commentView.height - 50, self.commentView.width, 50);
    }
    return self;
}

- (void)showCommentView{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimation.toValue = @(self.commentView.height/2.0f + self.height/4.0f);
    springAnimation.springSpeed = 15;
    springAnimation.springBounciness = 6;
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            self.originalTop = self.commentView.top;
            
        }
    };
    [self.commentView pop_addAnimation:springAnimation forKey:@"js_show_springAnimation"];
}
- (void)hiddenCommentView{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimation.toValue = @(self.commentView.height/2.0f + self.height);
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self endEditing:YES];
            [self removeFromSuperview];
        }
    };
    springAnimation.springSpeed = 15;
    springAnimation.springBounciness = 6;
    [self.commentView pop_addAnimation:springAnimation forKey:@"js_hidden_springAnimation"];
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        [self showCommentView];
        self.inputBar.commentModel = nil;
        
    }
}
- (void)refreshDataListWithHeaderRefresh:(BOOL)isHeaderRefresh{
    if (isHeaderRefresh) {
        self.currentPage = 1;
        [self.commentList removeAllObjects];
    }else{
        self.currentPage ++;
    }
    [JSNetworkManager requestVideoCommentDataWithArticleId:self.videoModel.articleId.integerValue pageNumber:self.currentPage complement:^(BOOL isSuccess, NSArray * _Nonnull commentList, NSInteger totolNumber) {
        [self.commentTableView.mj_header endRefreshing];
        [self.commentTableView.mj_footer endRefreshing];
        if (isSuccess) {
            self.totolNumber = totolNumber;
            self.titleLabel.text = [NSString stringWithFormat:@"一共收到%@条评论",@(self.totolNumber)];
            
            [self.commentList addObjectsFromArray:commentList];
            
            if (commentList.count < 10) {
                [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.commentTableView reloadData];
            
        }else{
            
            if (isHeaderRefresh) {
                
            }else{
                self.currentPage -- ;
            }
        }
    }];
}
+ (void)showCommentViewWithSuperView:(UIView *)superView authModel:(JSShortVideoModel *)model{
    
    JSCommentView *commentView = [[JSCommentView alloc]initWithFrame:superView.bounds];
    commentView.videoModel = model;
    [superView addSubview:commentView];
    [commentView.commentTableView.mj_header beginRefreshing];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.inputBar.inputTextView isFirstResponder]) {
        [self endEditing:YES];
    }else{
        CGPoint point = [[touches anyObject] locationInView:self];
        point = [self.commentView.layer convertPoint:point fromLayer:self.layer];
        if (![self.commentView.layer containsPoint:point]) {
            [self hiddenCommentView];
        }
    }
}


- (void)pan:(UIPanGestureRecognizer *)sender{
    CGPoint point= [sender locationInView:self];// 上下控制点
    
    CGPoint velocity = [sender velocityInView:self];
    
    BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            
            _currentPoint = point;
        }break;
        case UIGestureRecognizerStateChanged: {
            if (isVerticalGesture) {
                
                if (self.commentView.top - (_currentPoint.y - point.y) < self.originalTop) {
                    self.commentView.top = self.originalTop;
                }else if (self.commentView.top - (_currentPoint.y - point.y) > self.height){
                    self.commentView.top = self.height;
                }
                else{
                    self.commentView.top -= _currentPoint.y - point.y;
                }
                
            }
            _currentPoint = point;
            
        }break;
        case UIGestureRecognizerStateEnded: {
            [self showCommentView];
        }break;
        default:
            
            break;
    }
}

- (void)swipe:(UISwipeGestureRecognizer *)sender{
    [self hiddenCommentView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    JSCommentModel *model = self.commentList[section];
    return model.replyList.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    JSCommentModel *model = self.commentList[indexPath.section];
    if (indexPath.row == 0) {
        JSCommentViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"JSCommentViewCell" forIndexPath:indexPath];
        commentCell.commentModel = model;
        cell = commentCell;
    }else{
        JSCommentViewSubCell *subCell = [tableView dequeueReusableCellWithIdentifier:@"JSCommentViewSubCell" forIndexPath:indexPath];
        subCell.commentModel = model.replyList[indexPath.row - 1];
        cell = subCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSCommentModel *model = self.commentList[indexPath.section];
    if (indexPath.row == 0) {
        return [JSCommentViewCell heightForModel:model];
    }
    return [JSCommentViewSubCell heightForModel:model.replyList[indexPath.row -1]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JSCommentModel *model = self.commentList[indexPath.section];
    if (indexPath.row == 0) {
        self.inputBar.commentModel = model;
    }else{
        self.inputBar.commentModel = model.replyList[indexPath.row - 1];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
        
        if (fabs(point.y) > 500) {
            return NO;
        }
        return YES;
    }
    return YES;
}
#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView{
    CGRect frame = self.inputBar.frame;
    if (textView.contentSize.height > 30) {
        CGRect changedFrame = CGRectMake(frame.origin.x, frame.origin.y - (textView.contentSize.height + 20 - frame.size.height), frame.size.width, textView.contentSize.height + 20);
        self.inputBar.frame = changedFrame;
    }else{
        CGRect changedFrame = CGRectMake(frame.origin.x, frame.origin.y + (frame.size.height - 50), frame.size.width, 50);
        self.inputBar.frame = changedFrame;
    }
}


- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        //提交评论
        NSDictionary *dict = nil;
        if (self.inputBar.commentModel) {
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
            
            dict = @{@"token":token,@"articleId":@(self.inputBar.commentModel.articleId),@"content":[self.inputBar.inputTextView.text stringByURLEncode],@"replyCommentId":@(self.inputBar.commentModel.commentId),@"replyUserId":@(self.inputBar.commentModel.userId)};
        }else{
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
            dict = @{@"token":token,@"articleId":self.videoModel.articleId,@"content":[self.inputBar.inputTextView.text stringByURLEncode]};
        }
        [JSNetworkManager addComment:dict complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
            if (isSuccess) {
                self.inputBar.inputTextView.text = @"";
                [self.inputBar.inputTextView resignFirstResponder];
                [self.commentTableView.mj_header beginRefreshing];
            }
        }];
        
        return NO;
    }
//    else if (str.length > 50) {
//        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:50];
//        if (rangeIndex.length == 1)//字数超限
//        {
//            textView.text = [str substringToIndex:50];
//            //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
//            //            self.textNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)textView.text.length];
//
//        }else{
//            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 50)];
//            textView.text = [str substringWithRange:rangeRange];
//
//        }
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//
//        hud.mode = MBProgressHUDModeText;
//        hud.label.text = @"限制50个字符之内";
//        [hud hideAnimated:YES afterDelay:2.f];
//        return NO;
//
//    }
    return YES;
}

#pragma mark - YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    //    [self.inputToolbar controlInputViewWithFirstResponder:[self.inputToolbar gg_isFirstResponder]];
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.commentView];
    if (transition.animationDuration == 0) {
        self.inputBar.bottom = CGRectGetMinY(toFrame);
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.inputBar.bottom = CGRectGetMinY(toFrame);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
@end

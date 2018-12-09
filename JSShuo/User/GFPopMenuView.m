//
//  GFPopMenuView.m
//  GetFun
//
//  Created by liupeng on 16/4/9.
//  Copyright © 2016年 17GetFun. All rights reserved.
//

#import "GFPopMenuView.h"
//#import "GGSharePushNewModel.h"
#import <POP.h>

//#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static const NSInteger kMaxCountPerRow = 3;
static const CGFloat kItemSpace = 44.0f;
static const CGFloat kLineSpace = 27.0f;
static const CGFloat kPadding = 44.0f;
static const CGFloat kBottomOffset = 100.0f; //下方不可点击区域高度，同时也是多个按钮最下方
static const CGFloat kPopMenuPadding = 10;

static NSString *kScaleKeyPath = @"transform.scale";
static const NSTimeInterval kItemsDelay = 0.25f;
static const NSTimeInterval kViewDuration = 0.15f;
static const NSTimeInterval kSelectDuration = 0.25f;

#pragma mark

@interface GFPopMenuItem : UIButton

@property (nonatomic, assign) NSUInteger positionIndex;

+ (instancetype)menuItemWithImage:(UIImage *)image title:(NSString *)title;
- (void)selectAnimation;
- (void)cancelAnimation;

@end

@implementation GFPopMenuItem
+ (instancetype)menuItemWithImage:(UIImage *)image title:(NSString *)title {
    GFPopMenuItem *item = [[GFPopMenuItem alloc] initWithFrame:CGRectZero];
    [item setImage:image forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateNormal];
    return item;
}

- (instancetype) initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        
        [self addTarget:self action:@selector(scaleToSmall) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(scaleToDefault) forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}

- (void)scaleToSmall {
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:kScaleKeyPath];
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1];
    theAnimation.toValue = [NSNumber numberWithFloat:1.1f];
    [self.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

- (void)scaleToDefault {
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:kScaleKeyPath];
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1.1f];
    theAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

- (void)opacityToDefault {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.1;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = FALSE;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @0;
    opacityAnimation.toValue = @1;
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
}

- (void)selectAnimation {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:kScaleKeyPath];
    scaleAnimation.duration = 0.2;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = FALSE;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @1.3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.2;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = FALSE;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    [self.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
}

- (void)cancelAnimation {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:kScaleKeyPath];
    scaleAnimation.duration = 0.2;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = FALSE;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @0.3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.2;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = FALSE;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    [self.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageX = 0;
    CGFloat imageHeight = imageWidth;
    CGFloat imageY = 0;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleHeight = 15;
    CGFloat titleY = contentRect.size.height - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX,titleY, titleWidth, titleHeight);
}

@end
@class GFPopMenuContentView;
@protocol GFPopMenuContentViewDelegate <NSObject>
- (void)popMenuContentView:(GFPopMenuContentView *)popMenuContentView clickItemAtIndex:(NSUInteger)itemIndex;
@end
@interface GFPopMenuContentView:UIView
@property (nonatomic, copy) NSArray<GFPopMenuItem *> *menuItems; //按钮集合
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, weak)id <GFPopMenuContentViewDelegate>delegate;
@property (nonatomic, strong)id model;
@property (nonatomic, strong)UILabel *shareUITitleLabel;
@property (nonatomic, strong)UILabel *shareUIContentLabel;
@property (nonatomic, strong)CAShapeLayer *linelayer1;
@property (nonatomic, strong)CAShapeLayer *linelayer2;
@end
@implementation GFPopMenuContentView

- (CAShapeLayer *)linelayer1{
    if (!_linelayer1) {
        _linelayer1 = [[CAShapeLayer alloc]init];
        _linelayer1.size = CGSizeMake(self.width, 0.5);
        _linelayer1.backgroundColor = [[UIColor colorWithHexString:@"eeeeee"]CGColor];
    }
    return _linelayer1;
}
- (CAShapeLayer *)linelayer2{
    if (!_linelayer2) {
        _linelayer2 = [[CAShapeLayer alloc]init];
        _linelayer2.size = CGSizeMake(self.width, 0.5);
        _linelayer2.backgroundColor = [[UIColor colorWithHexString:@"eeeeee"]CGColor];
    }
    return _linelayer2;
}
- (UILabel *)shareUITitleLabel{
    if (!_shareUITitleLabel) {
        _shareUITitleLabel = [[UILabel alloc]init];
        _shareUITitleLabel.size = CGSizeMake(self.width - kPopMenuPadding*2, 20);
        _shareUITitleLabel.font = [UIFont systemFontOfSize:16];
        _shareUITitleLabel.textColor = [UIColor colorWithHexString:@"F34444"];
    }
    return _shareUITitleLabel;
}
- (UILabel *)shareUIContentLabel{
    if (!_shareUIContentLabel) {
        _shareUIContentLabel = [[UILabel alloc]init];
        _shareUIContentLabel.font = [UIFont systemFontOfSize:15];
        _shareUIContentLabel.textColor = [UIColor colorWithHexString:@"F34444"];
        _shareUIContentLabel.numberOfLines = 0;
    }
    return _shareUIContentLabel;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _titleLabel.text = @"选择分享方式";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _cancelButton.size = CGSizeMake(self.width, 40);
    }
    return _cancelButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.shareUITitleLabel];
        [self addSubview:self.shareUIContentLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.cancelButton];
        [self.layer addSublayer:self.linelayer1];
        [self.layer addSublayer:self.linelayer2];
        [self constraintSubViews];
    }
    return self;
}
- (void)bindModel:(id)model{
    _model = model;
    [self constraintSubViews];
}
- (void)constraintSubViews{
    CGFloat itemW = 50;
    CGFloat itemH = itemW + 10 + 15 ;
//    if ([self.model isKindOfClass:[GGSharePushNewShareUIModel class]]) {
//        GGSharePushNewShareUIModel *UIModel = (GGSharePushNewShareUIModel *)self.model;
//        self.shareUIContentLabel.hidden = self.shareUITitleLabel.hidden = NO;
//        CGFloat contentHeight = [UIModel.shareUIContent heightForFont:self.shareUIContentLabel.font width:self.width-2*kPopMenuPadding];
//        self.shareUIContentLabel.text = UIModel.shareUIContent;
//        self.shareUIContentLabel.size = CGSizeMake(self.width-2*kPopMenuPadding, contentHeight);
//        self.shareUITitleLabel.text = UIModel.shareUITitle;
//        self.size = CGSizeMake(self.width, kPopMenuPadding + self.shareUITitleLabel.height + kPopMenuPadding + self.shareUIContentLabel.height + kPopMenuPadding + kPopMenuPadding + 20 + kPopMenuPadding*2 + itemH + kPopMenuPadding*2 + 40);
//        self.shareUITitleLabel.left = kPopMenuPadding;
//        self.shareUITitleLabel.top = kPopMenuPadding;
//        self.shareUIContentLabel.left = self.shareUITitleLabel.left;
//        self.shareUIContentLabel.top = self.shareUITitleLabel.bottom + kPopMenuPadding;
//        self.titleLabel.left = self.shareUITitleLabel.left;
//
//        self.titleLabel.top = self.shareUIContentLabel.bottom + kPopMenuPadding * 2;
//        self.cancelButton.bottom = self.height - kPopMenuPadding;
//        self.cancelButton.left = 0;
//
//        self.linelayer1.top = self.titleLabel.top - kPopMenuPadding;
//        self.linelayer1.left = 0;
//
//        self.linelayer2.top = self.cancelButton.top;
//        self.linelayer2.left = 0;
//    }else{
    unsigned long maxLine = self.menuItems.count <= 3 ? 1 : 2;
    
        self.shareUIContentLabel.hidden = self.shareUITitleLabel.hidden = YES;
        self.size = CGSizeMake(self.width, kPopMenuPadding + 20 + kPopMenuPadding*2 + (itemH + kPopMenuPadding)*(maxLine) + kPopMenuPadding + 40);
        self.titleLabel.left = kPopMenuPadding;
        self.titleLabel.top = kPopMenuPadding;
        self.cancelButton.bottom = self.height - kPopMenuPadding;
        self.cancelButton.left = 0;
        
        self.linelayer1.top = self.titleLabel.top - kPopMenuPadding;
        self.linelayer1.left = 0;
        
        self.linelayer2.top = self.cancelButton.top;
        self.linelayer2.left = 0;
//    }
    
}
- (void)setMenuItems:(NSArray<GFPopMenuItem *> *)menuItems {
    _menuItems = [menuItems copy];
    @weakify(self)
    for (GFPopMenuItem *menuItem in _menuItems) {
        [menuItem bk_addEventHandler:^(id sender) {
            GFPopMenuItem *tapItem = (GFPopMenuItem *)sender;
            @strongify(self)
            //点击和非点击的均进行动画
            [self.menuItems bk_each:^(id obj) {
                GFPopMenuItem *item = (GFPopMenuItem *)obj;
                if(item == tapItem) {
                    [item selectAnimation];
                } else {
                    [item cancelAnimation];
                }
            }];
            
            //点击后视图隐藏
            [self dismissDuration:kViewDuration completion:^() {
                [self.superview removeFromSuperview];
                if ([self.delegate respondsToSelector:@selector(popMenuContentView:clickItemAtIndex:)]) {
                    [self.delegate popMenuContentView:self clickItemAtIndex:tapItem.positionIndex];
                }
            }];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
}
// 隐藏整体视图
- (void)dismissDuration:(NSTimeInterval)duration completion:(void(^)(void))completion {
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    anim.toValue = @(0.0f);
    anim.duration = duration;
    anim.removedOnCompletion = YES;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (completion) {
            completion();
        }
    };
    [self pop_addAnimation:anim forKey:@"alpha"];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        [self presentMenuItems];
    }
}
#pragma mark - 各个功能按钮显示和消失
- (void)presentMenuItems {
    
    CGFloat itemW = 50;
    CGFloat itemH = itemW + 10 + 15 ;
    CGFloat tap = 50;
    int number = (int)MIN(3, self.menuItems.count);
//    CGFloat kPadding = (self.width - itemW * number - tap * (number - 1))/2.0f;
    CGFloat kPadding = tap = (self.width - itemW * number)/(number + 1);
    unsigned long maxLine = self.menuItems.count <= 3 ? 1 : 2;
    
    for (int i=0; i<self.menuItems.count; i++) {
        GFPopMenuItem *item = self.menuItems[i];
        CGFloat itemX, itemY;
        itemX = (i % number) * (itemW + tap) + kPadding;
        itemY = self.height - kPopMenuPadding - (kPopMenuPadding + itemH) * (maxLine - i/3) - 40;
        CGRect fromValue = CGRectMake(itemX, self.height, itemW, itemH);
        CGRect toValue = CGRectMake(itemX, itemY, itemW, itemH);
        
        item.alpha = 0.0f;
        
        [self addSubview:item];
        item.frame = fromValue;
        NSTimeInterval delayInterval = (1.0f * i / self.menuItems.count) * kItemsDelay;
        CFTimeInterval delay = delayInterval + CACurrentMediaTime();
        [self animateItem:item fromValue:fromValue toValue:toValue delay:delay speed:20.0f completion:NULL hide:NO];
    }
    
//    for (GFPopMenuItem *item in self.menuItems) {
//        CGFloat itemX, itemY;
//        itemX = (item.positionIndex % 3) * (itemW + tap) + kPadding;
//        itemY = self.height - kPopMenuPadding *2 - itemH - 40;
//        CGRect fromValue = CGRectMake(itemX, self.height, itemW, itemH);
//        CGRect toValue = CGRectMake(itemX, itemY, itemW, itemH);
//
//        item.alpha = 0.0f;
//
//        [self addSubview:item];
//        item.frame = fromValue;
//        NSTimeInterval delayInterval = (1.0f * item.positionIndex / self.menuItems.count) * kItemsDelay;
//        CFTimeInterval delay = delayInterval + CACurrentMediaTime();
//        [self animateItem:item fromValue:fromValue toValue:toValue delay:delay speed:20.0f completion:NULL hide:NO];
//    }
}

- (void)hideMenuItemsCompletion:(void(^)(void))completion {
    
    CGFloat itemW = 50;
    CGFloat itemH = itemW + 10 + 15 ;
    CGFloat tap = 50;
    int number = (int)MIN(3, self.menuItems.count);
//    CGFloat kPadding = (self.width - itemW * number - tap * (number-1))/2.0f;
    CGFloat kPadding = tap = (self.width - itemW * number)/(number + 1);
    unsigned long maxLine = self.menuItems.count <= 3 ? 1 : 2;
    
    for (int i=0; i<self.menuItems.count; i++) {
        GFPopMenuItem *item = self.menuItems[i];
        CGFloat itemX, itemY;
        itemX = (i % number) * (itemW + tap) + kPadding;
        itemY = self.height - kPopMenuPadding - (kPopMenuPadding + itemH) * (maxLine - i/3) - 40;
        
        CGRect toValue = CGRectMake(itemX, self.height, itemW, itemH);
        CGRect fromValue = CGRectMake(itemX, itemY, itemW, itemH);
        
        NSTimeInterval delayInterval = ((self.menuItems.count - item.positionIndex * 1.0f) / self.menuItems.count) * kItemsDelay;
        CFTimeInterval delay = delayInterval + CACurrentMediaTime();
        [self animateItem:item fromValue:fromValue toValue:toValue delay:delay speed:100.0f completion:^(BOOL finished) {
//            if ([self.model isKindOfClass:[GGControlModel class]]) {
//                if (item.positionIndex == 1 && completion) {  // positionIndex=1的隐藏了，说明所有按钮均已隐藏
//                    completion();
//                }
//            }else{
                if (item.positionIndex == 0 && completion) {  // positionIndex=1的隐藏了，说明所有按钮均已隐藏
                    completion();
                }
//            }
            
        } hide:YES];
    }
    
//    for (GFPopMenuItem *item in self.menuItems) {
//        CGFloat itemX, itemY;
//        itemX = (item.positionIndex % 3) * (itemW + tap) + kPadding;
//        itemY = self.height -  kPopMenuPadding *2 - itemH - 40;
//
//        CGRect toValue = CGRectMake(itemX, self.height, itemW, itemH);
//        CGRect fromValue = CGRectMake(itemX, itemY, itemW, itemH);
//
//        NSTimeInterval delayInterval = ((self.menuItems.count - item.positionIndex * 1.0f) / self.menuItems.count) * kItemsDelay;
//        CFTimeInterval delay = delayInterval + CACurrentMediaTime();
//        [self animateItem:item fromValue:fromValue toValue:toValue delay:delay speed:100.0f completion:^(BOOL finished) {
//            if ([self.model isKindOfClass:[GGControlModel class]]) {
//                if (item.positionIndex == 1 && completion) {  // positionIndex=1的隐藏了，说明所有按钮均已隐藏
//                    completion();
//                }
//            }else{
//                if (item.positionIndex == 0 && completion) {  // positionIndex=1的隐藏了，说明所有按钮均已隐藏
//                    completion();
//                }
//            }
//
//        } hide:YES];
//    }
}
#pragma mark - item出现、消失动画
- (void)animateItem:(GFPopMenuItem *)item
          fromValue:(CGRect)fromValue
            toValue:(CGRect)toValue
              delay:(CFTimeInterval)delay
              speed:(CGFloat)speed
         completion:(void(^) (BOOL completion))completionBlock
               hide:(BOOL)hide {
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = delay;
    CGFloat springBounciness = 10.f;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    CGFloat springSpeed = speed;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toValue];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromValue];
    
    POPSpringAnimation *SpringAnimationAlpha = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    SpringAnimationAlpha.removedOnCompletion = YES;
    SpringAnimationAlpha.beginTime = delay;
    SpringAnimationAlpha.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat toV,fromV;
    if (hide) {
        fromV = 1.0f;
        toV = 0.0f;
    }else{
        fromV = 0.0f;
        toV = 1.0f;
    }
    
    SpringAnimationAlpha.springSpeed = springSpeed;     // value between 0-20
    SpringAnimationAlpha.toValue = @(toV);
    SpringAnimationAlpha.fromValue = @(fromV);
    
    [item pop_addAnimation:SpringAnimationAlpha forKey:SpringAnimationAlpha.name];
    [item pop_addAnimation:springAnimation forKey:springAnimation.name];
    [springAnimation setCompletionBlock:^(POPAnimation *spring, BOOL finished) {
        if (completionBlock) {
            completionBlock(finished);
        }
    }];
}

@end
#pragma mark
@interface GFPopMenuView ()<GFPopMenuContentViewDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) GFPopMenuContentView *contentView;

@end

@implementation GFPopMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
//    GGMainViewController *mainVC = [AppDelegate instance].mainViewController;
//    RTRootNavigationController *currentNav = mainVC.selectedViewController;
//    BaseUIViewController *currentVC = (BaseUIViewController *)currentNav.rt_topViewController;
//
//    //判断视频详情页
//    Class videoVC = NSClassFromString(@"GGVideoDetailViewController");
//    Class liveVC = NSClassFromString(@"GGNewLiveRoomViewController");
//
//    if ([currentVC isKindOfClass:videoVC] || [currentVC isKindOfClass:liveVC]) {
//        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
//            if (self.superview) {
//                [self removeFromSuperview];
//            }
//        }
//    }
}
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.5;
    }
    return _backgroundView;
}
- (GFPopMenuContentView *)contentView{
    if (!_contentView) {
        _contentView = [[GFPopMenuContentView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _contentView.delegate = self;
        @weakify(self)
        [_contentView.cancelButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            [self.contentView hideMenuItemsCompletion:^{
                [self.contentView dismissDuration:kViewDuration completion:^{
                    [self removeFromSuperview];
                }];
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _contentView;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        self.contentView.bottom = self.height;
        [self addSubview:self.backgroundView];
        [self addSubview:self.contentView];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [self.contentView.layer convertPoint:point fromLayer:self.layer];
    
    if (![self.contentView.layer containsPoint:point]) {
        @weakify(self)
        [self.contentView hideMenuItemsCompletion:^{
            @strongify(self)
            [self.contentView dismissDuration:kViewDuration completion:^{
                [self removeFromSuperview];
            }];
        }];
    }
}
+ (void)showInView:(UIView *)view hander:(id)model delegate:(id<GFPopMenuViewDelegate>)delegate; {
    
    NSMutableArray<GFPopMenuItem *> *items = [[NSMutableArray alloc] initWithCapacity:0];
//    {
//        UIImage *img = [UIImage imageNamed:@"icon_l_qzone_normal"];
//        GFPopMenuItem *item = [GFPopMenuItem menuItemWithImage:img title:@"QQ空间"];
//        item.positionIndex = 0;
//        [items addObject:item];
//    }
    {
        UIImage *img = [UIImage imageNamed:@"icon_l_qq_normal"];
        GFPopMenuItem *item = [GFPopMenuItem menuItemWithImage:img title:@"QQ"];
        item.positionIndex = 0;
        [items addObject:item];
    }
    {
        UIImage *img = [UIImage imageNamed:@"icon_l_wechat_session_normal"];
        GFPopMenuItem *item = [GFPopMenuItem menuItemWithImage:img title:@"微信"];
        item.positionIndex = 1;
        [items addObject:item];
    }
    
    {
        UIImage *img = [UIImage imageNamed:@"icon_l_wechat_timeline_normal"];
        GFPopMenuItem *item = [GFPopMenuItem menuItemWithImage:img title:@"朋友圈"];
        item.positionIndex = 2;
        [items addObject:item];
    }
    {
        UIImage *img = [UIImage imageNamed:@"icon_l_sinaweibo_normal"];
        GFPopMenuItem *item = [GFPopMenuItem menuItemWithImage:img title:@"短信"];
        item.positionIndex = 3;
        [items addObject:item];
    }
    
    GFPopMenuView *popMenuView = [[GFPopMenuView alloc] initWithFrame:view.bounds];
    popMenuView.contentView.menuItems = items;
    [popMenuView.contentView bindModel:model];
    popMenuView.delegate = delegate;
    [view addSubview:popMenuView];
}

#pragma mark - GFPopMenuContentViewDelegate

- (void)popMenuContentView:(GFPopMenuContentView *)popMenuContentView clickItemAtIndex:(NSUInteger)itemIndex{
    if ([self.delegate respondsToSelector:@selector(popMenu:clickItemAtIndex:)]) {
        [self.delegate popMenu:self clickItemAtIndex:itemIndex];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end

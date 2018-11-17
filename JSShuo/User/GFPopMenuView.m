//
//  GFPopMenuView.m
//  GetFun
//
//  Created by liupeng on 16/4/9.
//  Copyright © 2016年 17GetFun. All rights reserved.
//

#import "GFPopMenuView.h"

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
        [self setTitleColor:[UIColor colorWithIndex:1] forState:UIControlStateNormal];
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

#pragma mark

@interface GFPopMenuView ()

@property (nonatomic, strong) UIView *blurView; //模糊背景图
@property (nonatomic, strong) UIView *tapView; //可点击触发收起动画的背景图
@property (nonatomic, copy) NSArray<GFPopMenuItem *> *menuItems; //按钮集合

@end

@implementation GFPopMenuView
- (UIView *)blurView {
    if (!_blurView) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _blurView = [[[UIVisualEffectView alloc] initWithEffect:blurEffect] contentView];
        _blurView.frame = CGRectMake(0, 0, size.width, size.height);
        _blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        _blurView.backgroundColor = [UIColor colorWithRed:169/255.0f green:169/255.0f blue:169/255.0f alpha:0.5];
        
    }
    return _blurView;
}

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight- kBottomOffset)];
    }
    return _tapView;
}

- (void)setMenuItems:(NSArray<GFPopMenuItem *> *)menuItems {
    _menuItems = [menuItems copy];
    @weakify(self)
    for (GFPopMenuItem *menuItem in _menuItems) {
        [menuItem bk_addEventHandler:^(id sender) {
            GFPopMenuItem *tapItem = (GFPopMenuItem *)sender;
            @strongify(self)
            //点击和非点击的均进行动画
            [self->_menuItems bk_each:^(id obj) {
                GFPopMenuItem *item = (GFPopMenuItem *)obj;
                if(item == tapItem) {
                    [item selectAnimation];
                } else {
                    [item cancelAnimation];
                }
            }];
            
            //点击后视图隐藏
            [self dismissDuration:kSelectDuration completion:^() {
                [self removeFromSuperview];
            }];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(popMenu:clickItemAtIndex:)]) {
                [self.delegate popMenu:self clickItemAtIndex:tapItem.positionIndex];
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //添加顶部视图
        [self addSubview:self.blurView];
        [self.blurView addSubview:self.tapView];
        
        @weakify(self)
        [self.tapView bk_whenTapped:^{
            @strongify(self)
            [self hideMenuItemsCompletion:^() {
                [self dismissDuration:kViewDuration completion:^() {
                    [self removeFromSuperview];
                }];
            }];
        }];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        [self presentMenuItems];
    }
}

+ (void)showInView:(UIView *)view delegate:(id<GFPopMenuViewDelegate>)delegate {
    
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
//    {
//        UIImage *img = [UIImage imageNamed:@"icon_l_wechat_timeline_normal"];
//        GFPopMenuItem *item = [GFPopMenuItem menuItemWithImage:img title:@"朋友圈"];
//        item.positionIndex = 2;
//        [items addObject:item];
//    }
//    {
//        UIImage *img = [UIImage imageNamed:@"icon_l_sinaweibo_normal"];
//        GFPopMenuItem *item = [GFPopMenuItem menuItemWithImage:img title:@"微博"];
//        item.positionIndex = 4;
//        [items addObject:item];
//    }
    
    GFPopMenuView *popMenuView = [[GFPopMenuView alloc] initWithFrame:view.bounds];
    popMenuView.menuItems = items;
    popMenuView.delegate = delegate;
    [view addSubview:popMenuView];
}

#pragma mark - 各个功能按钮显示和消失
- (void)presentMenuItems {    
    CGFloat itemW = 50;
    CGFloat itemH = itemW + 10 + 15 ;
    CGFloat tap = 50;
    int number = (int)MIN(3, self.menuItems.count);
    
    CGFloat kPadding = tap = (self.width - itemW * number)/(number + 1);
    
    for (GFPopMenuItem *item in self.menuItems) {
        
        CGFloat itemX, itemY;
        itemX = (item.positionIndex % number) * (itemW + tap) + kPadding;
        itemY = self.height - kPopMenuPadding *2 - itemH - 40;
        CGRect fromValue = CGRectMake(itemX, self.height, itemW, itemH);
        CGRect toValue = CGRectMake(itemX, itemY, itemW, itemH);
        item.alpha = 0.0f;
        
        [self.blurView addSubview:item];
        item.frame = fromValue;
        NSTimeInterval delayInterval = (1.0f * item.positionIndex / self.menuItems.count) * kItemsDelay;
        CFTimeInterval delay = delayInterval + CACurrentMediaTime();
        [self animateItem:item fromValue:fromValue toValue:toValue delay:delay speed:20.0f completion:NULL hide:NO];
    }
}

- (void)hideMenuItemsCompletion:(void(^)(void))completion {
    
//    NSUInteger maxCount = 6;
    CGFloat itemW = 50;//floorf((kScreenWidth - kPadding * 2 - (kMaxCountPerRow - 1) * kItemSpace)/kMaxCountPerRow);
    CGFloat itemH = itemW + 10.0f + 15.0f;
    
    CGFloat tap = 50;
    int number = (int)MIN(3, self.menuItems.count);
    CGFloat kPadding = tap = (self.width - itemW * number)/(number + 1);
    
    
    for (GFPopMenuItem *item in self.menuItems) {
        CGFloat itemX, itemY;
        
        itemX = (item.positionIndex % number) * (itemW + tap) + kPadding;
        itemY = self.height -  kPopMenuPadding *2 - itemH - 40;
        
        CGRect toValue = CGRectMake(itemX, self.height, itemW, itemH);
        CGRect fromValue = CGRectMake(itemX, itemY, itemW, itemH);
        
        NSTimeInterval delayInterval = ((self.menuItems.count - item.positionIndex * 1.0f) / self.menuItems.count) * kItemsDelay;
        CFTimeInterval delay = delayInterval + CACurrentMediaTime();
        [self animateItem:item fromValue:fromValue toValue:toValue delay:delay speed:100.0f completion:^(BOOL finished) {
            if (item.positionIndex == 0 && completion) {  // positionIndex=1的隐藏了，说明所有按钮均已隐藏
                completion();
            }
        } hide:YES];
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
    [self.blurView pop_addAnimation:anim forKey:@"alpha"];
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

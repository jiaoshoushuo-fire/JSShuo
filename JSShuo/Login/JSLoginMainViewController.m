//
//  JSLoginViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/2.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSLoginMainViewController.h"
#import <WMPageController.h>
#import "JSLoginViewController.h"
#import "JSRegisterViewController.h"

@interface JSLoginMainHeaderView : UIView
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation JSLoginMainHeaderView

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"js_login_icon"];
        [_iconImageView sizeToFit];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"登录";
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _titleLabel.font = [UIFont systemFontOfSize:22];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(68, 68));
            make.top.equalTo(self);
            make.centerX.equalTo(self);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(68, 30));
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self.iconImageView.mas_centerX);
        }];
    }
    return self;
}



@end

@interface JSLoginMainViewController ()<WMPageControllerDelegate,WMPageControllerDataSource,JSLoginViewControllerDelegate>
@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) NSArray *topTitles;
@property (nonatomic, strong) NSArray *subVCs;
@property (nonatomic, strong) JSLoginMainHeaderView *headerView;

//@property (nonatomic, strong) JSLoginViewController *loginVC;
@property (nonatomic, strong) JSRegisterViewController *registerVC;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation JSLoginMainViewController

- (NSArray *)topTitles{
    if (!_topTitles) {
//        _topTitles = @[@"账号登录",@"新人注册"];
        _topTitles = @[@""];
    }
    return _topTitles;
}
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"js_login_close"] forState:UIControlStateNormal];
        @weakify(self)
        [_closeButton bk_addEventHandler:^(id sender) {
            @strongify(self)
             @weakify(self)
            [self.rt_navigationController dismissViewControllerAnimated:YES completion:^{
                @strongify(self)
                if (self.loginComplementBlock) {
                    self.loginComplementBlock(NO);
                }
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
//- (JSLoginViewController *)loginVC{
//    if (!_loginVC) {
//        _loginVC = [[JSLoginViewController alloc]init];
//        _loginVC.delegate = self;
//    }
//    return _loginVC;
//}
- (JSRegisterViewController *)registerVC{
    if (!_registerVC) {
        _registerVC = [[JSRegisterViewController alloc]init];
        _registerVC.delegate = self;
    }
    return _registerVC;
}
- (NSArray *)subVCs{
    if (!_subVCs) {
//        _subVCs = @[self.loginVC,self.registerVC];
        _subVCs = @[self.registerVC];
    }
    return _subVCs;
}
- (JSLoginMainHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[JSLoginMainHeaderView alloc]initWithFrame:CGRectMake(0, 0, 70, 108)];
    }
    return _headerView;
}

- (WMPageController *)pageController{
    if (!_pageController) {
        
        NSMutableArray *progressWidths = [NSMutableArray array];
        for (NSString *title in self.topTitles) {
            CGFloat width = [title widthForFont:[UIFont systemFontOfSize:16]];
            [progressWidths addObject:@(width)];
        }
        _pageController = [[WMPageController alloc]init];
        _pageController.menuViewStyle = WMMenuViewStyleLine;
        _pageController.menuView.lineColor = [UIColor colorWithHexString:@"E81D2D"];
        _pageController.progressViewWidths = progressWidths;
        _pageController.menuItemWidth = kScreenWidth/2.0f;
        _pageController.titleColorNormal = [UIColor colorWithHexString:@"8D8D8D"];
        _pageController.titleSizeNormal = 16;
        _pageController.titleColorSelected = [UIColor colorWithHexString:@"546D86"];
        _pageController.titleSizeSelected = 16;
        _pageController.bounces = NO;
        _pageController.delegate = self;
        _pageController.dataSource = self;
        _pageController.selectIndex = 0;
    }
    return _pageController;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.headerView];
    
    
    [self addChildViewController:self.pageController];
    self.pageController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pageController.view];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 108));
        CGFloat tap = 80;
        if (kScreenWidth == 320) {
            tap = 64;
        }
        make.top.equalTo(self.view).offset(tap);
        make.centerX.equalTo(self.view);
    }];
    
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(26);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.view).offset(20);
        make.right.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.registerVC stopTimerIfNeed];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.topTitles.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index < 0 || index > self.topTitles.count - 1) {
        return nil;
    }

    
    return self.subVCs[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    return self.topTitles[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, self.view.width, 2);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = 2;
    return CGRectMake(0, originY, self.view.width, self.pageController.view.height - originY);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController * _Nonnull)viewController withInfo:(NSDictionary * _Nonnull)info{
    
}

#pragma mark - JSLoginViewControllerDelegate
- (void)didSelectedPageControllerWithIndex:(int)index{
    self.pageController.selectIndex = index;
}
- (void)didLoginSuccessComplement{
    @weakify(self)
    [self.rt_navigationController dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        //放送登陆成功通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSuccessNotification object:nil];
        if (self.loginComplementBlock) {
            self.loginComplementBlock(YES);
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

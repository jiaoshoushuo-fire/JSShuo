//
//  JSInvitationViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/14.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSInvitationViewController.h"
#import "JSAdjustButton.h"
#import "JSNetworkManager+Login.h"
#import <WMPageController.h>
#import "JSInvitationSubViewController.h"
#import "JSInvitationSubListViewController.h"
#import "JSInvitationSubAweakViewController.h"
#import "JSMyApprenticeViewController.h"
#import "JSShareManager.h"

#import "HJTabViewControllerPlugin_HeaderScroll.h"
#import "HJTabViewControllerPlugin_TabViewBar.h"
#import "HJDefaultTabViewBar.h"
#import "JSAlertView.h"


@interface JSInvitationBottomItem : UIView
@property (nonatomic, strong)UIImageView *itemImage;
@property (nonatomic, strong)UILabel *label;

@end

@implementation JSInvitationBottomItem

- (UIImageView *)itemImage{
    if (!_itemImage) {
        _itemImage = [[UIImageView alloc]init];
        _itemImage.size = CGSizeMake(22, 23);
    }
    return _itemImage;
}
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = [UIColor colorWithHexString:@"A7A7A7"];
    }
    return _label;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.itemImage];
        [self addSubview:self.label];
    }
    return self;
}
- (void)configImageUrl:(NSString *)imageUrl text:(NSString *)text{
    self.itemImage.image = [UIImage imageNamed:imageUrl];
    self.label.text = text;
    [self.label sizeToFit];
    if (text.length > 0) {
        CGFloat top = (50-self.itemImage.height-self.label.height)/2.0f;
        self.itemImage.top = top;
        self.label.top = self.itemImage.bottom;
        
        self.itemImage.centerX = self.label.centerX = self.width/2.0f;
    }else{
        [self.itemImage sizeToFit];
        self.itemImage.centerX = self.width/2.0f;
        self.itemImage.bottom = self.height;
    }
    
}
@end

@interface JSInvitationViewController ()<WMPageControllerDelegate,WMPageControllerDataSource,HJTabViewControllerDataSource,HJTabViewControllerDelagate,HJDefaultTabViewBarDelegate>
@property (nonatomic, strong)UIImageView *headerView;
@property (nonatomic, strong)UIButton *shareButton;
@property (nonatomic, strong)UILabel *shareCodeLabel;
@property (nonatomic, strong)YYLabel *alertLabel;

@property (nonatomic, strong)WMPageController *pageController;
@property (nonatomic, strong)NSArray *topTitles;
@property (nonatomic, strong)NSArray *subVCs;

@property (nonatomic, strong)UIView *bottomBar;

@end

@implementation JSInvitationViewController

- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc]init];
        _headerView.image = [UIImage imageNamed:@"js_share_header_back"];
        _headerView.size = CGSizeMake(kScreenWidth-20, (kScreenWidth-20)/2.536);
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}
- (UIView *)bottomBar{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc]init];
        _bottomBar.backgroundColor = [UIColor whiteColor];
        _bottomBar.size = CGSizeMake(kScreenWidth, 50);
    }
    return _bottomBar;
}
- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"立即分享赚钱" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareButton setBackgroundColor:[UIColor colorWithHexString:@"FBD058"]];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _shareButton.size = CGSizeMake(125, 30);
        _shareButton.clipsToBounds = YES;
        _shareButton.layer.cornerRadius = _shareButton.height/2.0f;
        @weakify(self)
        [_shareButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            [JSShareManager shareWithTitle:@"叫兽说" Text:@"红包大放送，运气好最高能领到188注册红包+88零钱的邀请红包。" Image:[UIImage imageNamed:@"js_share_image"] Url:kShareUrl QQImageURL:kShareQQImage_1 shareType:JSShareManagerTypeFour complement:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self showAutoDismissTextAlert:@"分享成功"];
                }else{
                    [self showAutoDismissTextAlert:@"分享失败"];
                }
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
- (UILabel *)shareCodeLabel{
    if (!_shareCodeLabel) {
        _shareCodeLabel = [[UILabel alloc]init];
        _shareCodeLabel.textColor = [UIColor whiteColor];
        _shareCodeLabel.font = [UIFont systemFontOfSize:12];
        _shareCodeLabel.textAlignment = NSTextAlignmentCenter;
        _shareCodeLabel.size = CGSizeMake(200, 20);
    }
    return _shareCodeLabel;
}
- (NSArray *)topTitles{
    if (!_topTitles) {
        _topTitles = @[@"邀请好友",@"好友列表",@"唤醒好友"];
    }
    return _topTitles;
}
- (NSArray *)subVCs{
    if (!_subVCs) {
        JSInvitationSubViewController *subVC = [[JSInvitationSubViewController alloc]init];
        JSMyApprenticeViewController *subVC2 = [[JSMyApprenticeViewController alloc]init];
        subVC2.celltype = JSMyApprenticeCellTypeNormalList;
        JSMyApprenticeViewController *subVC3 = [[JSMyApprenticeViewController alloc]init];
        subVC3.celltype = JSMyApprenticeCellTypeWeakUpList;
        
        _subVCs = @[subVC,subVC2,subVC3];
    }
    return _subVCs;
}
- (WMPageController *)pageController{
    if (!_pageController) {
        _pageController = [[WMPageController alloc]init];
        _pageController.menuViewStyle = WMMenuViewStyleLine;
        _pageController.menuView.lineColor = [UIColor colorWithHexString:@"F44336"];
        //        _pageController.menuBGColor = [UIColor whiteColor];
        //        _pageController.menuHeight = 42.f;
        _pageController.menuItemWidth = kScreenWidth/3.0f;
        
        _pageController.titleColorNormal = [UIColor colorWithHexString:@"666666"];
        _pageController.titleSizeNormal = 15;
        _pageController.titleColorSelected = [UIColor colorWithHexString:@"F44336"];
        _pageController.titleSizeSelected = 15;
        _pageController.bounces = YES;
        _pageController.delegate = self;
        _pageController.dataSource = self;
        _pageController.selectIndex = 0;
    }
    return _pageController;
}


- (YYLabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[YYLabel alloc]init];
        _alertLabel.displaysAsynchronously = YES;
        _alertLabel.ignoreCommonProperties = YES;
        _alertLabel.backgroundColor = [UIColor colorWithHexString:@"F9F0D5"];
        
        NSString *text = @"邀请一位好友获得8元!";
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"js_profile_news_icon"];
        [imageView sizeToFit];
        
        NSMutableAttributedString *imageAttributeString = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
        [imageAttributeString insertString:@"    " atIndex:0];
        [imageAttributeString appendString:@" "];
        [imageAttributeString appendString:text];
        
        imageAttributeString.font = [UIFont systemFontOfSize:12];
        
        [imageAttributeString setColor:[UIColor colorWithHexString:@"333333"] range:[imageAttributeString.string rangeOfString:text]];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAXFLOAT, 30) text:imageAttributeString];
        
        [_alertLabel setTextLayout:layout];
        _alertLabel.size = layout.textBoundingSize;
        
    }
    return _alertLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.alertLabel];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.shareButton];
    [self.headerView addSubview:self.shareCodeLabel];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.headerView.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.alertLabel.mas_bottom).offset(10);
    }];
    
    [self.shareCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.shareCodeLabel.size);
        make.centerX.equalTo(self.headerView);
        make.bottom.equalTo(self.headerView).offset(-5);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.shareButton.size);
        make.centerX.equalTo(self.headerView);
        make.bottom.equalTo(self.shareCodeLabel.mas_top).offset(-10);
    }];

    [JSNetworkManager queryUserInformationWitchComplement:^(BOOL isSuccess, JSProfileUserModel * _Nonnull userModel) {
        if (isSuccess) {
            NSString *shareCode = [NSString stringWithFormat:@"我的邀请码:%@",userModel.inviteCode];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:shareCode  attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
            
            self.shareCodeLabel.attributedText = attrStr;
        }
    }];
    [self addChildViewController:self.pageController];
    self.pageController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pageController.view];
    
    
    [self initBottomBar];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
    
//    self.tabDataSource = self;
//    self.tabDelegate = self;
//
//    HJDefaultTabViewBar *tabViewBar = [HJDefaultTabViewBar new];
//    tabViewBar.delegate = self;
//    HJTabViewControllerPlugin_TabViewBar *tabViewBarPlugin = [[HJTabViewControllerPlugin_TabViewBar alloc] initWithTabViewBar:tabViewBar delegate:nil];
//    [self enablePlugin:tabViewBarPlugin];
//
//    [self enablePlugin:[HJTabViewControllerPlugin_HeaderScroll new]];
}

- (void)initBottomBar{
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        CGFloat tap = 0;
        if (IS_IPHONE_X) {
            tap = -34;
        }
        make.bottom.equalTo(self.view).offset(tap);
    }];
    
    CGFloat width = kScreenWidth/5.0f;
    CGFloat height = 50;
    NSArray *images = @[@"js_bind_wechat",@"js_profile_invi_firend",@"js_profile_invi_face",@"icon_l_qq_normal",@"js_profile_invi_message"];
    NSArray *titles = @[@"微信邀请",@"朋友圈分享",@"",@"QQ分享",@"短信分享"];
    for (int i = 0; i<5; i++) {
        JSInvitationBottomItem *item = [[JSInvitationBottomItem alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
        [item configImageUrl:images[i] text:titles[i]];
        
        item.tag = 100 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [item addGestureRecognizer:tap];
        [self.bottomBar addSubview:item];
    }

}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    switch (tap.view.tag - 100) {
        case 0:
        case 1:
        case 3:
        case 4:{
            [JSShareManager shareWithTitle:@"叫兽说" Text:@"红包大放送，运气好最高能领到188注册红包+88零钱的邀请红包。" Image:[UIImage imageNamed:@"js_share_image"] Url:kShareUrl QQImageURL:kShareQQImage_1 shareType:JSShareManagerTypeFour complement:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self showAutoDismissTextAlert:@"分享成功"];
                }else{
                    [self showAutoDismissTextAlert:@"分享失败"];
                }
            }];
        }break;
        case 2:{
            [JSAlertView showCIQRCodeImageWithUrl:kShareUrl superView:self.navigationController.view];
        }break;
            
        default:
            break;
    }
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
    return CGRectMake(0, 0, self.view.width, 42);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = 42;
    return CGRectMake(0, originY, self.view.width, self.pageController.view.height - originY);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController * _Nonnull)viewController withInfo:(NSDictionary * _Nonnull)info{
    
}



#pragma mark -

- (NSInteger)numberOfTabForTabViewBar:(HJDefaultTabViewBar *)tabViewBar {
    return [self numberOfViewControllerForTabViewController:self];
}

- (id)tabViewBar:(HJDefaultTabViewBar *)tabViewBar titleForIndex:(NSInteger)index {
    
    return self.topTitles[index];
}

- (void)tabViewBar:(HJDefaultTabViewBar *)tabViewBar didSelectIndex:(NSInteger)index {
//    BOOL anim = labs(index - self.curIndex) > 1 ? NO: YES;
//    [self scrollToIndex:index animated:YES];
}


#pragma mark -

- (void)tabViewController:(HJTabViewController *)tabViewController scrollViewVerticalScroll:(CGFloat)contentPercentY {
    // 博主很傻，用此方法渐变导航栏是偷懒表现，只是为了demo演示。正确科学方法请自行百度 iOS导航栏透明
//    self.navigationController.navigationBar.alpha = contentPercentY;
}

- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return self.subVCs.count;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    
    return self.subVCs[index];
}

- (UIView *)tabHeaderViewForTabViewController:(HJTabViewController *)tabViewController {
    
    return self.headerView;
}

- (CGFloat)tabHeaderBottomInsetForTabViewController:(HJTabViewController *)tabViewController {
    return HJTabViewBarDefaultHeight ;
}

- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake(0, 0, 50, 0);
}


@end

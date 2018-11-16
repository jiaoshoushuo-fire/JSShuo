//
//  JSProfileViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSProfileViewController.h"
#import "SDCycleScrollView.h"
#import "JSProfileCell.h"
#import "JSNetworkManager+Login.h"
#import "JSProfileUserModel.h"
#import "NSDictionary+SetNullWithStr.h"
#import "JSMessageViewController.h"
#import "JSSettingViewController.h"
#import "JSWithdrawViewController.h"
#import "JSShopViewController.h"
#import "JSInvitationViewController.h"
#import "JSMyWalletViewController.h"

@interface JSProfileItemView : UIView
@property (nonatomic, strong)UIImageView *itemImageView;
@property (nonatomic, strong)UILabel *itemLabel;
@end
@implementation JSProfileItemView

-(UIImageView *)itemImageView{
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc]init];
        _itemImageView.userInteractionEnabled = YES;
        _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _itemImageView;
}
- (UILabel *)itemLabel{
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc]init];
        _itemLabel.textColor = [UIColor colorWithHexString:@"262626"];
        _itemLabel.font = [UIFont systemFontOfSize:14];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _itemLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.itemImageView];
        [self addSubview:self.itemLabel];
        [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerX.equalTo(self);
            make.top.mas_equalTo(10);
        }];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.itemImageView.mas_bottom).offset(5);
        }];
    }
    return self;
}
@end

@protocol JSProfileHeaderMenuItemViewDelegate <NSObject>

- (void)didSelectedMenuItemIndex:(NSInteger)index;

@end

@interface JSProfileHeaderMenuItemView:UIView
@property (nonatomic, strong)NSArray *iconImages;
@property (nonatomic, strong)NSArray *itemTitels;
@property (nonatomic, weak)id<JSProfileHeaderMenuItemViewDelegate>delegate;

@end

@implementation JSProfileHeaderMenuItemView

- (NSArray *)iconImages{
    if (!_iconImages) {
        _iconImages = @[@"js_profile_tixian",@"js_profile_shangcheng",@"js_profile_invitate",@"js_profile_qianbao"];
    }
    return _iconImages;
}
- (NSArray *)itemTitels{
    if (!_itemTitels) {
        _itemTitels = @[@"提现",@"商城",@"邀请好友",@"我的钱包"];
    }
    return _itemTitels;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = kScreenWidth/(float)self.iconImages.count;
        CGFloat height = 10 + 30 + 5 + 20 + 10;
        for (int i=0; i<self.iconImages.count; i++) {
            JSProfileItemView *itemView = [[JSProfileItemView alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemViewDidSelectedWithIndex:)];
            [itemView addGestureRecognizer:tap];
            itemView.itemImageView.image = [UIImage imageNamed:self.iconImages[i]];
            itemView.itemLabel.text = self.itemTitels[i];
            itemView.tag = 100 + i;
            [self addSubview:itemView];
        }
    }
    return self;
}

- (void)itemViewDidSelectedWithIndex:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - 100;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedMenuItemIndex:)]) {
        [self.delegate didSelectedMenuItemIndex:index];
    }
}
@end

@interface JSProfileHeaderView:UIImageView
@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, strong)UIImageView *avaterIcon;
@property (nonatomic, strong)UILabel *myGoldNumber;
@property (nonatomic, strong)UILabel *myGoldtTitle;
@property (nonatomic, strong)UILabel *myReadTime;
@property (nonatomic, strong)UILabel *myReadTitle;
@property (nonatomic, strong)UILabel *myPocketMoney;
@property (nonatomic, strong)UILabel *myPocketMoneyTitle;
@property (nonatomic, strong)UIView *lineLeft;
@property (nonatomic, strong)UIView *lineRight;

@property (nonatomic, strong)JSProfileUserModel *userModel;
@end
@implementation JSProfileHeaderView

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"js_login_message"] forState:UIControlStateNormal];
    }
    return _leftButton;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"js_login_setting"] forState:UIControlStateNormal];
    }
    return _rightButton;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.textColor = [UIColor whiteColor];
        _subLabel.font = [UIFont systemFontOfSize:10];
        _subLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subLabel;
}
- (UIImageView *)avaterIcon{
    if (!_avaterIcon) {
        _avaterIcon = [[UIImageView alloc]init];
        _avaterIcon.clipsToBounds = YES;
        _avaterIcon.layer.cornerRadius = 70/2.0f;
        _avaterIcon.image = [UIImage imageNamed:@"js_profile_default_icon"];
    }
    return _avaterIcon;
}

- (UILabel *)myGoldNumber{
    if (!_myGoldNumber) {
        _myGoldNumber = [[UILabel alloc]init];
        _myGoldNumber.textColor = [UIColor whiteColor];
        _myGoldNumber.font = [UIFont boldSystemFontOfSize:20];
        _myGoldNumber.textAlignment = NSTextAlignmentCenter;
        _myGoldNumber.text = @"0";
    }
    return _myGoldNumber;
}
- (UILabel *)myGoldtTitle{
    if (!_myGoldtTitle) {
        _myGoldtTitle = [[UILabel alloc]init];
        _myGoldtTitle.textColor = [UIColor whiteColor];
        _myGoldtTitle.font = [UIFont systemFontOfSize:14];
        _myGoldtTitle.textAlignment = NSTextAlignmentCenter;
        _myGoldtTitle.text = @"我的金币";
        
    }
    return _myGoldtTitle;
}
-(UILabel *)myReadTime{
    if (!_myReadTime) {
        _myReadTime = [[UILabel alloc]init];
        _myReadTime.textColor = [UIColor whiteColor];
        _myReadTime.font = [UIFont boldSystemFontOfSize:20];
        _myReadTime.textAlignment = NSTextAlignmentCenter;
        _myReadTime.text = @"0";
    }
    return _myReadTime;
}
- (UILabel *)myReadTitle{
    if (!_myReadTitle) {
        _myReadTitle = [[UILabel alloc]init];
        _myReadTitle.textColor = [UIColor whiteColor];
        _myReadTitle.font = [UIFont systemFontOfSize:14];
        _myReadTitle.textAlignment = NSTextAlignmentCenter;
        _myReadTitle.text = @"我的阅读(分钟)";
    }
    return _myReadTitle;
}
- (UILabel *)myPocketMoney{
    if (!_myPocketMoney) {
        _myPocketMoney = [[UILabel alloc]init];
        _myPocketMoney.textColor = [UIColor whiteColor];
        _myPocketMoney.font = [UIFont boldSystemFontOfSize:20];
        _myPocketMoney.textAlignment = NSTextAlignmentCenter;
        _myPocketMoney.text = @"0";
    }
    return _myPocketMoney;
}
- (UILabel *)myPocketMoneyTitle{
    if (!_myPocketMoneyTitle) {
        _myPocketMoneyTitle = [[UILabel alloc]init];
        _myPocketMoneyTitle.textColor = [UIColor whiteColor];
        _myPocketMoneyTitle.font = [UIFont systemFontOfSize:14];
        _myPocketMoneyTitle.textAlignment = NSTextAlignmentCenter;
        _myPocketMoneyTitle.text = @"我的零钱";
    }
    return _myPocketMoneyTitle;
}
- (UIView *)lineLeft{
    if (!_lineLeft) {
        _lineLeft = [[UIView alloc]init];
        _lineLeft.backgroundColor = [UIColor whiteColor];
    }
    return _lineLeft;
}
- (UIView *)lineRight{
    if (!_lineRight) {
        _lineRight = [[UIView alloc]init];
        _lineRight.backgroundColor = [UIColor whiteColor];
    }
    return _lineRight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"js_profile_header_back"];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subLabel];
        [self addSubview:self.avaterIcon];
        [self addSubview:self.myGoldtTitle];
        [self addSubview:self.myGoldNumber];
        [self addSubview:self.myReadTitle];
        [self addSubview:self.myReadTime];
        [self addSubview:self.myPocketMoney];
        [self addSubview:self.myPocketMoneyTitle];
        [self addSubview:self.lineRight];
        [self addSubview:self.lineLeft];

        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(kApplicationStatusBarHeight+10);
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.equalTo(self).offset(-10);
            make.top.mas_equalTo(self.leftButton.mas_top);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftButton.mas_right).offset(20);
            make.right.mas_equalTo(self.rightButton.mas_left).offset(-20);
            make.top.mas_equalTo(self.leftButton.mas_top);
            make.height.mas_equalTo(20);
        }];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(self.titleLabel.mas_right);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(3);
            make.height.mas_equalTo(15);
        }];
        [self.avaterIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.centerX.equalTo(self);
            make.top.mas_equalTo(self.subLabel.mas_bottom).offset(8);
        }];
        [self.myReadTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).dividedBy(3.0f);
            make.height.mas_equalTo(30);
            make.centerX.equalTo(self);
            make.top.mas_equalTo(self.avaterIcon.mas_bottom).offset(8);
        }];
        [self.myReadTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.myReadTime.mas_left);
            make.right.mas_equalTo(self.myReadTime.mas_right);
            make.top.mas_equalTo(self.myReadTime.mas_bottom).offset(5);
            make.height.mas_equalTo(20);
        }];
        
        [self.lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1.0f);
            make.top.mas_equalTo(self.myReadTime.mas_top);
            make.bottom.mas_equalTo(self.myReadTitle.mas_bottom);
            make.left.mas_equalTo(self.myReadTime.mas_left).offset(-1);
        }];
        [self.lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1.0f);
            make.top.mas_equalTo(self.myReadTime.mas_top);
            make.bottom.mas_equalTo(self.myReadTitle.mas_bottom);
            make.right.mas_equalTo(self.myReadTime.mas_right).offset(1);
        }];
        
        [self.myGoldNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.mas_equalTo(self.lineLeft.mas_left);
            make.top.mas_equalTo(self.myReadTime.mas_top);
            make.height.mas_equalTo(30);
        }];
        [self.myGoldtTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.myGoldNumber.mas_left);
            make.right.mas_equalTo(self.myGoldNumber.mas_right);
            make.top.mas_equalTo(self.myGoldNumber.mas_bottom).offset(5);
            make.height.mas_equalTo(20);
        }];
        
        [self.myPocketMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.mas_equalTo(self.lineRight.mas_right);
            make.top.mas_equalTo(self.myReadTime.mas_top);
            make.height.mas_equalTo(30);
        }];
        [self.myPocketMoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.myPocketMoney.mas_left);
            make.right.mas_equalTo(self.myPocketMoney.mas_right);
            make.top.mas_equalTo(self.myPocketMoney.mas_bottom).offset(5);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}
- (void)setUserModel:(JSProfileUserModel *)userModel{
    self.titleLabel.text = userModel.nickname;
    self.subLabel.text = userModel.inviteCode;
    [self.avaterIcon setImageWithURL:[NSURL URLWithString:userModel.portrait] placeholder:nil];
    self.myGoldNumber.text = @(userModel.coin).stringValue;
    self.myReadTime.text = @(userModel.readTime).stringValue;
    self.myPocketMoney.text = @(userModel.money).stringValue;
    
}
@end


@interface JSProfileViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,JSProfileHeaderMenuItemViewDelegate>
@property (nonatomic, strong)UITableView *profileTableView;
@property (nonatomic, strong)JSProfileHeaderView *headerView;
@property (nonatomic, strong)JSProfileHeaderMenuItemView *menuItemView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong)UIView *tableHeaderView;

@property (nonatomic, strong)NSArray *profileInfoArray;
@end

@implementation JSProfileViewController

- (JSProfileHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[JSProfileHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
//        _headerView.backgroundColor = [UIColor redColor];
        @weakify(self)
        [_headerView.leftButton bk_addEventHandler:^(id sender) {//消息
            @strongify(self)
            JSMessageViewController *messageVC = [[JSMessageViewController alloc]init];
            messageVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:messageVC animated:YES complete:nil];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        [_headerView.rightButton bk_addEventHandler:^(id sender) {//设置
            @strongify(self)
            JSSettingViewController *settingVC = [[JSSettingViewController alloc]init];
            settingVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:settingVC animated:YES complete:nil];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}
- (JSProfileHeaderMenuItemView *)menuItemView{
    if (!_menuItemView) {
        _menuItemView = [[JSProfileHeaderMenuItemView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 75)];
        _menuItemView.delegate = self;
    }
    return _menuItemView;
}
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 0, kScreenWidth-20, 80) delegate:self placeholderImage:nil];
        _cycleScrollView.currentPageDotColor = [UIColor redColor];   // 自定义分页控件小圆标颜色，当前分页控件为红色
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.imageURLStringsGroup = @[@"https://192.168.21.49/php/wenda_live_zhibojiantiwen_a@2x.png",@"https://192.168.21.49/php/lauch.jpg"];
    }
    return _cycleScrollView;
}
- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
        [_tableHeaderView addSubview:self.headerView];

    }
    return _tableHeaderView;
}

- (UITableView *)profileTableView{
    if (!_profileTableView) {
        _profileTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _profileTableView.delegate = self;
        _profileTableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _profileTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _profileTableView.estimatedRowHeight = 0;
            _profileTableView.estimatedSectionFooterHeight = 0;
            _profileTableView.estimatedSectionHeaderHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_profileTableView registerClass:[JSProfileCell class] forCellReuseIdentifier:@"JSProfileCell"];
        [_profileTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _profileTableView.tableHeaderView = self.tableHeaderView;
        @weakify(self)
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self refreshProfileData];
        }];
        header.stateLabel.textColor = [UIColor whiteColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
//        header.backgroundColor = [UIColor redColor];
        _profileTableView.mj_header = header;
        
    }
    return _profileTableView;
}
- (NSArray *)profileInfoArray{
    if (!_profileInfoArray) {
        _profileInfoArray = @[@{@"imagePath":@"js_profile_input_code",@"title":@"输入邀请码",@"subTitle":@"0.5-88零钱大抽奖"},
                              @{@"imagePath":@"js_profile_mession",@"title":@"任务中心",@"subTitle":@"红包金币拿到手软"},
                              @{@"imagePath":@"js_profile_game",@"title":@"游戏大厅",@"subTitle":@"金币赚不停"},
                              @{@"imagePath":@"js_profile_huiyuan",@"title":@"会员大促销",@"subTitle":@"特价返利最后七天"},
                              @{@"imagePath":@"js_profile_question",@"title":@"常见问题",@"subTitle":@""},
                              @{@"imagePath":@"js_profile_pinglun",@"title":@"我的评论",@"subTitle":@""},
                              @{@"imagePath":@"js_profile_shoucang",@"title":@"我的收藏",@"subTitle":@""},
                              ];
    }
    return _profileInfoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    [self.view addSubview:self.profileTableView];
    [self.profileTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self checkTableviewSubViews];
    [self.profileTableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshProfileInfo) name:@"JS_Refresh_Profile_info" object:nil];
}
- (void)refreshProfileInfo{
    [self.profileTableView.mj_header beginRefreshing];
}
- (void)checkTableviewSubViews{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectOffset(self.profileTableView.bounds, 0, -self.profileTableView.bounds.size.height)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"F05952"];
    [self.profileTableView insertSubview:bgView atIndex:0];
}
-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)userLoginSuccessNoti:(NSNotification *)notification{
    [self.profileTableView.mj_header beginRefreshing];
}

- (void)refreshProfileData{
    [JSNetworkManager requestProfileDateWithComplement:^(BOOL isSuccess, NSDictionary * _Nonnull dataDict) {
        if (isSuccess) {
            
            NSError *error = nil;
            JSProfileUserModel *userModel = [MTLJSONAdapter modelOfClass:[JSProfileUserModel class] fromJSONDictionary:dataDict error:&error];
            [self.headerView setUserModel:userModel];
        }
        [self.profileTableView.mj_header endRefreshing];
    }];
}
#pragma mark JSProfileHeaderMenuItemViewDelegate
- (void)didSelectedMenuItemIndex:(NSInteger)index{
    switch (index) {
        case 0:{//提现
            JSWithdrawViewController *vc = [[JSWithdrawViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
        }break;
        case 1:{//商城
            JSShopViewController *shopVC = [[JSShopViewController alloc]init];
            shopVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:shopVC animated:YES complete:nil];
        }break;
        case 2:{//邀请好友
            JSInvitationViewController *invitationVC = [[JSInvitationViewController alloc]init];
            invitationVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:invitationVC animated:YES complete:nil];
        }break;
        case 3:{//我的钱包
            JSMyWalletViewController *myWalletVC = [[JSMyWalletViewController alloc]init];
            myWalletVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:myWalletVC animated:YES complete:nil];
        }break;
            
        default:
            break;
    }
}

#pragma SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }
    return self.profileInfoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *profileCell = nil;
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        [cell.contentView addSubview:self.menuItemView];
        profileCell = cell;
        
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        [cell.contentView addSubview:self.cycleScrollView];
        profileCell = cell;
    }else{
        JSProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSProfileCell" forIndexPath:indexPath];
        NSDictionary *cellInfoDict = self.profileInfoArray[indexPath.row];
        cell.infoDict = cellInfoDict;
        profileCell = cell;
    }
    
    return profileCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 75;
    }else if (indexPath.section == 1){
        return 80;
    }
    return 42.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

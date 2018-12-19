//
//  JSSettingViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSSettingViewController.h"
#import "JSNetworkManager+Login.h"
#import "AppDelegate.h"
#import "JSPerfectUserInfoViewController.h"
#import "GFCacheUtil.h"
#import "JSFontChangeViewController.h"
#import "JSPrivacyViewController.h"
#import "JSFeedbackViewController.h"
#import "JSAboutUsViewController.h"
#import "JSTool.h"

@interface JSSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)UIButton *loginOutButton;
@end

@implementation JSSettingViewController


- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@[@"完善资料"/*,@"字体大小"*/],@[@"清除缓存",@"给叫兽说评分"],@[@"隐私协议",@"建议与反馈",@"关于我们"]];
    }
    return _dataArray;
}
- (UIButton *)loginOutButton{
    if (!_loginOutButton) {
        _loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginOutButton.backgroundColor = [UIColor colorWithHexString:@"F44336"];
        [_loginOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        _loginOutButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginOutButton.size = CGSizeMake(kScreenWidth-20, 45);
        @weakify(self)
        [_loginOutButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            [JSNetworkManager loginOutWithComplement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
                if (isSuccess) {
                    [JSAccountManager refreshAccountToken:nil];
                    [self.rt_navigationController popViewControllerAnimated:YES complete:^(BOOL finished) {
                        JSMainViewController *mainVC = [AppDelegate instance].mainViewController;
                        [mainVC switchToViewControllerAtIndex:0];
                    }];
                }
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOutButton;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = self.loginOutButton;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }
    return 0.000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"完善资料"]){
        JSPerfectUserInfoViewController *perfectVC = [[JSPerfectUserInfoViewController alloc]init];
        [self.rt_navigationController pushViewController:perfectVC animated:YES complete:nil];
    }else if ([title isEqualToString:@"字体大小"]){
        JSFontChangeViewController *fontChangeVC = [[JSFontChangeViewController alloc]init];
        [self.rt_navigationController pushViewController:fontChangeVC animated:YES complete:nil];
    }else if ([title isEqualToString:@"清除缓存"]){
        double sizeInCache = [GFCacheUtil cacheSizeInPath:kPathLibraryCacheDirectory];
        double sizeInTemp = [GFCacheUtil cacheSizeInTemporaryDirectory];
        double size = sizeInCache + sizeInTemp;
        
        NSString *sizeString = @"";
        if (size < 1) {
            sizeString = [NSString stringWithFormat:@"%.2fKB", size*1000];
        } else {
            sizeString = [NSString stringWithFormat:@"%.2fMB", size];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"正在清理内存";
        
        [GFCacheUtil cleanCacheInPath:kPathLibraryCacheDirectory];
        [GFCacheUtil cleanCacheInTemporaryDirectory];
        hud.label.text = [NSString stringWithFormat:@"已清理%@内存空间", sizeString];
        [hud hideAnimated:YES afterDelay:1.0f];
        
    }else if ([title isEqualToString:@"给叫兽说评分"]){
        [JSTool appStoreComent];
    }else if ([title isEqualToString:@"隐私协议"]){
        JSPrivacyViewController *privacyVC = [[JSPrivacyViewController alloc]initWithUrl:@"http://api.jiaoshoutt.com/v1/page/protocal/user"];
        privacyVC.hidesBottomBarWhenPushed = YES;
        [self.rt_navigationController pushViewController:privacyVC animated:YES complete:nil];
    }else if ([title isEqualToString:@"建议与反馈"]){
        JSFeedbackViewController *feedbackVC = [[JSFeedbackViewController alloc]init];
        [self.rt_navigationController pushViewController:feedbackVC animated:YES complete:nil];
    }else if ([title isEqualToString:@"关于我们"]){
        JSAboutUsViewController *aboutUsVC = [[JSAboutUsViewController alloc]init];
        [self.rt_navigationController pushViewController:aboutUsVC animated:YES complete:nil];
    }
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

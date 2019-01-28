//
//  JSPerfectUserInfoViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/9.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSPerfectUserInfoViewController.h"
#import "JSPerfectUserInfoCell.h"
#import "JSNetworkManager+Login.h"
#import "GGAssetsPickerViewController.h"
#import "JSInputBar.h"
#import "JSBindIPhoneViewController.h"
#import "JSAccountManager+Wechat.h"
#import <ActionSheetPicker.h>
#import "JSWithdrawAlertView.h"



@interface JSPerfectUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,GGAssetPickerViewControllerDelegate,ActionSheetCustomPickerDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *userInfos;
@property (nonatomic, strong)NSArray *jobs;
@end

@implementation JSPerfectUserInfoViewController

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableview.estimatedRowHeight = 0;
            _tableview.estimatedSectionFooterHeight = 0;
            _tableview.estimatedSectionHeaderHeight = 0;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[JSPerfectUserInfoCell class] forCellReuseIdentifier:@"JSPerfectUserInfoCell"];
        @weakify(self)
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self createData];
        }];
        
    }
    return _tableview;
}
- (NSArray *)jobs{
    if (!_jobs) {
        _jobs = @[@{@"key1":@"通用岗位",@"key2":@[@"销售",@"市场",@"人力资源",@"行政",@"公关",@"客服",@"采购",@"技工",@"公司职工",@"职业经理人",@"私营企业主",@"中层管理者",@"自由职业者"]},
                  @{@"key1":@"IT互联网",@"key2":@[@"开发工程师",@"测试工程师",@"设计师",@"运营师",@"产品经理",@"风控安全",@"个体/网店"]},
                  @{@"key1":@"文化传媒",@"key2":@[@"编辑策划",@"记者",@"艺人",@"经纪人",@"媒体工作者"]},
                  @{@"key1":@"金融",@"key2":@[@"咨询",@"投行",@"保险",@"金融分析",@"财务",@"风险管理",@"风险投资人"]},
                  @{@"key1":@"教育培训",@"key2":@[@"学生",@"留学生",@"大学生",@"研究生",@"博士",@"科研人员",@"教师"]},
                  @{@"key1":@"医疗生物",@"key2":@[@"医生",@"护士",@"宠物医生",@"医学研究"]},
                  @{@"key1":@"政府组织",@"key2":@[@"公务员",@"事业单位",@"军人",@"律师",@"警察",@"国企工作者",@"运动员"]},
                  @{@"key1":@"工业制造",@"key2":@[@"技术研发",@"技工",@"质检",@"建筑工人",@"装修工人",@"建筑设计师"]},
                  @{@"key1":@"餐饮出行",@"key2":@[@"厨师",@"服务员",@"收银",@"导购",@"保安",@"乘务人员",@"驾驶员",@"航空人员",@"空乘"]},
                  @{@"key1":@"服务业",@"key2":@[@"导游",@"快递员（含外卖）",@"美容美发",@"家政服务",@"婚庆服务",@"运动健身"]},
                  @{@"key1":@"其他",@"key2":@[@"其他"]}];
    }
    return _jobs;
}
- (NSMutableArray *)userInfos{
    if (!_userInfos) {
        _userInfos = [NSMutableArray array];
    }
    return _userInfos;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善资料";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
- (void)createData{
    [JSNetworkManager queryUserInformationWitchComplement:^(BOOL isSuccess, JSProfileUserModel * _Nonnull userModel) {
        if (isSuccess) {
            [self.tableview.mj_header endRefreshing];
            [self.userInfos removeAllObjects];
            NSMutableArray *array1 = [NSMutableArray array];
            {
                JSPerfectUserInfoCellModel *model = [[JSPerfectUserInfoCellModel alloc]init];
                model.title = @"头像";
                model.imageUrl = userModel.portrait;
                model.isHasAccessory = YES;
                [array1 addObject:model];
            }
            {
                JSPerfectUserInfoCellModel *model = [[JSPerfectUserInfoCellModel alloc]init];
                model.title = @"昵称";
                model.subTitle = userModel.nickname;
                model.isHasAccessory = YES;
                [array1 addObject:model];
            }
            {
                JSPerfectUserInfoCellModel *model = [[JSPerfectUserInfoCellModel alloc]init];
                model.title = @"年龄";
                model.subTitle = @(userModel.age).stringValue;
                model.isHasAccessory = YES;
                [array1 addObject:model];
            }
            {
                JSPerfectUserInfoCellModel *model = [[JSPerfectUserInfoCellModel alloc]init];
                model.title = @"性别";
                model.subTitle = userModel.sex == 1 ? @"男":@"女";
                model.isHasAccessory = YES;
                [array1 addObject:model];
            }
            {
                JSPerfectUserInfoCellModel *model = [[JSPerfectUserInfoCellModel alloc]init];
                model.title = @"职业";
                model.subTitle = userModel.jobCategory;
                model.isHasAccessory = YES;
                [array1 addObject:model];
            }
            {
                JSPerfectUserInfoCellModel *model = [[JSPerfectUserInfoCellModel alloc]init];
                model.title = @"教育背景";
                model.subTitle = userModel.education;
                model.isHasAccessory = YES;
                [array1 addObject:model];
            }
            {
                JSPerfectUserInfoCellModel *model = [[JSPerfectUserInfoCellModel alloc]init];
                model.title = @"个人简介";
                model.subTitle = userModel.intro;
                model.isHasAccessory = YES;
                [array1 addObject:model];
            }
            [self.userInfos addObject:array1];
            
            NSMutableArray *array2 = [NSMutableArray array];
            {
                JSPerfectUserInfoCellModel *model = [[JSPerfectUserInfoCellModel alloc]init];
                model.title = @"手机号";
                model.subTitle = userModel.bindStatus == 1 ? @"已绑定":@"未绑定";
                model.isHasAccessory = userModel.bindStatus == 1 ? NO : YES;
                [array2 addObject:model];
            }
            {
                JSPerfectUserInfoCellModel *model = [[JSPerfectUserInfoCellModel alloc]init];
                model.title = @"微信";
                model.subTitle = userModel.isWechatBind == 1 ? /*userModel.wechatAccount*/@"已绑定" : @"未绑定";
                model.isHasAccessory = YES;
                [array2 addObject:model];
            }
//            {
//                JSPerfectUserInfoCellModel *model = [[JSPerfectUserInfoCellModel alloc]init];
//                model.title = @"支付宝";
//                model.subTitle = userModel.isAlipayBind == 1 ? /*userModel.alipayAccount*/@"已绑定" : @"未绑定";
//                model.isHasAccessory = YES;
//                [array2 addObject:model];
//            }
            [self.userInfos addObject:array2];
            [self.tableview reloadData];
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"JS_Refresh_Profile_info" object:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.userInfos.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.userInfos[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSPerfectUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSPerfectUserInfoCell" forIndexPath:indexPath];
    JSPerfectUserInfoCellModel *model = self.userInfos[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    }else if (indexPath.section == 0 && indexPath.row == 6){
        JSPerfectUserInfoCellModel *model = self.userInfos[indexPath.section][indexPath.row];
        CGFloat height = [model.subTitle heightForFont:[UIFont systemFontOfSize:14] width:kScreenWidth-20-30-60-10];
        height = MAX(height, 20);
        height += 22;
        return height;
    }
    return 42;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00000001f;
    }
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        titleLabel.text = @"账号绑定";
        [titleLabel sizeToFit];
        
        UIView *lineLeft = [[UIView alloc]init];
        lineLeft.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
        lineLeft.size = CGSizeMake(70, 1);
        
        UIView *lineRight = [[UIView alloc]init];
        lineRight.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
        lineRight.size = CGSizeMake(70, 1);
        
        [headerView addSubview:lineLeft];
        [headerView addSubview:lineRight];
        [headerView addSubview:titleLabel];
        
        titleLabel.centerX = headerView.width/2.0f;
        titleLabel.centerY = headerView.height/2.0f;
        
        lineLeft.centerY = lineRight.centerY = titleLabel.centerY;
        lineRight.left = titleLabel.right + 7;
        lineLeft.right = titleLabel.left - 7;
        return headerView;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JSPerfectUserInfoCellModel *model = self.userInfos[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"头像"]) {
        
        GGAssetsPickerViewController *picker = [[GGAssetsPickerViewController alloc] init];
        picker.allowTakePhoto = YES;
        picker.option = AssetMediaOptionImage;
        picker.maxAssetCount = 1;
        picker.allowPreviewAndEdit = NO;
        picker.pickerDelegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
        
        
    }else if ([model.title isEqualToString:@"昵称"]){
        [JSInputBar showInputBarWithView:self.navigationController.view type:JSInputBarTypeNickname complement:^(NSString * _Nonnull newNickName) {
            JSPerfectUserInfoCellModel *model = self.userInfos[0][1];
            model.subTitle = newNickName;
            [self.tableview reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
        }];
    }else if ([model.title isEqualToString:@"年龄"]){
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc]initWithTitle:@"选择生日" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
//            NSString *ageString = [NSString stringWithFormat:@"%@ %ld",[self getConstellationFromBirthday:selectedDate],[self getAgeWith:selectedDate]];
            NSInteger age = [self getAgeWith:selectedDate];
            [JSNetworkManager modifyUserInfoWithDict:@{@"age":@(age)} complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
                if (isSuccess) {
                    JSPerfectUserInfoCellModel *model = self.userInfos[0][2];
                    model.subTitle = @(age).stringValue;
                    [self.tableview reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
            
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            
        } origin:self.navigationController.view];
        datePicker.maximumDate = [NSDate date];
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
        [cancelButton setTintColor:[UIColor colorWithHexString:@"59BA78"]];
        [datePicker setCancelButton:cancelButton];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:nil action:nil];
        [doneButton setTintColor:[UIColor colorWithHexString:@"59BA78"]];
        [datePicker setDoneButton:doneButton];
        
        [datePicker showActionSheetPicker];
        
    }else if ([model.title isEqualToString:@"性别"]){
        JSPerfectUserInfoCellModel *model = self.userInfos[0][3];
        
        ActionSheetStringPicker *sexPicker = [[ActionSheetStringPicker alloc]initWithTitle:@"选择性别" rows:@[@"男",@"女"] initialSelection:[model.subTitle isEqualToString:@"男"] ? 0 : 1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            NSInteger sexIndex = [selectedValue isEqualToString:@"男"] ? 1 : 2;
            [JSNetworkManager modifyUserInfoWithDict:@{@"sex":@(sexIndex)} complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
                if (isSuccess) {
                    JSPerfectUserInfoCellModel *model = self.userInfos[0][3];
                    model.subTitle = selectedValue;
                    [self.tableview reloadRow:3 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
            
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.navigationController.view];
        
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
        [cancelButton setTintColor:[UIColor colorWithHexString:@"59BA78"]];
        [sexPicker setCancelButton:cancelButton];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:nil action:nil];
        [doneButton setTintColor:[UIColor colorWithHexString:@"59BA78"]];
        [sexPicker setDoneButton:doneButton];
        
        [sexPicker showActionSheetPicker];
        
    }else if ([model.title isEqualToString:@"职业"]){
        ActionSheetCustomPicker *professionPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"选择职业"
                                                                                        delegate:self
                                                                                showCancelButton:YES
                                                                                          origin:[UIApplication sharedApplication].keyWindow];
        
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
        [cancelButton setTintColor:[UIColor colorWithHexString:@"59BA78"]];
        [professionPicker setCancelButton:cancelButton];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:nil action:nil];
        [doneButton setTintColor:[UIColor colorWithHexString:@"59BA78"]];
        [professionPicker setDoneButton:doneButton];
        
        [professionPicker showActionSheetPicker];
        
    }else if ([model.title isEqualToString:@"教育背景"]){
        NSArray *teachesArray = @[@"小学",@"初中",@"高中/中专",@"大学专科（大专）",@"大学本科（大本）",@"研究生",@"硕士",@"博士"];
        ActionSheetStringPicker *sexPicker = [[ActionSheetStringPicker alloc]initWithTitle:@"教育背景" rows:teachesArray initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            
            [JSNetworkManager modifyUserInfoWithDict:@{@"education":selectedValue} complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
                if (isSuccess) {
                    JSPerfectUserInfoCellModel *model = self.userInfos[0][5];
                    model.subTitle = selectedValue;
                    [self.tableview reloadRow:5 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
            
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.navigationController.view];
        
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
        [cancelButton setTintColor:[UIColor colorWithHexString:@"59BA78"]];
        [sexPicker setCancelButton:cancelButton];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:nil action:nil];
        [doneButton setTintColor:[UIColor colorWithHexString:@"59BA78"]];
        [sexPicker setDoneButton:doneButton];
        
        [sexPicker showActionSheetPicker];
        
    }else if ([model.title isEqualToString:@"个人简介"]){
        [JSInputBar showInputBarWithView:self.navigationController.view type:JSInputBarTypeIntroduction complement:^(NSString * _Nonnull newNickName) {
            JSPerfectUserInfoCellModel *model = self.userInfos[0][6];
            model.subTitle = newNickName;
            [self.tableview reloadRow:6 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
        }];
        
    }else if ([model.title isEqualToString:@"手机号"]){
        if ([model.subTitle isEqualToString:@"未绑定"]) {
            JSBindIPhoneViewController *bindVC = [[JSBindIPhoneViewController alloc]init];
            bindVC.codeType = JSRequestSecurityCodeTypeBindIPhone;
            bindVC.complement = ^(BOOL isFinished) {
                if (isFinished) {
                    JSPerfectUserInfoCellModel *model = self.userInfos[1][0];
                    model.subTitle = @"已绑定";
                    model.isHasAccessory = NO;
                    [self.tableview reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationFade];
                }
            };
            [self.rt_navigationController pushViewController:bindVC animated:YES complete:nil];
        }
        
    }else if ([model.title isEqualToString:@"微信"]){
        if ([model.subTitle isEqualToString:@"未绑定"] ) {
            [JSAccountManager wechatAuthorizeFromLogin:NO completion:^(BOOL success) {
                if (success) {
                    [self.tableview.mj_header beginRefreshing];
                }
            }];
        }
    }else if ([model.title isEqualToString:@"支付宝"]){
        if ([model.subTitle isEqualToString:@"未绑定"]) {
//            [JSWithdrawAlertView showAlertViewWithSuperView:self.navigationController.view type:JSWithdrawAlertViewTypeAlipay isBind:YES handle:^(BOOL isSuccess) {
//                if (isSuccess) {
//                    [self.tableview.mj_header beginRefreshing];
//                }
//            }];
        }
    }
}

#pragma mark - GGAssetPickerViewControllerDelegate
- (void)picker:(GGAssetsPickerViewController *)picker didSelectAssets:(NSArray<PHAsset *> *)assetsPicked {
    @weakify(self)
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        if (assetsPicked.count > 0) {
            [GGPhotoLibrary requestImageForAsset:assetsPicked.firstObject preferSize:CGSizeMake(320, 320) completion:^(UIImage *image, NSDictionary *info) {
                
                [self uploadAvaterImage:image];
            }];
        }
    }];
}
- (void)picker:(GGAssetsPickerViewController *)picker didSelectImageAtPath:(NSString *)path {
    @weakify(self)
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        if ([path isNotBlank]) {
            UIImage *avaterImage = [UIImage imageWithContentsOfFile:path];
            [self uploadAvaterImage:avaterImage];
            
        }
    }];
    
}
- (void)uploadAvaterImage:(UIImage *)image{
    [self showWaitingHUD];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    UIImage *resultImage = [UIImage imageWithData:data];
    
    [JSNetworkManager uploadImage:resultImage complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        if (isSuccess) {
            NSString *imageUrl = contentDict[@"url"];
            [JSNetworkManager modifyUserInfoWithDict:@{@"portrait":imageUrl} complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
                if (isSuccess) {
                    [self hideWaitingHUD];
                    JSPerfectUserInfoCell *userInfoCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                    userInfoCell.avaterIconImage = image;
                }else{
                    [self hideWaitingHUD];
                }
            }];
            
        }else{
            [self hideWaitingHUD];
        }
    }];
}

#pragma mark - ActionSheetCustomPickerDelegate
#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger numberOfRows = 0;
    switch (component) {
        case 0: {
            numberOfRows = self.jobs.count;
            break;
        }
            
        case 1: {
            NSDictionary *province = [self.jobs objectAtIndex:[pickerView selectedRowInComponent:0]];
            
            NSArray *cities = [province objectForKey:@"key2"];
            numberOfRows = [cities count];
            break;
        }
        default:
            break;
    }
    return numberOfRows;
}

#pragma mark UIPickerViewDelegate Implementation
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kScreenWidth/2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = @"";
    switch (component) {
        case 0: {
            title = [[self.jobs objectAtIndex:row] objectForKey:@"key1"];
            break;
        }
        case 1: {
            NSDictionary *province = [self.jobs objectAtIndex:[pickerView selectedRowInComponent:0]];
            NSArray *cities = [province objectForKey:@"key2"];
            if ([cities count] > row) {
                title = [cities objectAtIndex:row];
            } else {
                //                [pickerView reloadAllComponents];
                title = [cities objectAtIndex:0];
            }
            break;
        }
        default:
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
    }
}

#pragma mark - ActionSheetCustomPickerDelegate
- (void)actionSheetPicker:(AbstractActionSheetPicker *)actionSheetPicker configurePickerView:(UIPickerView *)pickerView{
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin {
    
    
        
    UIPickerView *pickerView = (UIPickerView *)actionSheetPicker.pickerView;
    
    NSInteger firstComponentIndex = [pickerView selectedRowInComponent:0];
    NSDictionary *provinceInfo = [self.jobs objectAtIndex:firstComponentIndex];
    
    NSString *jobCategory = [provinceInfo objectForKey:@"key1"];
    
    NSArray *cityList = [provinceInfo objectForKey:@"key2"];
    NSInteger secondComponentIndex = [pickerView selectedRowInComponent:1];
    if (secondComponentIndex >= [cityList count]) {
        secondComponentIndex = 0;
    }
    NSString *jobInfo = [cityList objectAtIndex:secondComponentIndex];
        
    //jobCategory jobInfo
    
    [JSNetworkManager modifyUserInfoWithDict:@{@"jobCategory":jobCategory,@"jobInfo":jobInfo} complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
        if (isSuccess) {
            JSPerfectUserInfoCellModel *model = self.userInfos[0][4];
            model.subTitle = jobInfo;
            [self.tableview reloadRow:4 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

- (void)actionSheetPickerDidCancel:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin {
    
}


- (NSInteger )getAgeWith:(NSDate*)birthday{
    
    //日历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags = NSCalendarUnitYear;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:birthday toDate:[NSDate  date] options:0];
    
    return [components year];
}

//根据生日得到星座
- (NSString *)getConstellationFromBirthday:(NSDate*)birthday{
    
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comp1 = [myCal components:NSCalendarUnitMonth| NSCalendarUnitDay fromDate:birthday];
    
    NSInteger month = [comp1 month];
    
    
    NSInteger day = [comp1 day];
    
    return [self getAstroWithMonth:month day:day];
}
//得到星座的算法
-(NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d{
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    
    NSString *astroFormat = @"102123444543";
    
    NSString *result;
    
    if (m<1||m>12||d<1||d>31){
        
        return @"错误日期格式!";
        
    }
    
    if(m==2 && d>29)
        
    {
        
        return @"错误日期格式!!";
        
    }else if(m==4 || m==6 || m==9 || m==11) {
        
        if (d>30) {
            
            return @"错误日期格式!!!";
            
        }
        
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return [result stringByAppendingString:@"座"];
    
}
@end

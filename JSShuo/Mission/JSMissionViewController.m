//
//  JSMissionViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMissionViewController.h"
#import "JSMissionModel.h"
#import "JSNetworkManager+Mission.h"
#import "YUFoldingTableView.h"
#import "JSMissionCell.h"
#import "JSRedPacketViewController.h"
#import "JSAlertView.h"

@interface JSMissionTableHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *hotImageView;
@property (nonatomic, strong)UIImageView *markImageView;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, strong)JSMissionModel *model;
@end

@implementation JSMissionTableHeaderView

- (void)createCGPath{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithHexString:@"999999"] CGColor]];
    shapeLayer.lineWidth = 1.0f ;
    CGPathMoveToPoint(solidShapePath, NULL, 15, 0);
    CGPathAddLineToPoint(solidShapePath, NULL, 15,17.5);
    CGPathAddEllipseInRect(solidShapePath, nil, CGRectMake(7.50f,  17.50f, 15.0f, 15.0f));
    
    CGPathMoveToPoint(solidShapePath, NULL, 15, 32.5);
    CGPathAddLineToPoint(solidShapePath, NULL, 15,50);
    [shapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [self.layer addSublayer:shapeLayer];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}
- (UIImageView *)hotImageView{
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc]init];
        _hotImageView.image = [UIImage imageNamed:@"js_mession_hot"];
        [_hotImageView sizeToFit];
    }
    return _hotImageView;
}
- (UIImageView *)markImageView{
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc]init];
    }
    return _markImageView;
}
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.textColor = [UIColor colorWithHexString:@"F44336"];
        _subLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subLabel;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createCGPath];
        [self addSubview:self.titleLabel];
        [self addSubview:self.hotImageView];
        [self addSubview:self.markImageView];
        [self addSubview:self.subLabel];
    }
    return self;
}

- (void)setModel:(JSMissionModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    [self.titleLabel sizeToFit];
    
    self.hotImageView.hidden = model.isHot == 1 ? NO : YES;
    self.subLabel.text = model.rewardDescription;
    [self.subLabel sizeToFit];
    
    if (model.rewardType == 1) {
        self.markImageView.image = [UIImage imageNamed:@"js_mession_hongbao"];
    }else if (model.rewardType == 2){
        self.markImageView.image = [UIImage imageNamed:@"js_mession_jinbi"];
    }
    [self.markImageView sizeToFit];
    [self setNeedsLayout];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.left = 30;
    self.hotImageView.left = self.titleLabel.right + 10;
    self.markImageView.right = self.width-10;
    self.subLabel.right = self.markImageView.left - 10;
    
    self.titleLabel.centerY = self.hotImageView.centerY = self.markImageView.centerY = self.subLabel.centerY = self.height/2.0f;
}

@end

@interface JSMissionSignView : UIView
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIImageView *markImageView;
@property (nonatomic, strong)UILabel *goldLabel;
@property (nonatomic, strong)UIImageView *goldIcon;
@property (nonatomic, strong)UILabel *bottomLabel;
@property (nonatomic, strong)JSMissionSignModel *signModel;
@end
@implementation JSMissionSignView

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"js_sign_back"];
    }
    return _backImageView;
}
- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.font = [UIFont systemFontOfSize:14];
        _bottomLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}
- (UIImageView *)markImageView{
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc]init];
        _markImageView.image = [UIImage imageNamed:@"js_mession_sgin_success"];
        
        [_markImageView sizeToFit];
        _markImageView.hidden = YES;
    }
    return _markImageView;
}
- (UILabel *)goldLabel{
    if (!_goldLabel) {
        _goldLabel = [[UILabel alloc]init];
        _goldLabel.font = [UIFont systemFontOfSize:14];
        _goldLabel.textColor = [UIColor whiteColor];
        _goldLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goldLabel;
}
- (UIImageView *)goldIcon{
    if (!_goldIcon) {
        _goldIcon = [[UIImageView alloc]init];
        _goldIcon.image = [UIImage imageNamed:@"js_mission_sgin_gold"];
        [_goldIcon sizeToFit];
    }
    return _goldIcon;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backImageView];
        [self addSubview:self.markImageView];
        [self addSubview:self.goldIcon];
        [self addSubview:self.goldLabel];
        [self addSubview:self.bottomLabel];
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.right.equalTo(self).offset(-5);
            make.height.mas_equalTo(self.backImageView.mas_width);
        }];
        [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.markImageView.size);
            make.right.equalTo(self);
            make.centerY.mas_equalTo(self.backImageView.mas_bottom).offset(-4);
        }];
        [self.goldIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.goldIcon.size);
            make.centerX.equalTo(self.backImageView);
            CGFloat tap = (self.width - self.goldIcon.height - 20)/2.0f;
            make.top.mas_equalTo(tap);
        }];
        [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.goldIcon.mas_bottom);
        }];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}
- (void)configSignModel:(JSMissionSignModel *)signModel withCountDay:(NSInteger)countDayIndex{
    _signModel = signModel;
    if (signModel.signInRuleId <= countDayIndex) {
        self.backImageView.image = [UIImage imageNamed:@"js_unsign_back"];
        self.markImageView.hidden = NO;
        self.goldIcon.hidden = YES;
        self.goldLabel.text = [NSString stringWithFormat:@"+%@",@(signModel.rewardCoin).stringValue];
        self.goldLabel.textColor = [UIColor colorWithHexString:@"F44336"];
        
        self.bottomLabel.textColor = [UIColor whiteColor];
//        self.bottomLabel.text = @(signModel.signInRuleId).stringValue;
        
        [self.goldLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backImageView);
        }];
        
    }else{
        self.backImageView.image = [UIImage imageNamed:@"js_sign_back"];
        self.markImageView.hidden = YES;
        self.goldIcon.hidden = NO;
        self.goldLabel.text = @(signModel.rewardCoin).stringValue;
        self.goldLabel.textColor = [UIColor whiteColor];
        self.bottomLabel.textColor = [UIColor colorWithHexString:@"333333"];
//        self.bottomLabel.text = @(signModel.signInRuleId).stringValue;
    }
    self.bottomLabel.text = [NSString stringWithFormat:@"%@天",@(signModel.signInRuleId).stringValue];;
}

@end

@interface JSMissionViewHeader : UIView
@property (nonatomic, strong)UIImageView *titleBackImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIView *topBackView;
@property (nonatomic, strong)UIView *bottomBackView;
@property (nonatomic, strong)UIImageView *bottomImageView;

@property (nonatomic, strong)NSMutableArray *signViews;
@property (nonatomic, strong)NSArray *signModes;
@end

@implementation JSMissionViewHeader

- (UIImageView *)titleBackImageView{
    if (!_titleBackImageView) {
        _titleBackImageView = [[UIImageView alloc]init];
        _titleBackImageView.image = [UIImage imageNamed:@"js_mession_sign_head_back"];
        [_titleBackImageView sizeToFit];
    }
    return _titleBackImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"B81E13"];
        _titleLabel.text = @"明日签到可领金币";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UIImageView *)bottomImageView{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc]init];
        _bottomImageView.image = [UIImage imageNamed:@"js_mission_header_bottom"];
        [_bottomImageView sizeToFit];
    }
    return _bottomImageView;
}
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20+26+20+kScreenWidth/7.0f+40)];
        _topBackView.backgroundColor = [UIColor colorWithHexString:@"F44336"];
        
    }
    return _topBackView;
}
- (UIView *)bottomBackView{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc]init];
    }
    return _bottomBackView;
}
- (NSMutableArray *)signViews{
    if (!_signViews) {
        _signViews = [NSMutableArray array];
    }
    return _signViews;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topBackView];
        [self.topBackView addSubview:self.titleBackImageView];
        [self.topBackView addSubview:self.titleLabel];
        [self addSubview:self.bottomBackView];
        [self.bottomBackView addSubview:self.bottomImageView];
        
        [self.topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.topBackView.size);
            make.left.top.equalTo(self);
        }];
        [self.titleBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleBackImageView.size);
            make.top.equalTo(self.topBackView).offset(20);
            make.centerX.equalTo(self.topBackView);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel.size);
            make.centerX.mas_equalTo(self.titleBackImageView.mas_centerX);
            make.centerY.mas_equalTo(self.titleBackImageView.mas_centerY);
        }];
        [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.mas_equalTo(self.topBackView.mas_bottom);
        }];
        [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-20, (kScreenWidth-20)/5.16));
            make.center.equalTo(self.bottomBackView);
        }];
        UIView * tempView = nil;
        for (int i=0; i<7; i++) {
            JSMissionSignView *signView = [[JSMissionSignView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/7.0, kScreenWidth/7.0+40)];
            
            [self.topBackView addSubview:signView];
            [self.signViews addObject:signView];
            
            if (i==0) {
                [signView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.topBackView).offset(5);
                    make.height.mas_equalTo(kScreenWidth/7.0+40);
                    make.top.mas_equalTo(self.titleBackImageView.mas_bottom).offset(20);
                }];
            }else if (i==6){
                [signView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(tempView.mas_right);
                    make.right.equalTo(self.topBackView);
                    make.height.mas_equalTo(kScreenWidth/7.0+40);
                    make.top.mas_equalTo(self.titleBackImageView.mas_bottom).offset(20);
                    make.width.equalTo(tempView);
                }];
            }else{
                [signView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(tempView.mas_right);
                    make.top.mas_equalTo(self.titleBackImageView.mas_bottom).offset(20);
                    make.height.mas_equalTo(kScreenWidth/7.0+40);
                    make.width.equalTo(tempView);
                }];
            
            }
            
            tempView = signView;
            
        }
    }
    return self;
}

- (void)configSignModels:(NSArray *)signModels withSignDay:(NSInteger)countDay{
    _signModes = signModels;
    for (int i=0; i<signModels.count; i++) {
        JSMissionSignModel *model = signModels[i];
        JSMissionSignView *signView = self.signViews[i];
        [signView configSignModel:model withCountDay:countDay];
    }
}

@end


@interface JSMissionViewController ()<YUFoldingTableViewDelegate>
@property (nonatomic, strong)YUFoldingTableView *tableView;
@property (nonatomic, strong)JSMissionViewHeader *headerView;

@property (nonatomic, strong)NSMutableArray *newTaskList;
@property (nonatomic, strong)NSMutableArray *dayTaskList;

@property (nonatomic, strong)UIView *floatView;

@end

@implementation JSMissionViewController

- (UIView *)floatView{
    if (!_floatView) {
        _floatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 54, 57)];
        UIImageView *upImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"js_mession_mark"]];
        [upImageView sizeToFit];
        
        UIImageView *downImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"js_mession_linghongbao"]];
        [downImageView sizeToFit];
        
        [_floatView addSubview:upImageView];
        [_floatView addSubview:downImageView];
        
        [upImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(upImageView.size);
            make.top.equalTo(self.floatView);
            make.centerX.equalTo(self.floatView);
        }];
        [downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(downImageView.size);
            make.top.equalTo(upImageView.mas_bottom);
            make.centerX.equalTo(downImageView);
        }];
        @weakify(self)
        [_floatView bk_whenTapped:^{
            @strongify(self)
            JSRedPacketViewController *redPackVC = [[JSRedPacketViewController alloc]init];
            redPackVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:redPackVC animated:YES complete:nil];
        }];
    }
    return _floatView;
}
- (NSMutableArray *)newTaskList{
    if (!_newTaskList) {
        _newTaskList = [NSMutableArray array];
    }
    return _newTaskList;
}
- (NSMutableArray *)dayTaskList{
    if (!_dayTaskList) {
        _dayTaskList = [NSMutableArray array];
    }
    return _dayTaskList;
}
- (JSMissionViewHeader *)headerView{
    if (!_headerView) {
        _headerView = [[JSMissionViewHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20+26+20+kScreenWidth/7.0f+40+90)];
    }
    return _headerView;
}
- (YUFoldingTableView *)tableView{
    if (!_tableView) {
        _tableView = [[YUFoldingTableView alloc]initWithFrame:self.view.bounds];
        _tableView.foldingDelegate = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.foldingState = YUFoldingSectionStateFlod;
        [_tableView registerClass:[JSMissionSubCell class] forCellReuseIdentifier:@"JSMissionSubCell"];
        [_tableView registerClass:[JSMissionTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"JSMissionTableHeaderView"];
        [_tableView registerClass:[JSMissionCell class] forCellReuseIdentifier:@"JSMissionCell"];
        _tableView.sectionStateArray = @[@"0",@"1"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self requestSignTask];
        }];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.floatView];
    [self.floatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.floatView.size);
        make.right.equalTo(self.view).offset(-20);
        
        make.bottom.equalTo(self.view).offset(-30);
    }];
    [self requestSignTask];
}
- (void)requestSignTask{
    [JSNetworkManager requestSignCreateComplement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        if (isSuccess) {
            //弹框
            NSDictionary *rewardDict = contentDict[@"reward"];
            JSMissionRewardModel *rewardModel = [MTLJSONAdapter modelOfClass:[JSMissionRewardModel class] fromJSONDictionary:rewardDict error:nil];
            if (rewardModel.rewardCode == 0) {//成功
                //弹框
                [JSAlertView showAlertViewWithType:JSALertTypeGold rewardModel:rewardModel superView:self.navigationController.view handle:^{
                    
                }];
//                [self showAutoDismissTextAlert:@"签到成功"];
                
            }
            [JSNetworkManager requestMissonRulComplement:^(BOOL isSuccess, NSDictionary *contentDict) {
                if (isSuccess) {
                    NSArray *rulesArray = contentDict[@"rules"];
                    NSError *error = nil;
                    NSArray *array = [MTLJSONAdapter modelsOfClass:[JSMissionSignModel class] fromJSONArray:rulesArray error:&error];
                    NSDictionary *infoDict = contentDict[@"info"];
                    NSInteger signDays = [infoDict[@"continueDay"] integerValue];
                    [self.headerView configSignModels:array withSignDay:signDays];
                }
            }];
        }
        
    }];
    [JSNetworkManager requestTaskListComplement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        [self.tableView.mj_header endRefreshing];
        if (isSuccess) {
            NSArray *dailyArray = contentDict[@"daily"];
            NSArray *newHandArray = contentDict[@"newHand"];
            
            NSArray *newTaskModels = [MTLJSONAdapter modelsOfClass:[JSMissionModel class] fromJSONArray:newHandArray error:nil];
            self.newTaskList = [NSMutableArray arrayWithArray:newTaskModels];
            
            NSArray *dayTaskModels = [MTLJSONAdapter modelsOfClass:[JSMissionModel class] fromJSONArray:dailyArray error:nil];
            
            self.dayTaskList = [NSMutableArray arrayWithArray:dayTaskModels];
            
            [self.tableView reloadData];
        }
    }];
}
- (void)userLoginSuccessNoti:(NSNotification *)notification{
    [self requestSignTask];
}

#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    return 2;
}
- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
    return section == 0 ? self.newTaskList.count : self.dayTaskList.count;
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
{
    return 50;
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([self.newTaskList[indexPath.row] isKindOfClass:[NSString class]]){
            JSMissionModel *model = self.newTaskList[indexPath.row-1];
            return [JSMissionSubCell heightForString:model.misDescription];
        }
    }else{
        if ([self.dayTaskList[indexPath.row] isKindOfClass:[NSString class]]) {
            JSMissionModel *model = self.dayTaskList[indexPath.row-1];
            return [JSMissionSubCell heightForString:model.misDescription];
        }
    }
    return 50;
}
- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if ([self.newTaskList[indexPath.row] isKindOfClass:[JSMissionModel class]]) {
            JSMissionCell *subCell = [yuTableView dequeueReusableCellWithIdentifier:@"JSMissionCell" forIndexPath:indexPath];
            JSMissionModel *model = self.newTaskList[indexPath.row];
            subCell.model = model;
            cell = subCell;
        }else{
            NSString *text = self.newTaskList[indexPath.row];
            JSMissionSubCell *subCell = [yuTableView dequeueReusableCellWithIdentifier:@"JSMissionSubCell" forIndexPath:indexPath];
            subCell.subText = text;
            cell = subCell;
        }
    }else if (indexPath.section == 1){
        if ([self.dayTaskList[indexPath.row] isKindOfClass:[JSMissionModel class]]) {
            JSMissionCell *subCell = [yuTableView dequeueReusableCellWithIdentifier:@"JSMissionCell" forIndexPath:indexPath];
            JSMissionModel *model = self.dayTaskList[indexPath.row];
            subCell.model = model;
            cell = subCell;
        }else{
            NSString *text = self.dayTaskList[indexPath.row];
            JSMissionSubCell *subCell = [yuTableView dequeueReusableCellWithIdentifier:@"JSMissionSubCell" forIndexPath:indexPath];
            subCell.subText = text;
            cell = subCell;
        }
    }
    return cell;
}
#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = section == 0 ? @"新手任务":@"日常任务";
    return title;
}

- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([self.newTaskList[indexPath.row] isKindOfClass:[JSMissionModel class]]) {
            JSMissionModel *model = self.newTaskList[indexPath.row];
            
            if (model.isOpen) {
                
                NSIndexPath *path =[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                [self.newTaskList removeObjectAtIndex:indexPath.row+1];
                model.isOpen = NO;
                [yuTableView beginUpdates];
                [yuTableView deleteRowAtIndexPath:path withRowAnimation:UITableViewRowAnimationBottom];
                [yuTableView endUpdates];
                
            }else{
                NSIndexPath *path =[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                [self.newTaskList insertObject:model.misDescription atIndex:indexPath.row+1];
                model.isOpen =YES;
                
                [yuTableView beginUpdates];
                [yuTableView insertRowAtIndexPath:path withRowAnimation:UITableViewRowAnimationBottom];
                [yuTableView endUpdates];
            }
            JSMissionCell *cell = [yuTableView cellForRowAtIndexPath:indexPath];
            cell.isOpen = model.isOpen;
        }

    }else if (indexPath.section == 1){
        if ([self.dayTaskList[indexPath.row] isKindOfClass:[JSMissionModel class]]) {
            JSMissionModel *model = self.dayTaskList[indexPath.row];
            if (model.isOpen) {
                
                NSIndexPath *path =[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                [self.dayTaskList removeObjectAtIndex:indexPath.row+1];
                model.isOpen = NO;
                [yuTableView beginUpdates];
                [yuTableView deleteRowAtIndexPath:path withRowAnimation:UITableViewRowAnimationBottom];
                [yuTableView endUpdates];
                
            }else{
                NSIndexPath *path =[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                [self.dayTaskList insertObject:model.misDescription atIndex:indexPath.row+1];
                model.isOpen =YES;
                
                [yuTableView beginUpdates];
                [yuTableView insertRowAtIndexPath:path withRowAnimation:UITableViewRowAnimationBottom];
                [yuTableView endUpdates];
            }
            JSMissionCell *cell = [yuTableView cellForRowAtIndexPath:indexPath];
            cell.isOpen = model.isOpen;
        }
    }
}

//// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    
    return YUFoldingSectionHeaderArrowPositionRight;
}


- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger)section
{

    return [UIColor groupTableViewBackgroundColor];
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger)section
{
    return [UIColor colorWithHexString:@"333333"];
}
- (UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForTitleInSection:(NSInteger )section{
    return [UIFont boldSystemFontOfSize:16];
}




@end

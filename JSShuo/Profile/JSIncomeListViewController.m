//
//  JSIncomeListViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/16.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSIncomeListViewController.h"
#import "JSWalletSwitchSegmentView.h"
#import "JSNetworkManager+Login.h"
#import "JSAccountModel.h"

@interface JSIncomeListCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel_1;
@property (nonatomic, strong)UILabel *titleLabel_2;
@property (nonatomic, strong)UILabel *titleLabel_3;
@property (nonatomic, strong)UILabel *titleLabel_4;
@property (nonatomic, strong)UIView *line;
@end

@implementation JSIncomeListCell

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    }
    return _line;
}
- (UILabel *)titleLabel_1{
    if (!_titleLabel_1) {
        _titleLabel_1 = [[UILabel alloc]init];
        _titleLabel_1.font = [UIFont systemFontOfSize:11];
        _titleLabel_1.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel_1.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel_1;
}

- (UILabel *)titleLabel_2{
    if (!_titleLabel_2) {
        _titleLabel_2 = [[UILabel alloc]init];
        _titleLabel_2.font = [UIFont systemFontOfSize:11];
        _titleLabel_2.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel_2.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel_2;
}

- (UILabel *)titleLabel_3{
    if (!_titleLabel_3) {
        _titleLabel_3 = [[UILabel alloc]init];
        _titleLabel_3.font = [UIFont systemFontOfSize:11];
        _titleLabel_3.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel_3.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel_3;
}

- (UILabel *)titleLabel_4{
    if (!_titleLabel_4) {
        _titleLabel_4 = [[UILabel alloc]init];
        _titleLabel_4.font = [UIFont systemFontOfSize:11];
        _titleLabel_4.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel_4.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel_4;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"ED9D49"];
        [self.contentView addSubview:self.titleLabel_1];
        [self.contentView addSubview:self.titleLabel_2];
        [self.contentView addSubview:self.titleLabel_3];
        [self.contentView addSubview:self.titleLabel_4];
        [self.contentView addSubview:self.line];
        
        self.titleLabel_1.backgroundColor = [UIColor whiteColor];
        self.titleLabel_2.backgroundColor = [UIColor whiteColor];
        self.titleLabel_3.backgroundColor = [UIColor whiteColor];
        self.titleLabel_4.backgroundColor = [UIColor whiteColor];
        [self.titleLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.bottom.equalTo(self.contentView);
            make.right.mas_equalTo(self.titleLabel_2.mas_left);
            
            make.width.mas_equalTo(self.titleLabel_2.mas_width);
            make.width.mas_equalTo(self.titleLabel_3.mas_width);
            make.width.mas_equalTo(self.titleLabel_4.mas_width);
        }];
        
        [self.titleLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel_1.mas_right);
            make.top.bottom.equalTo(self.contentView);
            make.right.mas_equalTo(self.titleLabel_3.mas_left);
            
            make.width.mas_equalTo(self.titleLabel_1.mas_width);
            make.width.mas_equalTo(self.titleLabel_3.mas_width);
            make.width.mas_equalTo(self.titleLabel_4.mas_width);
        }];
        
        [self.titleLabel_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel_2.mas_right);
            make.top.bottom.equalTo(self.contentView);
            make.right.mas_equalTo(self.titleLabel_4.mas_left);
            
            make.width.mas_equalTo(self.titleLabel_1.mas_width);
            make.width.mas_equalTo(self.titleLabel_2.mas_width);
            make.width.mas_equalTo(self.titleLabel_4.mas_width);
        }];
        
        [self.titleLabel_4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel_3.mas_right);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            
            make.width.mas_equalTo(self.titleLabel_1.mas_width);
            make.width.mas_equalTo(self.titleLabel_2.mas_width);
            make.width.mas_equalTo(self.titleLabel_3.mas_width);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel_1.mas_left);
            make.right.mas_equalTo(self.titleLabel_4.mas_right);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)configModel:(JSListModel *)model withIndex:(NSInteger)index{
    self.titleLabel_1.text = @(index).stringValue;
    self.titleLabel_2.text = @(model.userId).stringValue;
    self.titleLabel_3.text = @(model.friendNum).stringValue;
    self.titleLabel_4.text = @(model.totalCoin).stringValue;
}
@end

@interface JSIncomeListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)JSWalletSwitchSegmentView *switchView;

@property (nonatomic, assign)BOOL isWeakList;
@property (nonatomic, strong)NSMutableArray *weakListArray;
@property (nonatomic, strong)NSMutableArray *totalListArray;
@end

@implementation JSIncomeListViewController


- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        
    }
    return _headerView;
}
- (NSMutableArray *)weakListArray{
    if (!_weakListArray) {
        _weakListArray = [NSMutableArray array];
    }
    return _weakListArray;
}
- (NSMutableArray *)totalListArray{
    if (!_totalListArray) {
        _totalListArray = [NSMutableArray array];
    }
    return _totalListArray;
}

- (JSWalletSwitchSegmentView *)switchView{
    if (!_switchView) {
        _switchView = [[JSWalletSwitchSegmentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 48)];
        [_switchView.optionButtonLeft setTitle:@"周排行" forState:UIControlStateNormal];
        [_switchView.optionButtonRight setTitle:@"总排行" forState:UIControlStateNormal];
        _switchView.backgroundColor = [UIColor whiteColor];
        
    }
    return _switchView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self setUpHeaderView];
        _tableView.tableFooterView = [self setUpFooterView];
        [_tableView registerClass:[JSIncomeListCell class] forCellReuseIdentifier:@"JSIncomeListCell"];
        
    }
    return _tableView;
}

- (UIView *)setUpHeaderView{
    UIImageView *backImageView = [[UIImageView alloc]init];//117
    backImageView.image = [UIImage imageNamed:@"js_profile_income_list_head"];
    
    [self.headerView addSubview:backImageView];
    
    UIView *backView = [[UIView alloc]init];//48
    backView.backgroundColor = [UIColor colorWithHexString:@"ED9D49"];
    [self.headerView addSubview:backView];
    
    [backView addSubview:self.switchView];
    
    self.headerView.size = CGSizeMake(kScreenWidth, 205);
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.headerView);
        make.height.mas_equalTo(117);
    }];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.headerView);
        make.height.mas_equalTo(88);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.right.equalTo(backView).offset(-10);
        make.top.equalTo(backView);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *titleLabel1 = [[UILabel alloc]init];
    titleLabel1.font = [UIFont boldSystemFontOfSize:12];
    titleLabel1.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel1.text = @"排名";
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel1];
    
    UILabel *titleLabel2 = [[UILabel alloc]init];
    titleLabel2.font = [UIFont boldSystemFontOfSize:12];
    titleLabel2.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel2.text = @"用户ID";
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel2];
    
    UILabel *titleLabel3 = [[UILabel alloc]init];
    titleLabel3.font = [UIFont boldSystemFontOfSize:12];
    titleLabel3.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel3.text = @"好友数";
    titleLabel3.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel3];
    
    UILabel *titleLabel4 = [[UILabel alloc]init];
    titleLabel4.font = [UIFont boldSystemFontOfSize:12];
    titleLabel4.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel4.text = @"总收入";
    titleLabel4.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel4];
    
    titleLabel1.backgroundColor = [UIColor whiteColor];
    titleLabel2.backgroundColor = [UIColor whiteColor];
    titleLabel3.backgroundColor = [UIColor whiteColor];
    titleLabel4.backgroundColor = [UIColor whiteColor];
    
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.right.mas_equalTo(titleLabel2.mas_left);
        make.top.mas_equalTo(self.switchView.mas_bottom);
        make.height.mas_equalTo(40);
        
        make.width.mas_equalTo(titleLabel2);
        make.width.mas_equalTo(titleLabel3);
        make.width.mas_equalTo(titleLabel4);
    }];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel1.mas_right);
        make.right.mas_equalTo(titleLabel3.mas_left);
        make.top.mas_equalTo(titleLabel1.mas_top);
        make.height.mas_equalTo(40);
        
        make.width.mas_equalTo(titleLabel1);
        make.width.mas_equalTo(titleLabel3);
        make.width.mas_equalTo(titleLabel4);
    }];
    [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel2.mas_right);
        make.right.mas_equalTo(titleLabel4.mas_left);
        make.top.mas_equalTo(self.switchView.mas_bottom);
        make.height.mas_equalTo(40);
        
        make.width.mas_equalTo(titleLabel2);
        make.width.mas_equalTo(titleLabel1);
        make.width.mas_equalTo(titleLabel4);
    }];
    [titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel3.mas_right);
        make.right.mas_equalTo(self.switchView.mas_right);
        make.top.mas_equalTo(self.switchView.mas_bottom);
        make.height.mas_equalTo(40);
        
        make.width.mas_equalTo(titleLabel2);
        make.width.mas_equalTo(titleLabel3);
        make.width.mas_equalTo(titleLabel1);
    }];
    
    
    return self.headerView;
}
- (UIView *)setUpFooterView{
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor colorWithHexString:@"ED9D49"];
    footerView.size = CGSizeMake(kScreenWidth, 20);
    return footerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收入榜";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isWeakList = YES;
    
    @weakify(self)
    self.switchView.selectedIndexChangedHandler = ^(NSUInteger index) {
        @strongify(self);
        self.isWeakList = index == 0 ? YES : NO;
        
        [self.tableView reloadData];
    };
    
    [JSNetworkManager questListWithWeak:YES complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        if (isSuccess) {
            NSArray *listArray = contentDict[@"list"];
            for (NSDictionary *dict in listArray) {
                JSListModel *model = [MTLJSONAdapter modelOfClass:[JSListModel class] fromJSONDictionary:dict error:nil];
                [self.weakListArray addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
    [JSNetworkManager questListWithWeak:NO complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        if (isSuccess) {
            NSArray *listArray = contentDict[@"list"];
            for (NSDictionary *dict in listArray) {
                JSListModel *model = [MTLJSONAdapter modelOfClass:[JSListModel class] fromJSONDictionary:dict error:nil];
                [self.totalListArray addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isWeakList ? self.weakListArray.count : self.totalListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSIncomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSIncomeListCell" forIndexPath:indexPath];
    JSListModel *model = self.isWeakList ? self.weakListArray[indexPath.row] : self.totalListArray[indexPath.row];
    [cell configModel:model withIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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

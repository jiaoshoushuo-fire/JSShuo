//
//  JSMyApprenticeViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/20.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMyApprenticeViewController.h"

#import "JSNetworkManager+Login.h"
#import "JSShareManager.h"



@implementation JSMyApprenticeCell

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
        _iconImage.size = CGSizeMake(42, 42);
        _iconImage.clipsToBounds = YES;
        _iconImage.layer.cornerRadius = 21;
        _iconImage.image = [UIImage imageNamed:@"js_profile_default_icon"];
    }
    return _iconImage;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _backView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _timeLabel;
}
- (UIButton *)weakupButton{
    if (!_weakupButton) {
        _weakupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _weakupButton.size = CGSizeMake(90, 35);
        _weakupButton.backgroundColor = [UIColor colorWithHexString:@"F44336"];
        [_weakupButton setTitle:@"唤醒徒弟" forState:UIControlStateNormal];
        [_weakupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _weakupButton.clipsToBounds = YES;
        _weakupButton.layer.cornerRadius = 5;
        _weakupButton.layer.borderColor = [[UIColor colorWithHexString:@"F44336"]CGColor];
        _weakupButton.layer.borderWidth = 1.0f;
        @weakify(self)
        [_weakupButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWeakupButton:)]) {
                [self.delegate didSelectedWeakupButton:self.model];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _weakupButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.iconImage];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.timeLabel];
        [self.backView addSubview:self.weakupButton];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42, 42));
            make.left.equalTo(self.backView).offset(3);
            make.centerY.equalTo(self.backView);
        }];
        [self.weakupButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.weakupButton.size);
            make.right.equalTo(self.backView).offset(-10);
            make.centerY.equalTo(self.backView);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
            make.top.mas_equalTo(self.iconImage.mas_top);
            make.right.mas_equalTo(self.weakupButton.mas_left).offset(-10);
            make.height.mas_equalTo(20);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(self.titleLabel.mas_right);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }];
    }
    return self;
}
- (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//根据自己的需求定义格式
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    return time;
}
- (NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
    
}
- (void)setModel:(JSApprentModel *)model withType:(JSMyApprenticeCellType)type{
    _model = model;
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.portrait] placeholder:nil];
    self.titleLabel.text = model.nickname;
    self.timeLabel.text = model.lastLoginTime;
    
//    NSTimeInterval durationTime = [self pleaseInsertStarTime:model.lastLoginTime andInsertEndTime:[self getCurrentTimes]];
    if (model.canWakeUp) {
        self.weakupButton.enabled = YES;
        self.weakupButton.backgroundColor = [UIColor colorWithHexString:@"F44336"];
        [self.weakupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.weakupButton.layer.borderColor = [[UIColor colorWithHexString:@"F44336"]CGColor];
    }else{
        self.weakupButton.enabled = NO;
        self.weakupButton.backgroundColor = [UIColor whiteColor];
        [self.weakupButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        self.weakupButton.layer.borderColor = [[UIColor colorWithHexString:@"999999"]CGColor];
    }
    if (type == JSMyApprenticeCellTypeNormalList){
        self.weakupButton.hidden = YES;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
            make.right.mas_equalTo(self.timeLabel.mas_left).offset(-10);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(self.backView);
        }];
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(130, 20));
            make.right.equalTo(self.backView).offset(-10);
            make.centerY.equalTo(self.backView);
        }];
    }
}
@end


@interface JSMyApprenticeViewController ()<UITableViewDelegate,UITableViewDataSource,JSMyApprenticeCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger currentPage;

@property (nonatomic, strong)UILabel *nodataLabel;

@end

@implementation JSMyApprenticeViewController

- (UILabel *)nodataLabel{
    if (!_nodataLabel) {
        _nodataLabel = [[UILabel alloc]init];
        _nodataLabel.text = @"暂无数据";
        [_nodataLabel sizeToFit];
        _nodataLabel.hidden = YES;
    }
    return _nodataLabel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JSMyApprenticeCell class] forCellReuseIdentifier:@"JSMyApprenticeCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self refreshDataWithHeaderRefresh:YES];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self refreshDataWithHeaderRefresh:NO];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)refreshDataWithHeaderRefresh:(BOOL)isHeaderRefresh{
    if (isHeaderRefresh) {
        self.currentPage = 1;
        [self.dataArray removeAllObjects];
    }else{
        self.currentPage ++;
    }
    
    [JSNetworkManager requestApprenticeListWithPageIndex:self.currentPage complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (isSuccess) {
            NSArray *listArray = contentDict[@"list"];
            for (NSDictionary *dict in listArray) {
                JSApprentModel *model = [MTLJSONAdapter modelOfClass:[JSApprentModel class] fromJSONDictionary:dict error:nil];
                [self.dataArray addObject:model];
            }
//            for (int i=0; i<10; i++) {
//                JSApprentModel *model = [[JSApprentModel alloc]init];
//                model.portrait = @"https://192.168.21.49/php/Icon.png";
//                model.nickname = @"张三张三";
//                model.lastLoginTime = @"2018-11-28 23:00:00";
//                [self.dataArray addObject:model];
//            }
            
            if (listArray.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (self.dataArray.count <= 0) {
                self.nodataLabel.hidden = NO;
                self.tableView.hidden = YES;
            }else{
                self.nodataLabel.hidden = YES;
                self.tableView.hidden = NO;
            }
            
            [self.tableView reloadData];
        }else{
            if (!isHeaderRefresh) {
                self.currentPage --;
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的徒弟";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nodataLabel];
    
    [self.nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.nodataLabel.size);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(150);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSMyApprenticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSMyApprenticeCell" forIndexPath:indexPath];
    JSApprentModel *model = self.dataArray[indexPath.row];
    [cell setModel:model withType:self.celltype];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark - JSMyApprenticeCellDelegate
- (void)didSelectedWeakupButton:(JSApprentModel *)model{
    //点击唤醒
    [JSShareManager shareWithTitle:@"叫兽说" Text:@"亲~想你了！叫兽说特别赠送您200~10000金币，当天不领作废！您的账户余额很高，速速回来领取哦，只要阅读3篇文章即有机会获得高额奖励！（如果您找不到叫兽说APP，可以在手机应用市场搜索 叫兽说 重新下载，奖励仍然有效）" Image:[UIImage imageNamed:@"js_share_image"] Url:nil QQImageURL:kShareQQImage_3 shareType:JSShareManagerTypeQQWeChat complement:^(BOOL isSuccess) {
        if (isSuccess) {
            [self showAutoDismissTextAlert:@"分享成功"];
        }else{
            [self showAutoDismissTextAlert:@"分享失败"];
        }
    }];
}

@end

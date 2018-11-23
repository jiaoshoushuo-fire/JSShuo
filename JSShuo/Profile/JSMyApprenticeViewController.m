//
//  JSMyApprenticeViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/20.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMyApprenticeViewController.h"
#import "JSCollectModel.h"
#import "JSNetworkManager+Login.h"

@protocol JSMyApprenticeCellDelegate <NSObject>

- (void)didSelectedWeakupButton:(JSApprentModel *)model;

@end

@interface JSMyApprenticeCell : UITableViewCell
@property (nonatomic, strong)UIImageView *iconImage;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIButton *weakupButton;
@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)JSApprentModel *model;

@property (nonatomic, weak)id<JSMyApprenticeCellDelegate>delegate;
@end
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
- (void)setModel:(JSApprentModel *)model{
    _model = model;
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.portrait] placeholder:nil];
    self.titleLabel.text = model.nickname;
    self.timeLabel.text = model.lastLoginTime;
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
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark - JSMyApprenticeCellDelegate
- (void)didSelectedWeakupButton:(JSApprentModel *)model{
    //点击唤醒
}

@end

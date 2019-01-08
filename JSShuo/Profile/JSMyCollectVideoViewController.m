//
//  JSMyCollectVideoViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/19.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMyCollectVideoViewController.h"
#import "JSCollectModel.h"
#import "JSNetworkManager+Login.h"
#import "JSVideoDetailViewController.h"

@interface JSMyCollectVideoCell : UITableViewCell

@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *contentImageView;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIButton *deleteButton;
@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)JSCollectModel *model;
@property (nonatomic, weak)id <JSMyCollectArticleCellDelegate>delegate;

@end

@implementation JSMyCollectVideoCell

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
    }
    return _titleLabel;
}
- (UIImageView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc]init];
        _contentImageView.size = CGSizeMake(kScreenWidth-40, (kScreenWidth-40)/16.0f * 9);
//        _contentImageView.backgroundColor = [UIColor randomColor];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
    }
    return _contentImageView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _timeLabel;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor colorWithHexString:@"F44336"] forState:UIControlStateNormal];
        _deleteButton.size = CGSizeMake(60, 22);
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _deleteButton.clipsToBounds = YES;
        _deleteButton.layer.cornerRadius = 11;
        _deleteButton.layer.borderColor = [[UIColor colorWithHexString:@"F44336"]CGColor];
        _deleteButton.layer.borderWidth = 0.5;
        @weakify(self)
        [_deleteButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDeleateButton:)]) {
                [self.delegate didSelectedDeleateButton:self.model];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    }
    return _lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.contentImageView];
        [self.backView addSubview:self.deleteButton];
        [self.backView addSubview:self.timeLabel];
        [self.backView addSubview:self.lineView];
    }
    return self;
}

- (void)setModel:(JSCollectModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
//    self.contentLabel.text = model.channel;
    [self.contentImageView setImageWithURL:[NSURL URLWithString:model.cover.firstObject] placeholder:nil];
    self.timeLabel.text = model.publishTime;
    
    [self.titleLabel sizeToFit];
    [self.timeLabel sizeToFit];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat height = self.contentImageView.height;//[self.contentLabel sizeThatFits:CGSizeMake(kScreenWidth-40, MAXFLOAT)].height;
    self.titleLabel.left = self.titleLabel.top = 10;
    
    self.contentImageView.left = self.titleLabel.left;
    self.contentImageView.top = self.titleLabel.bottom + 10;
//    self.contentLabel.size = CGSizeMake(kScreenWidth-40, height);
    
    self.lineView.left = self.titleLabel.left;
    self.lineView.width = kScreenWidth-20;
    self.lineView.top = self.contentImageView.bottom + 10;
    self.lineView.height = 0.5;
    
    self.deleteButton.right = self.lineView.width - 10;
    self.deleteButton.top = self.lineView.bottom + 10;
    
    self.timeLabel.centerY = self.deleteButton.centerY;
    self.timeLabel.left = self.titleLabel.left;
    
    self.backView.frame = CGRectMake(10, 10, kScreenWidth-20, 10 + 22 +10 + 10 + height + 10 + 20 + 10);
}

+ (CGFloat)heightForRowWithModel:(JSCollectModel *)model{
    CGFloat height = 10 + 10 + 20 + 10 ;
    CGFloat contentHeight = (kScreenWidth-40)/16.0f*9;
    height += contentHeight;
    height += 10;
    height += 42;
    return height;
}

@end

@interface JSMyCollectVideoViewController ()<UITableViewDelegate,UITableViewDataSource,JSMyCollectArticleCellDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger currentPage;

@property (nonatomic, strong)UILabel *nodataLabel;


@end

@implementation JSMyCollectVideoViewController


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
        [_tableView registerClass:[JSMyCollectVideoCell class] forCellReuseIdentifier:@"JSMyCollectVideoCell"];
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
    
    [JSNetworkManager requestCollectListWithType:3 pageNumber:self.currentPage complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (isSuccess) {
            NSArray *listArray = contentDict[@"list"];
            for (NSDictionary *dict in listArray) {
                JSCollectModel *model = [MTLJSONAdapter modelOfClass:[JSCollectModel class] fromJSONDictionary:dict error:nil];
                [self.dataArray addObject:model];
            }
            
//            for (int i=0; i<10; i++) {
//                JSCollectModel *model = [[JSCollectModel alloc]init];
//                model.title = @"这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥";
//                model.channel = @"这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥";
//                model.publishTime = @"1018-11-11 11:11:11";
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSMyCollectVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSMyCollectVideoCell" forIndexPath:indexPath];
    JSCollectModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JSVideoDetailViewController *vc = [[JSVideoDetailViewController alloc]init];
    JSCollectModel *model = self.dataArray[indexPath.row];
    
    vc.articleId = @(model.articleId);
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSCollectModel *model = self.dataArray[indexPath.row];
    return [JSMyCollectVideoCell heightForRowWithModel:model];
}

#pragma mark - JSMyCollectArticleCellDelegate
- (void)didSelectedDeleateButton:(JSCollectModel *)model{
    [self showWaitingHUD];
    [JSNetworkManager requestDeleateCollectWithID:model.collectId complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        [self hideWaitingHUD];
        if (isSuccess) {
            [self showAutoDismissTextAlert:@"删除成功"];
            [self.tableView.mj_header beginRefreshing];
        }
    }];
}

@end

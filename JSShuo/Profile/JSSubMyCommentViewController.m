//
//  JSSubMyCommentViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/19.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSSubMyCommentViewController.h"
#import "JSMyCommentCell.h"
#import "JSNetworkManager+Login.h"

@interface JSSubMyCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, strong)UILabel *nodataLable;
@end

@implementation JSSubMyCommentViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UILabel *)nodataLable{
    if (!_nodataLable) {
        _nodataLable = [[UILabel alloc]init];
        _nodataLable.text = @"暂无数据";
        [_nodataLable sizeToFit];
        _nodataLable.hidden = YES;
    }
    return _nodataLable;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JSMyCommentCell class] forCellReuseIdentifier:@"JSMyCommentCell"];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.nodataLable];
    [self.view addSubview:self.tableView];
    self.currentPage = 1;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.nodataLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.nodataLable.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(150);
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
    
}
- (void)refreshDataWithHeaderRefresh:(BOOL)isHeaderRefresh{
    if (isHeaderRefresh) {
        self.currentPage = 1;
        [self.dataArray removeAllObjects];
    }else{
        self.currentPage ++;
    }
    
    if (!self.isReceive) {
        [JSNetworkManager questCommentListWith:self.currentPage complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (isSuccess) {
                NSArray *listArray = contentDict[@"list"];
                for (NSDictionary *dict in listArray) {
                    JSMyCommentModel *model = [MTLJSONAdapter modelOfClass:[JSMyCommentModel class] fromJSONDictionary:dict error:nil];
                    model.name = self.userModel.nickname;
                    model.portrait = self.userModel.portrait;
                    [self.dataArray addObject:model];
                }
//                for (int i = 0; i<10; i++) {
//                    JSMyCommentModel *model = [[JSMyCommentModel alloc]init];
//                    model.createTime = @"2018-11-11 11:11:11";
//                    model.content = @"这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥";
//                    model.name = self.userModel.nickname;
//                    model.portrait = self.userModel.portrait;
//                    [self.dataArray addObject:model];
//                }
                [self.tableView reloadData];
                
                if (listArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                if (self.dataArray.count <= 0) {
                    self.tableView.hidden = YES;
                    self.nodataLable.hidden = NO;
                }else{
                    self.tableView.hidden = NO;
                    self.nodataLable.hidden = YES;
                }
            }else{
                if (!isHeaderRefresh) {
                    self.currentPage -- ;
                }
            }
        }];
    }else{
        [JSNetworkManager questRecvCommentListWith:self.currentPage complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (isSuccess) {
                NSArray *listArray = contentDict[@"list"];
                for (NSDictionary *dict in listArray) {
                    JSMyCommentModel *model = [MTLJSONAdapter modelOfClass:[JSMyCommentModel class] fromJSONDictionary:dict error:nil];
                    model.name = self.userModel.nickname;
                    model.portrait = self.userModel.portrait;
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
                
                if (listArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                if (self.dataArray.count <= 0) {
                    self.tableView.hidden = YES;
                    self.nodataLable.hidden = NO;
                }else{
                    self.tableView.hidden = NO;
                    self.nodataLable.hidden = YES;
                }
            }else{
                if (!isHeaderRefresh) {
                    self.currentPage -- ;
                }
            }
        }];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSMyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSMyCommentCell" forIndexPath:indexPath];
    JSMyCommentModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSMyCommentModel *model = self.dataArray[indexPath.row];
    return [JSMyCommentCell heightForRowWithModel:model];
}

@end

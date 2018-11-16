//
//  JSVideoViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSVideoViewController.h"
#import "JSLongVideoCell.h"
#import "JSNetworkManager+LongVideo.h"

@interface JSVideoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) NSNumber *currentPage;
@end

@implementation JSVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = @1;
    [self requestData];
    [self initTableView];
}

- (void) requestData {
    NSDictionary *params = @{@"pageNum":_currentPage,@"channel":@"11",@"pageSize":@5};
    [JSNetworkManager requestLongVideoListWithParams:params complent:^(NSNumber * _Nonnull totalPage, NSArray * _Nonnull modelsArray) {
        if (modelsArray.count < 1) { // 如果数组为空，则说明请求失败
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.currentPage.integerValue == 1) { // 下拉刷新
            self.datas = [NSMutableArray arrayWithArray:modelsArray];
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.datas addObjectsFromArray:modelsArray];
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.tableView) {
            [self.tableView reloadData];
        }
    }];
}

- (void) initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-60) style:UITableViewStylePlain];
    [_tableView registerClass:[JSLongVideoCell class] forCellReuseIdentifier:@"JSLongVideoCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage = @1;
        [self requestData];
    }];
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        int temp = self.currentPage.intValue + 1;
        self.currentPage = [NSNumber numberWithInt:temp];
        [self requestData];
    }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSLongVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSLongVideoCell" forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40+(ScreenWidth-30)*9/16+9+25+2;
}



@end

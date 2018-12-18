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
#import "JSVideoDetailViewController.h"
#import "JSNoSearchResultView.h"

@interface JSVideoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) NSNumber *currentPage;
@property (nonatomic,strong) JSNoSearchResultView *noResultView;
@end

@implementation JSVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = @1;
    [self requestData];
    [self initTableView];
    [self.view addSubview:self.noResultView];
    _noResultView.hidden = YES;
}

- (void) requestData {
    NSDictionary *params = @{@"pageNum":_currentPage,@"channel":@"11",@"pageSize":@5};
    @weakify(self);
    [JSNetworkManager requestLongVideoListWithParams:params complent:^(BOOL isSuccess,NSNumber * _Nonnull totalPage, NSArray * _Nonnull modelsArray) {
        @strongify(self);
        if (isSuccess) {
            self.noResultView.hidden = YES;
            self.tableView.hidden = NO;
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
        } else {
            self.tableView.hidden = YES;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            self.noResultView.hidden = NO;
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
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        int temp = self.currentPage.intValue + 1;
        self.currentPage = [NSNumber numberWithInt:temp];
        [self requestData];
    }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JSVideoDetailViewController *vc = [JSVideoDetailViewController new];
    JSLongVideoModel *model = self.datas[indexPath.row];
    vc.urlStr = model.videoUrl;
    vc.videoTitle = model.title;
    vc.articleId = model.articleId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
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

- (JSNoSearchResultView *)noResultView {
    if (!_noResultView) {
        _noResultView = [[JSNoSearchResultView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
        _noResultView.titleLabelOne.text = @"当前手机暂无网络连接！";
        _noResultView.titleLabelTwo.text = @"请检查网络设置后下拉刷新";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestData)];
        [_noResultView addGestureRecognizer:tap];
    }
    return _noResultView;
}

@end

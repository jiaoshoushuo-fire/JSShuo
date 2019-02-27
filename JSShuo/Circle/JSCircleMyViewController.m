//
//  JSCircleMyViewController.m
//  JSShuo
//
//  Created by li que on 2019/2/14.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import "JSCircleMyViewController.h"
#import "JSCircleMyTableViewCell.h"
#import "JSNetworkManager+Channel.h"
#import "JSNoSearchResultView.h"
#import "JSCircleMyDetailViewController.h"

@interface JSCircleMyViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,assign) int pageNum;
@property (nonatomic,strong) JSNoSearchResultView *noResultView;
@end

@implementation JSCircleMyViewController

- (void)viewWillAppear:(BOOL)animated {
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNum = 1;
    [self initTableView];
    [self.view addSubview:self.noResultView];
    _noResultView.hidden = YES;
    [self requestData];
}

- (void) requestData {
    [JSNetworkManager requestCircleWithMyPageNum:[NSString stringWithFormat:@"%i",_pageNum] complent:^(BOOL isSuccess, NSArray * _Nonnull contentArray) {
        if (isSuccess && contentArray.count > 0) {
            [self dealData:contentArray];
            self.noResultView.hidden = YES;
        } else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.datas.count <= 0) {
                self.noResultView.hidden = NO;
            }
        }
    }];
}

- (void) dealData:(NSArray *)modelsArray {
    if (modelsArray.count < 1) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }
    if (self.pageNum == 1) { // 下拉刷新
        self.datas = [NSMutableArray arrayWithArray:modelsArray];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.datas addObject:modelsArray];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

- (void) initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-64) style:UITableViewStylePlain];
    [_tableView registerClass:[JSCircleMyTableViewCell class] forCellReuseIdentifier:@"JSCircleMyTableViewCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum = 1;
        [self requestData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum += 1;
        [self requestData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSCircleListModel *model = self.datas[indexPath.row];
    JSCircleMyDetailViewController *vc = [JSCircleMyDetailViewController new];
    vc.articleId = model.articleId;
    vc.titleName = model.title.length > 0 ? model.title : @"";
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSCircleMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSCircleMyTableViewCell" forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSCircleListModel *model = self.datas[indexPath.row];
    if (model.images.count > 0) {
        return 12 + 120/16.0*9 + 8 +20 + 13;
    }else {
        return 78;
    }
}

- (JSNoSearchResultView *)noResultView {
    if (!_noResultView) {
        _noResultView = [[JSNoSearchResultView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
        _noResultView.titleLabelOne.text = @"当前并无上传数据！";
        _noResultView.titleLabelTwo.text = @"请上传数据后点击重试";
        UITapGestureRecognizer *tap;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestData)];
        [_noResultView addGestureRecognizer:tap];
    }
    return _noResultView;
}

@end

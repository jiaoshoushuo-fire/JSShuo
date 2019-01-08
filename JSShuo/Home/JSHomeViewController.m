//
//  JSHomeViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSHomeViewController.h"
#import "JSLoginMainViewController.h"
#import "JSNetworkManager+LongVideo.h"
//#import "JSHomeTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JSShowTypeBigPictureTableViewCell.h"
#import "JSShowTypeSmallPictureTableViewCell.h"
#import "JSShowTypeThreePictureTableViewCell.h"
#import "JSNetworkManager+Search.h"
#import "JSArticleDetailViewController.h"
#import "JSNoSearchResultView.h"

@interface JSHomeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) NSMutableArray *topList;
@property (nonatomic,strong) NSNumber *currentPage;
@property (nonatomic,strong) JSNoSearchResultView *noResultView;
@end

@implementation JSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _currentPage = @1;
    [self initTableView];
    [self.view addSubview:self.noResultView];
    _noResultView.hidden = YES;
    if (_type == JSHomePage) {
        [self requestTopList];
    } else if (_type == JSSearchResultPage) {
        [self requestSearchResultData];
    }
}

- (void) requestTopList {
    NSDictionary *dic = @{@"channel":self.genreID};
    [JSNetworkManager requestTopListWithParams:dic complent:^(BOOL isSuccess, NSArray * _Nonnull modelsArray) {
        self.topList = [NSMutableArray arrayWithArray:modelsArray];
        [self requestData];
    }];
}

- (void) requestData {
//    NSLog(@"第%@页",_currentPage);
    NSDictionary *params = @{@"pageNum":_currentPage,@"channel":self.genreID,@"pageSize":@5};
    [JSNetworkManager requestLongVideoListWithParams:params complent:^(BOOL isSuccess, NSNumber * _Nonnull totalPage, NSArray * _Nonnull modelsArray) {
        if (isSuccess) {
            [self dealData:modelsArray];
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

- (void) requestSearchResultData {
    self.title = self.keywrod;
//    NSLog(@"第%@页",_currentPage);
    NSDictionary *params = @{@"keyword":self.keywrod,@"type":[NSString stringWithFormat:@"%i",_searchType],@"pageNum":_currentPage,@"pageSize":@5};
    [JSNetworkManager requestKeywordWihtParmas:params complent:^(BOOL isSuccess, NSNumber * _Nonnull totalPage, NSArray * _Nonnull modelsArray) {
        if (isSuccess) {
            if (!modelsArray.count) {
                self.noResultView.hidden = NO;
                [self.tableView removeFromSuperview];
                return ;
            }
            self.noResultView.hidden = YES;
            [self dealData:modelsArray];
            if (totalPage.intValue == self.currentPage.intValue) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
        } else {
            NSLog(@"请求数据失败");
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.hidden = YES;
        }
    }];
}

- (void) dealData:(NSArray *)modelsArray {
    if (modelsArray.count < 1) { // 如果数组为空，则说明请求失败
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < modelsArray.count; i++) {
        JSHomeModel *model = modelsArray[i];
        if (model.showType.intValue == 1 || model.showType.intValue == 2 || model.showType.intValue == 3) {
            [tempArr addObject:model];
        }
    }
    if (self.currentPage.integerValue == 1) { // 下拉刷新
        self.datas = tempArr;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.datas insertObjects:tempArr atIndex:0];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

- (void) initTableView {
    self.tableView = [[UITableView alloc] init];
    if (_type == JSHomePage) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-60-38) style:UITableViewStylePlain];
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    [_tableView registerClass:[JSShowTypeBigPictureTableViewCell class] forCellReuseIdentifier:@"JSShowTypeBigPictureTableViewCell"];
    [_tableView registerClass:[JSShowTypeSmallPictureTableViewCell class] forCellReuseIdentifier:@"JSShowTypeSmallPictureTableViewCell"];
    [_tableView registerClass:[JSShowTypeThreePictureTableViewCell class] forCellReuseIdentifier:@"JSShowTypeThreePictureTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
//        self.currentPage = @1;
        int temp = self.currentPage.intValue + 1;
        self.currentPage = [NSNumber numberWithInt:temp];
        self.type == JSHomePage ? [self requestData] : [self requestSearchResultData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        int temp = self.currentPage.intValue + 1;
        self.currentPage = [NSNumber numberWithInt:temp];
        self.type == JSHomePage ? [self requestData] : [self requestSearchResultData];
    }];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JSArticleDetailViewController *vc = [JSArticleDetailViewController new];
    JSHomeModel *model ;
    if (indexPath.row < self.topList.count) {
        model = self.topList[indexPath.row];
    } else {
        model = self.datas[indexPath.row - self.topList.count];
    }
    vc.articleId = model.articleId;
    vc.titleName = model.title;
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count + self.topList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSHomeModel *model ;
    if (indexPath.row < self.topList.count) {
        model = self.topList[indexPath.row];
    } else {
        model = self.datas[indexPath.row - self.topList.count];
    }
    
    if (model.showType.intValue == 1) {
        JSShowTypeBigPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSShowTypeBigPictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else if (model.showType.intValue == 2) {
        JSShowTypeSmallPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSShowTypeSmallPictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else if (model.showType.intValue == 3) {
        JSShowTypeThreePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSShowTypeThreePictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else {
        NSLog(@"没有showType字段");
        JSShowTypeSmallPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSShowTypeSmallPictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSHomeModel *model ;
    if (indexPath.row < self.topList.count) {
        model = self.topList[indexPath.row];
    } else {
        model = self.datas[indexPath.row - self.topList.count];
    }
    if (model.showType.intValue == 1) {
        return [tableView fd_heightForCellWithIdentifier:@"JSShowTypeBigPictureTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            // 重点(自适应高度必须实现)
            [self setupModelOfBigPictureCell:cell AtIndexPath:indexPath];
        }];
    } else if (model.showType.intValue == 2) {
        return [tableView fd_heightForCellWithIdentifier:@"JSShowTypeSmallPictureTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            // 重点(自适应高度必须实现)
            [self setupModelOfSmallPictureCell:cell AtIndexPath:indexPath];
        }];
    } else if (model.showType.intValue == 3) {
        return [tableView fd_heightForCellWithIdentifier:@"JSShowTypeThreePictureTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            // 重点(自适应高度必须实现)
            [self setupModelOfThreePictureCell:cell AtIndexPath:indexPath];
        }];
    } else {
        NSLog(@"没有showType字段");
    }
    return 0;
}


//预加载Cell内容
- (void)setupModelOfBigPictureCell:(JSShowTypeBigPictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    JSHomeModel *model ;
    if (indexPath.row < self.topList.count) {
        model = self.topList[indexPath.row];
    } else {
        model = self.datas[indexPath.row - self.topList.count];
    }
    cell.model = model;
}

- (void)setupModelOfSmallPictureCell:(JSShowTypeSmallPictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    JSHomeModel *model ;
    if (indexPath.row < self.topList.count) {
        model = self.topList[indexPath.row];
    } else {
        model = self.datas[indexPath.row - self.topList.count];
    }
    cell.model = model;
}

- (void)setupModelOfThreePictureCell:(JSShowTypeThreePictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    JSHomeModel *model ;
    if (indexPath.row < self.topList.count) {
        model = self.topList[indexPath.row];
    } else {
        model = self.datas[indexPath.row - self.topList.count];
    }
    cell.model = model;
}

- (JSNoSearchResultView *)noResultView {
    if (!_noResultView) {
        _noResultView = [[JSNoSearchResultView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
        _noResultView.titleLabelOne.text = @"当前手机暂无网络连接！";
        _noResultView.titleLabelTwo.text = @"请检查网络设置后点击屏幕刷新";
        UITapGestureRecognizer *tap;
        
        if (_type == JSHomePage) {
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestData)];
        } else if (_type == JSSearchResultPage){
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestSearchResultData)];
        }
        [_noResultView addGestureRecognizer:tap];
    }
    return _noResultView;
}

// 登录成功后的通知
- (void)userLoginSuccessNoti:(NSNotification *)notification {
    
}




@end

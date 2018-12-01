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


@interface JSHomeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) NSNumber *currentPage;
@end

@implementation JSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = @1;
    [self initTableView];
    _type == JSHomePage ? [self requestData] : [self requestSearchResultData];
}

- (void) requestData {
    NSLog(@"第%@页",_currentPage);
    NSDictionary *params = @{@"pageNum":_currentPage,@"channel":self.genreID,@"pageSize":@5};
    [JSNetworkManager requestLongVideoListWithParams:params complent:^(NSNumber * _Nonnull totalPage, NSArray * _Nonnull modelsArray) {
        [self dealData:modelsArray];
    }];
}

- (void) requestSearchResultData {
    NSDictionary *params = @{@"keyword":self.keywrod,@"type":[NSString stringWithFormat:@"%i",_searchType],@"pageNum":_currentPage,@"pageSize":@5};
    [JSNetworkManager requestKeywordWihtParmas:params complent:^(BOOL isSuccess, NSNumber * _Nonnull totalPage, NSArray * _Nonnull modelsArray) {
        if (isSuccess) {
            [self dealData:modelsArray];
        } else {
            NSLog(@"请求数据失败");
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
    } else {
        [self.datas addObjectsFromArray:tempArr];
        [self.tableView.mj_footer endRefreshing];
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
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.and.left.and.right.mas_equalTo(0);
//        make.height.mas_equalTo(ScreenHeight-49-60-38);
//    }];
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.currentPage = @1;
        [self requestData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        int temp = self.currentPage.intValue + 1;
        self.currentPage = [NSNumber numberWithInt:temp];
        [self requestData];
    }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JSArticleDetailViewController *vc = [JSArticleDetailViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSHomeModel *model = self.datas[indexPath.row];
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
    JSHomeModel *model = self.datas[indexPath.row];
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
    cell.model = [_datas objectAtIndex:indexPath.row];
}

- (void)setupModelOfSmallPictureCell:(JSShowTypeSmallPictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell.model = [_datas objectAtIndex:indexPath.row];
}

- (void)setupModelOfThreePictureCell:(JSShowTypeThreePictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell.model = [_datas objectAtIndex:indexPath.row];
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

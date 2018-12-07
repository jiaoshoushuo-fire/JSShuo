//
//  JSNotificationViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSNotificationViewController.h"
#import "JSMessageCell.h"
#import "JSNetworkManager+Login.h"
#import "JSMessageModel.h"

@interface JSNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataList;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)NSInteger totalPage;
@property (nonatomic, strong)UILabel *nodataLabel;
@end

@implementation JSNotificationViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[JSMessageCell class] forCellReuseIdentifier:@"JSMessageCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self refreshMessageDataListWithHeaderRefresh:YES];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self refreshMessageDataListWithHeaderRefresh:NO];
            
        }];
    }
    return _tableView;
}
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (UILabel *)nodataLabel{
    if (!_nodataLabel) {
        _nodataLabel = [[UILabel alloc]init];
        _nodataLabel.text = @"暂无数据";
        _nodataLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _nodataLabel.font = [UIFont systemFontOfSize:17];
        [_nodataLabel sizeToFit];
        _nodataLabel.hidden = YES;
    }
    return _nodataLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nodataLabel];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.nodataLabel.size);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(200);
    }];
    
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
- (void)reloadListData{
    [self.tableView.mj_header beginRefreshing];
}
- (void)refreshMessageDataListWithHeaderRefresh:(BOOL)isHeaderRefresh{
    if (isHeaderRefresh) {
        self.currentPage = 1;
        [self.dataList removeAllObjects];
    }else{
        self.currentPage ++;
    }
    [JSNetworkManager requestMessageListWithType:self.messageType pageNum:self.currentPage complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
        if (isHeaderRefresh) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        if (isSuccess) {
            NSError *error = nil;
            JSMessageListModel *listModel = [MTLJSONAdapter modelOfClass:[JSMessageListModel class] fromJSONDictionary:contenDict error:&error];
            self.totalPage = listModel.totalPage;
            [self.dataList addObjectsFromArray:listModel.list];
//            [self.dataList addObjectsFromArray:[self testList]];
            
            
            if (self.dataList.count > 0) {
                self.nodataLabel.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
                
                if (self.currentPage == self.totalPage) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                self.nodataLabel.hidden = NO;
                self.tableView.hidden = YES;
            }
            
            
        }else{
            if (self.dataList.count > 0) {//原来有数据 还原页数
                if (isHeaderRefresh) {
                    self.currentPage = 1;
                }else{
                    self.currentPage -- ;
                }
                
            }else{//原来没有数据 隐藏列表 显示 网络失败
                
            }
        }
        
    }];
}
- (NSArray *)testList{
    NSMutableArray *testArray = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        JSMessageModel *model = [[JSMessageModel alloc]init];
        model.type = self.messageType;
        model.createTime = @"2018-11-12 11:11:11";
        model.content = @"这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥这是干啥";
        [testArray addObject:model];
    }
    return testArray;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"JSMessageCell" forIndexPath:indexPath];
    JSMessageModel *model = self.dataList[indexPath.row];
    messageCell.messageModel = model;
    return messageCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSMessageModel *model = self.dataList[indexPath.row];
    return [JSMessageCell heightWithModel:model];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

//
//  JSCircleViewController.m
//  JSShuo
//
//  Created by li que on 2019/1/30.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import "JSCircleViewController.h"
#import "JSNetworkManager+Channel.h"
#import "JSCircleOnePictureTableViewCell.h"
#import "JSCircleTwoPictureTableViewCell.h"
#import "JSCircleThreePictureTableViewCell.h"
#import "JSCirclePureWordTableViewCell.h"
#import "JSNoSearchResultView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JSCircleDetailViewController.h"
#import "JSShareManager.h"
#import <objc/runtime.h>
#import "JSReportViewController.h"

@interface JSCircleViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,assign) int pageNum;
@property (nonatomic,strong) JSNoSearchResultView *noResultView;
@property (nonatomic,strong) NSNumber *reportArticleId;
@end

@implementation JSCircleViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reportArticle" object:nil];
}

- (void) addNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goReportVC) name:@"reportArticle" object:nil];
}

- (void) goReportVC {
    NSLog(@"goReportVC");
    JSReportViewController *vc = [JSReportViewController new];
    vc.posterID = self.reportArticleId.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNum = 1;
    [self initTableView];
    [self.view addSubview:self.noResultView];
    _noResultView.hidden = YES;

    [self addNoti];

}

- (void) requestData {
    [self showWaitingHUD];
    [JSNetworkManager requestCircleWithChannel:self.channel pageNum:[NSString stringWithFormat:@"%i",_pageNum] complent:^(BOOL isSuccess, NSArray * _Nonnull contentArray) {
        [self hideWaitingHUD];
        if (isSuccess) {
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
        [self.tableView.mj_footer removeFromSuperview];
        return;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < modelsArray.count; i++) {
        JSCircleListModel *model = modelsArray[i];
        if (model.imageType.intValue == 0 || model.imageType.intValue == 1 || model.imageType.intValue == 2 || model.imageType.intValue == 3) {
            [tempArray addObject:model];
        }
    }
    if (self.pageNum == 1) { // 下拉刷新
        self.datas = tempArray;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.datas addObjectsFromArray:tempArray];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

- (void) initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-64) style:UITableViewStylePlain];
    [_tableView registerClass:[JSCircleOnePictureTableViewCell class] forCellReuseIdentifier:@"JSCircleOnePictureTableViewCell"];
    [_tableView registerClass:[JSCircleTwoPictureTableViewCell class] forCellReuseIdentifier:@"JSCircleTwoPictureTableViewCell"];
    [_tableView registerClass:[JSCircleThreePictureTableViewCell class] forCellReuseIdentifier:@"JSCircleThreePictureTableViewCell"];
    [_tableView registerClass:[JSCirclePureWordTableViewCell class] forCellReuseIdentifier:@"JSCirclePureWordTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    JSCircleDetailViewController *vc = [JSCircleDetailViewController new];
    vc.articleId = model.articleId;
    vc.titleName = model.title.length > 0 ? [model.title stringByURLDecode] : @"帖子详情";
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSCircleListModel *model = self.datas[indexPath.row];
    if (model.imageType.integerValue == 0) { // 纯文字
        JSCirclePureWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSCirclePureWordTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        objc_setAssociatedObject(cell.bottomView.reportBtn, @"reportBtn", model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [cell.bottomView.reportBtn addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
        cell.noInterestBlock = ^(void) {
            [self.datas removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        };
        cell.shieldAuthor = ^(void) {
            [self requestData];
        };
        return cell;
    } else if (model.imageType.integerValue == 1) { // 1图
        JSCircleOnePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSCircleOnePictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        objc_setAssociatedObject(cell.bottomView.reportBtn, @"reportBtn", model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [cell.bottomView.reportBtn addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
        cell.noInterestBlock = ^(void) {
            [self.datas removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        };
        cell.shieldAuthor = ^(void) {
            [self requestData];
        };
        return cell;
    } else if (model.imageType.integerValue == 2) { // 2图
        JSCircleTwoPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSCircleTwoPictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        objc_setAssociatedObject(cell.bottomView.reportBtn, @"reportBtn", model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [cell.bottomView.reportBtn addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
        cell.noInterestBlock = ^(void) {
            [self.datas removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        };
        cell.shieldAuthor = ^(void) {
            [self requestData];
        };
        return cell;
    } else { // 3图
        JSCircleThreePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSCircleThreePictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        objc_setAssociatedObject(cell.bottomView.reportBtn, @"reportBtn", model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [cell.bottomView.reportBtn addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
        cell.noInterestBlock = ^(void) {
            [self.datas removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        };
        cell.shieldAuthor = ^(void) {
            [self requestData];
        };
        return cell;
    }
}

- (void) showShare:(UIButton *)btn {
    JSCircleListModel *model = objc_getAssociatedObject(btn, @"reportBtn");
    self.reportArticleId = model.articleId;
    NSString *shareUrlStr = [NSString stringWithFormat:@"%@/v1/page/poster/%@",Base_Url,model.articleId];
    [JSShareManager shareWithTitle:@"叫兽说" Text:model.title Image:[UIImage imageNamed:@"js_share_image"] Url:shareUrlStr complement:^(BOOL isSuccess) {
        if (isSuccess) {
            [self showAutoDismissTextAlert:@"分享成功"];
        }else{
            [self showAutoDismissTextAlert:@"分享失败"];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSCircleListModel *model = self.datas[indexPath.row];
    if (model.imageType.integerValue == 0) { // 纯文字
        return [tableView fd_heightForCellWithIdentifier:@"JSCirclePureWordTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            // 重点(自适应高度必须实现)
            [self setupModelOfPureWordCell:cell AtIndexPath:indexPath];
        }];
    } else if(model.imageType.integerValue == 1) { // 1图
        return [tableView fd_heightForCellWithIdentifier:@"JSCircleOnePictureTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            // 重点(自适应高度必须实现)
            [self setupModelOfOnePictureCell:cell AtIndexPath:indexPath];
        }];
        
    } else if(model.imageType.integerValue == 2) { // 2图
        return [tableView fd_heightForCellWithIdentifier:@"JSCircleTwoPictureTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            // 重点(自适应高度必须实现)
            [self setupModelOfTwoPictureCell:cell AtIndexPath:indexPath];
        }];
    } else if(model.imageType.integerValue == 3) { // 3图
        return [tableView fd_heightForCellWithIdentifier:@"JSCircleThreePictureTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            // 重点(自适应高度必须实现)
            [self setupModelOfThreePictureCell:cell AtIndexPath:indexPath];
        }];
    } else {
        NSLog(@"model.imageType为空");
    }
    return 0;
}

//预加载Cell内容
- (void)setupModelOfOnePictureCell:(JSCircleOnePictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    JSCircleListModel *model = self.datas[indexPath.row];
    cell.model = model;
}

- (void)setupModelOfTwoPictureCell:(JSCircleTwoPictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    JSCircleListModel *model = self.datas[indexPath.row];
    cell.model = model;
}

- (void)setupModelOfThreePictureCell:(JSCircleThreePictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    JSCircleListModel *model = self.datas[indexPath.row];
    cell.model = model;
}

- (void)setupModelOfPureWordCell:(JSCirclePureWordTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    JSCircleListModel *model = self.datas[indexPath.row];
    cell.model = model;
}

- (JSNoSearchResultView *)noResultView {
    if (!_noResultView) {
        _noResultView = [[JSNoSearchResultView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
        _noResultView.titleLabelOne.text = @"当前手机暂无网络连接！";
        _noResultView.titleLabelTwo.text = @"请检查网络设置后点击屏幕刷新";
        UITapGestureRecognizer *tap;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestData)];
        [_noResultView addGestureRecognizer:tap];
    }
    return _noResultView;
}

@end

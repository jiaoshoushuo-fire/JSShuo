//
//  JSShortVideoViewController.m
//  JSShuo
//
//  Created by li que on 2018/11/5.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSShortVideoViewController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"

#import "ZFTableViewCellLayout.h"
#import "JSShortVideoModel.h"
#import "ZFDouYinCell.h"
#import "ZFDouYinControlView.h"

#import "UINavigationController+FDFullscreenPopGesture.h"
#import <MJRefresh/MJRefresh.h>
#import "JSNetworkManager+ShortVideo.h"
#import "JSCommentView.h"
#import "JSShareManager.h"
#import "JSNetworkManager+Comment.h"
#import "JSLongVideoModel.h"

static NSString *kIdentifier = @"ZFDouYinCell";

@interface JSShortVideoViewController () <UITableViewDelegate,UITableViewDataSource,ZFDouYinCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFDouYinControlView *controlView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic,strong) NSNumber *currentPage;
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation JSShortVideoViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player.currentPlayerManager pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = @0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    if (self.ID) { // 是从收藏列表进来的
        [self.view addSubview:self.backBtn];
        [self requestCollectionData];
    } else {
        [self requestData];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.mj_header = header;
    }
    [self setupPlayerConfig];
}

// 从收藏页面进入的
- (void) requestCollectionData {
    [JSNetworkManager requestDetailWithArticleID:self.ID complent:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
        JSLongVideoModel *model = [JSLongVideoModel modelWithDictionary:contentDic];
        [self.dataSource addObject:model];
        NSURL *collectionPlayerUrl = [NSURL URLWithString:model.videoUrl];
        [self.urls addObject:collectionPlayerUrl];
        
        if (self.tableView) {
            [self.tableView reloadData];
            self.tableView.scrollEnabled = NO;
        }
    }];
}

- (void) setupPlayerConfig {
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    //    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
    //    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    
    /// player,tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.assetURLs = self.urls;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
    self.player.controlView = self.controlView;
    self.player.allowOrentitaionRotation = NO;
    self.player.WWANAutoPlay = YES;
    /// 1.0是完全消失时候
    self.player.playerDisapperaPercent = 1.0;
    
    @weakify(self);
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
}

- (void)loadNewData {
    if (!self.dataSource.count) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAutoDismissTextAlert:@"请检查网络"];
    } else {
        [self.dataSource removeAllObjects];
        [self.urls removeAllObjects];
    }
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
        [self.player stopCurrentPlayingCell];
        [self requestData];
        [self.tableView reloadData];
        /// 找到可以播放的视频并播放
        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
    });
}

- (void)requestData {
    int temp = self.currentPage.intValue + 1;
    self.currentPage = [NSNumber numberWithInt:temp];
    NSDictionary *params = @{@"pageNum":_currentPage,@"channel":@"12",@"pageSize":@5};
    [JSNetworkManager requestLongVideoListWithParams:params complent:^(BOOL isSuccess,NSNumber * _Nonnull totalPage, NSArray * _Nonnull modelsArray) {
        [self.dataSource addObjectsFromArray:modelsArray];
        for (int i = 0; i < modelsArray.count; i++) {
            JSShortVideoModel *model = modelsArray[i];
            NSString *URLString = [model.videoUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *url = [NSURL URLWithString:URLString];
            [self.urls addObject:url];
        }
        if (self.tableView) {
            [self.tableView reloadData];
        }
    }];
    [self.tableView.mj_header endRefreshing];
}

- (void)playTheIndex:(NSInteger)index {
    @weakify(self)
    /// 指定到某一行播放
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
    /// 如果是最后一行，去请求新数据
    if (index == self.dataSource.count-1) {
        /// 加载下一页数据
        [self requestData];
        self.player.assetURLs = self.urls;
        [self.tableView reloadData];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backBtn.frame = CGRectMake(15, CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame), 36, 36);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFDouYinCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    cell.data = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - ZFTableViewCellDelegate
- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - private method
- (void)backClick:(UIButton *)sender {
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    [self.controlView resetControlView];
    JSShortVideoModel *data = self.dataSource[indexPath.row];
    [self.controlView showCoverViewWithUrl:data.cover[0]];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
        [_tableView registerClass:[ZFDouYinCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        if (self.ID) {
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        } else {
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-0);
        }
        _tableView.rowHeight = _tableView.frame.size.height;
        
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if (indexPath.row == self.dataSource.count-1) {
                /// 加载下一页数据
                [self requestData];
                self.player.assetURLs = self.urls;
                [self.tableView reloadData];
            }
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
    }
    return _tableView;
}

- (ZFDouYinControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFDouYinControlView new];
    }
    return _controlView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (NSMutableArray *)urls {
    if (!_urls) {
        _urls = @[].mutableCopy;
    }
    return _urls;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"zfplayer_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark - ZFDouYinCellDelegate
- (void)didSelectedLikeButtonWithModel:(JSShortVideoModel *)model{
    
}
- (void)didSelectedShareButtonWithModel:(JSShortVideoModel *)model{
    [JSShareManager shareWithTitle:@"叫兽说" Text:model.Description Image:[UIImage imageNamed:@"js_share_image"] Url:model.videoUrl complement:^(BOOL isSuccess) {
        if (isSuccess) {
            [self showAutoDismissTextAlert:@"分享成功"];
        }else{
            [self showAutoDismissTextAlert:@"分享失败"];
        }
    }];
}
- (void)didSelectedCommentButtonWithModel:(JSShortVideoModel *)model{
    
    [JSCommentView showCommentViewWithSuperView:[UIApplication sharedApplication].keyWindow authModel:model];
}

@end

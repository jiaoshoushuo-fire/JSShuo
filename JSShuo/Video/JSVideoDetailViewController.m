//
//  JSVideoDetailViewController.m
//  JSShuo
//
//  Created by li que on 2018/12/8.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSVideoDetailViewController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "JSDetailBottomSendCommentView.h"
#import "JSRecommentTableViewCell.h"
#import "JSCommentTableViewCell.h"
#import "JSDetailSectionHeaderView.h"
#import "JSBottomPopSendCommentView.h"
#import "JSNetworkManager+Comment.h"
#import "JSNetworkManager+Recommend.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JSShareManager.h"
#import "JSNetworkManager+Login.h"
#import "JSLongVideoModel.h"
#import "JSReportViewController.h"

static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface JSVideoDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) int pageNum;
@property (nonatomic,assign) int pageSize;
@property (nonatomic,strong) NSNumber *totalPage;
@property (nonatomic,strong) NSMutableArray *commentDatas;
@property (nonatomic,strong) NSMutableArray *recommendDatas;
@property (nonatomic, strong)JSDetailBottomSendCommentView *bottomView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,copy) NSString *videoTitle;
@end

@implementation JSVideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    [self initSendCommentView];
    [self setupPlayer];
    [self.view addSubview:self.tableView];
    _pageNum = 1;
    _pageSize = 10;
    [self requestModel];
    [self addNoti];
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
    vc.posterID = self.articleId.stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}

// 根据 ID 请求播放地址
- (void) requestModel {
    [JSNetworkManager requestDetailWithArticleID:self.articleId.integerValue complent:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
        JSLongVideoModel *model = [JSLongVideoModel modelWithDictionary:contentDic];
        self.videoTitle = model.title;
        self.urlStr = model.videoUrl;
        [self reloadView];
    }];
}

- (void) reloadView {
    [self requestUserInfo];
    [self requestCommentList];
    [self requestRecommendList];
    _controlView.landScapeControlView.titleLabel.text = self.videoTitle;
    _controlView.portraitControlView.titleLabel.text = self.videoTitle;
    self.player.assetURL = [NSURL URLWithString:self.urlStr];
    // 启动定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(rewardArticle:) userInfo:nil repeats:NO];
}

// 奖励金币
- (void) rewardArticle:(NSTimer *)timer {
    [self.timer invalidate];
    self.timer = nil;
    NSString *token = [JSAccountManager shareManager].accountToken;
    if (token && token.length > 0) {
        NSDictionary *param;
        if (token) {
            param = @{@"token":[JSAccountManager shareManager].accountToken,@"articleId":self.articleId};
            [JSNetworkManager requestRewardArticleWithParams:param complent:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
                [JSTool showAlertWithRewardDictiony:contentDic handle:^{
                    
                }];
            }];
        }
    }
}

// 请求用户点赞、收藏等接口
- (void) requestUserInfo {
    [JSNetworkManager requestDetailWithArticleID:self.articleId.integerValue complent:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
        if (isSuccess) {
            NSNumber *collected = contentDic[@"collect"];
            if ([collected  isEqual: @1]) {
                self.bottomView.collectionBtn.selected = YES;
            }
            NSNumber *praised = contentDic[@"praise"];
            if ([praised  isEqual: @1]) {
                self.bottomView.praiseBtn.selected = YES;
            }
        }
    }];
}

// 请求评论列表
- (void) requestCommentList {
    NSDictionary *commentParams = @{@"articleId":self.articleId,@"pageNum":[NSNumber numberWithInt:_pageNum],@"pageSize":[NSNumber numberWithInt:_pageSize]};
    [JSNetworkManager requestCommentListWithParams:commentParams complent:^(BOOL isSuccess, NSNumber * _Nonnull totalPage, NSArray * _Nonnull modelsArray) {
        if (isSuccess) {
            self.commentDatas = [NSMutableArray arrayWithArray:modelsArray];
            self.totalPage = totalPage;
            [self.tableView reloadData];
        }
    }];
}

// 请求相关推荐列表
- (void) requestRecommendList {
    [self showWaitingHUD];
    NSDictionary *recommendParams = @{@"articleId":self.articleId,@"type":@1,@"pageSize":@6};
    [JSNetworkManager requestRecommendListWithParams:recommendParams complent:^(BOOL isSuccess, NSArray * _Nonnull modelsArray) {
        [self hideWaitingHUD];
        if (isSuccess) {
            self.recommendDatas = [NSMutableArray arrayWithArray:modelsArray];
            [self.tableView reloadData];
        }
    }];
}

// 底部的一排按钮
- (void) initSendCommentView {
    JSDetailBottomSendCommentView *bottomView = [[JSDetailBottomSendCommentView alloc] initWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth, 40)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSendChat:)];
    [bottomView.sendCommentLabel addGestureRecognizer:tap];
    
    _bottomView = bottomView;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    @weakify(self);
    [_bottomView.shareBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [JSShareManager shareWithTitle:@"叫兽说" Text:self.videoTitle Image:[UIImage imageNamed:@"js_profile_mywallet_share"] Url:@"https://www.baidu.com/" complement:^(BOOL isSuccess) {
            if (isSuccess) {
                [self showAutoDismissTextAlert:@"分享成功"];
            }else{
                [self showAutoDismissTextAlert:@"分享失败"];
            }
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    // 第 2 个按钮
    [_bottomView.praiseBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
        if (token) {
            self.bottomView.praiseBtn.userInteractionEnabled = NO;
            if (self.bottomView.praiseBtn.selected) { // 取消点赞
                [JSNetworkManager deletePraiseWithArticleID:self.articleId.integerValue complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
                    NSLog(@"取消点赞 -- %@",contentDic);
                    self.bottomView.praiseBtn.userInteractionEnabled = YES;
                    if (isSuccess) {
                        self.bottomView.praiseBtn.selected = NO;
                        long number = [self.bottomView.praiseNum.text integerValue];
                        self.bottomView.praiseNum.text = [NSString stringWithFormat:@"%ld",number-1];
                    }
                }];
            } else { // 点赞
                NSDictionary *params = @{@"token":token,@"articleId":self.articleId};
                [JSNetworkManager addPraise:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
                    NSLog(@"点赞 -- %@",contentDic);
                    self.bottomView.praiseBtn.userInteractionEnabled = YES;
                    if (isSuccess) {
                        self.bottomView.praiseBtn.selected = YES;
                        long number = [self.bottomView.praiseNum.text integerValue];
                        self.bottomView.praiseNum.text = [NSString stringWithFormat:@"%ld",number+1];
                    }
                }];
            }
            self.bottomView.praiseBtn.selected = !self.bottomView.praiseBtn.selected;
        } else {
            [JSAccountManager checkLoginStatusComplement:^(BOOL isLogin) {
                
            }];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    // 第 3 个按钮
    [_bottomView.collectionBtn bk_addEventHandler:^(id sender) {
        @strongify(self)
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
        if (token) {
            self.bottomView.collectionBtn.userInteractionEnabled = NO;
            if (self.bottomView.collectionBtn.selected) { // 取消收藏
                [JSNetworkManager requestDeleateCollectWithArticleId:self.articleId.integerValue complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
                    self.bottomView.collectionBtn.userInteractionEnabled = YES;
                    if (isSuccess) {
                        self.bottomView.collectionBtn.selected = NO;
                        [self showAutoDismissTextAlert:@"取消收藏"];
                    }
                }];
            } else { // 收藏
                NSDictionary *params = @{@"token":token,@"articleId":self.articleId};
                [JSNetworkManager addCollect:params complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
                    self.bottomView.collectionBtn.userInteractionEnabled = YES;
                    NSLog(@"收藏成功 -- %@",contentDic);
                    if (isSuccess) {
                        self.bottomView.collectionBtn.selected = YES;
                        [self showAutoDismissTextAlert:@"收藏成功"];
                    }
                }];
            }
            self.bottomView.collectionBtn.selected = !self.bottomView.collectionBtn.selected;
        } else {
            [JSAccountManager checkLoginStatusComplement:^(BOOL isLogin) {
                
            }];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    // 第 1 个按钮
    [_bottomView.chatBtn bk_addEventHandler:^(id sender) {
        @strongify(self)
        if (self.bottomView.chatBtn.selected) {
            [self.tableView scrollToTop];
        } else {
            if (self.commentDatas.count) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        self.bottomView.chatBtn.selected = !self.bottomView.chatBtn.selected;
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void) showSendChat:(UITapGestureRecognizer *)tap {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAccessToken];
    __block BOOL haveToken = token.length > 0 ? YES : NO;
    if (haveToken) {
        [JSBottomPopSendCommentView showInputBarWithView:self.navigationController.view articleId:[NSString stringWithFormat:@"%@",self.articleId] complement:^(NSDictionary * _Nonnull comment) {
            [self showAutoDismissTextAlert:@"发送成功"];
            [self requestCommentList];
        }];
    } else {
        [JSAccountManager checkLoginStatusComplement:^(BOOL isLogin) {
            
        }];
    }
}

- (void) setupPlayer {
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.playBtn];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
//    self.player.assetURL = [NSURL URLWithString:self.urlStr];
    self.player.controlView = self.controlView;
    
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JSRecommendModel *model = self.recommendDatas[indexPath.row];
        self.articleId = model.articleId;
        self.videoTitle = model.title;
        self.urlStr = model.videoUrl;
        [self reloadView];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JSRecommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSRecommentTableViewCell" forIndexPath:indexPath];
        cell.model = self.recommendDatas[indexPath.row];
        return cell;
    } else {
        JSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSCommentTableViewCell" forIndexPath:indexPath];
        cell.model = self.commentDatas[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JSDetailSectionHeaderView *headerView = [[JSDetailSectionHeaderView alloc] init];
    [headerView.contentView setBackgroundColor:[UIColor whiteColor]];
    if (section == 0) {
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 30);
        [headerView.titleLabel setText:@"相关推荐"];
    } else {
        if (self.commentDatas.count > 0) {
            headerView.frame = CGRectMake(0, 0, ScreenWidth, 30);
            [headerView.titleLabel setText:@"热门评论"];
        } else {
            headerView.frame = CGRectMake(0, 0, ScreenWidth, 1);
        }
    }
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.recommendDatas.count > 0 && self.commentDatas.count > 0) {
        return 2;
    } else if (self.commentDatas.count >0 || self.recommendDatas.count > 0) {
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    if (section == 0) {
        footerView.frame = CGRectMake(0, 0, ScreenWidth, 10);
        footerView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    } else {
        footerView.frame = CGRectMake(0, 0, ScreenWidth, 1);
        footerView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height;
    if (section == 0) {
        height = 30;
    } else {
        if (self.commentDatas.count > 0) {
            height = 30;
        } else {
            height = 1;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = section == 0 ? 10 : 1;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    } else {
        JSCommentListModel *model = self.commentDatas[indexPath.row];
        if (model.replyList.count) {
            CGFloat height = [tableView fd_heightForCellWithIdentifier:@"JSCommentTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                // 重点(自适应高度必须实现)
                [self setupModelOfCell:cell AtIndexPath:indexPath];
            }];
            return height + [model getReplayHeight:model];
            //            return height + [model getReplayHeight:model];
        } else {
            return [tableView fd_heightForCellWithIdentifier:@"JSCommentTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                // 重点(自适应高度必须实现)
                [self setupModelOfCell:cell AtIndexPath:indexPath];
            }];
        }
    }
}

//预加载Cell内容
- (void)setupModelOfCell:(JSCommentTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell.model = [self.commentDatas objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {  return self.recommendDatas.count;}
    else {  return self.commentDatas.count;}
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat height = ScreenWidth*9/16;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, ScreenWidth, ScreenHeight-height-40) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[JSRecommentTableViewCell class] forCellReuseIdentifier:@"JSRecommentTableViewCell"];
        [_tableView registerClass:[JSCommentTableViewCell class] forCellReuseIdentifier:@"JSCommentTableViewCell"];
        [_tableView registerClass:[JSDetailSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"JSDetailSectionHeaderView"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)commentDatas {
    if (!_commentDatas) {
        _commentDatas = [NSMutableArray arrayWithCapacity:0];
    }
    return _commentDatas;
}

- (NSMutableArray *)recommendDatas {
    if (!_recommendDatas) {
        _recommendDatas = [NSMutableArray arrayWithCapacity:0];
    }
    return _recommendDatas;
}

#pragma mark -- Player相关属性
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
//        _controlView.landScapeControlView.titleLabel.text = self.videoTitle;
//        _controlView.portraitControlView.titleLabel.text = self.videoTitle;
        [_controlView.portraitControlView.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    [self.controlView showTitle:self.videoTitle coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
}

- (void) goBack:(UIButton *)btn {
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}

@end

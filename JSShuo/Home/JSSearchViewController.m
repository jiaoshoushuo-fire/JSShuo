//
//  JSSearchViewController.m
//  JSShuo
//
//  Created by li que on 2018/11/15.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSSearchViewController.h"
#import "JSSearchTopNavView.h"
#import "JSSearchNormalView.h"
#import "JSHotSearchTitleCollectionViewCell.h"
#import "JSNetworkManager+Search.h"
#import "JSHomeViewController.h"

@interface JSSearchViewController () <UICollectionViewDelegate,UICollectionViewDataSource,sendKeywordDelegate>
@property (nonatomic,strong) JSSearchTopNavView *navView;
@property (nonatomic,strong) JSSearchNormalView *headerView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *datas;
@end

@implementation JSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self requestData];
    [self addNavView];
    [self addHeader];
    [self.view addSubview:self.collectionView];
}

- (void) requestData {
    [JSNetworkManager requestHotSearchWithParams:@{} complent:^(BOOL isSuccess, NSArray * _Nonnull dicArray) {
        if (isSuccess) {
            self.datas = [NSMutableArray arrayWithArray:dicArray];
            [self.collectionView reloadData];
        }
    }];
}

- (void) addNavView {
    [self.view addSubview:self.navView];
}

- (void) addHeader {
    [self.view addSubview:self.headerView];
}

#pragma mark - sendKeywordDelegate
- (void)passKeyword:(NSString *)keyword {
    self.collectionView.hidden = YES;
    self.headerView.hidden = YES;
    JSHomeViewController *vc = [JSHomeViewController new];
    vc.type = JSSearchResultPage;
    vc.keywrod = keyword;
    vc.searchType = 0;
    vc.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    [self.view addSubview:vc.view];
}

#pragma mark - collectionView代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSHotSearchTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSHotSearchTitleCollectionViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.row + 1000;
    cell.modelDic = self.datas[indexPath.row];
    return cell;
}

- (JSSearchNormalView *)headerView {
    if (!_headerView) {
        _headerView = [[JSSearchNormalView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 197)];
    }
    return _headerView;
}

- (JSSearchTopNavView *)navView {
    if (!_navView) {
        _navView = [[JSSearchTopNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _navView.backgroundColor = [UIColor whiteColor];
        [_navView.backBtn bk_addEventHandler:^(id sender) {
            [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
        } forControlEvents:UIControlEventTouchUpInside];
        [_navView.cancleBtn bk_addEventHandler:^(id sender) {
            [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
        } forControlEvents:UIControlEventTouchUpInside];
        [_navView.searchTextField becomeFirstResponder];
        _navView.delegate = self;
    }
    return _navView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat padding = 0;
        CGFloat itemWidth = (ScreenWidth - padding) * 0.5;
        CGFloat itmeHeight = 30;
        layout.itemSize = CGSizeMake(itemWidth, itmeHeight);
        layout.minimumInteritemSpacing = 0;// 列间距
        layout.minimumLineSpacing = 5; // 行间距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+197+10, ScreenWidth, ScreenHeight-64-197) collectionViewLayout:layout];
        [_collectionView registerClass:[JSHotSearchTitleCollectionViewCell class] forCellWithReuseIdentifier:@"JSHotSearchTitleCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_navView.searchTextField resignFirstResponder];
}

@end

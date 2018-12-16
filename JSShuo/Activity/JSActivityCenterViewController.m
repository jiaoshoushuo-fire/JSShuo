//
//  JSActivityCenterViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSActivityCenterViewController.h"
#import "JSActivityCell.h"
#import "JSActivityHeaderView.h"
#import "ULBCollectionViewFlowLayout.h"
#import "JSShareManager.h"
#import "JSNewUserGuideViewController.h"
#import "JSRedPacketViewController.h"

@interface JSActivityCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ULBCollectionViewDelegateFlowLayout,JSActivityHeaderViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *titleBottomView;
@property (nonatomic, strong)UIButton *bottomLeftButton;
@property (nonatomic, strong)UIButton *bottomRightButton;
@end

@implementation JSActivityCenterViewController

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-CondensedBold" size:20];
        _titleLabel.textColor = [UIColor colorWithHexString:@"F1C65B"];
        _titleLabel.text = @"疯狂赚金币";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UIImageView *)titleBottomView{
    if (!_titleBottomView) {
        _titleBottomView = [[UIImageView alloc]init];
        _titleBottomView.image = [UIImage imageNamed:@"js_activity_title_bottom"];
        [_titleBottomView sizeToFit];
    }
    return _titleBottomView;
}
- (UIButton *)bottomLeftButton{
    if (!_bottomLeftButton) {
        _bottomLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomLeftButton setBackgroundImage:[UIImage imageNamed:@"js_activity_bottom_back"] forState:UIControlStateNormal];
        [_bottomLeftButton setTitle:@"赚取金币攻略" forState:UIControlStateNormal];
        [_bottomLeftButton setTitleColor:[UIColor colorWithHexString:@"AA1B11"] forState:UIControlStateNormal];
        _bottomLeftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomLeftButton sizeToFit];
        @weakify(self)
        [_bottomLeftButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            JSNewUserGuideViewController *newVC = [[JSNewUserGuideViewController alloc]init];
            newVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:newVC animated:YES complete:nil];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomLeftButton;
}

- (UIButton *)bottomRightButton{
    if (!_bottomRightButton) {
        _bottomRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomRightButton setBackgroundImage:[UIImage imageNamed:@"js_activity_bottom_back"] forState:UIControlStateNormal];
        [_bottomRightButton setTitle:@"分享给更多的人" forState:UIControlStateNormal];
        [_bottomRightButton setTitleColor:[UIColor colorWithHexString:@"AA1B11"] forState:UIControlStateNormal];
        _bottomRightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomRightButton sizeToFit];
        
        @weakify(self)
        [_bottomRightButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            [JSShareManager shareWithTitle:@"叫兽说" Text:@"红包大放送，运气好最高能领到188注册红包+88零钱的邀请红包。" Image:[UIImage imageNamed:@"js_share_image"] Url:kShareUrl QQImageURL:kShareQQImage_1 shareType:JSShareManagerTypeQQWeChat complement:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self showAutoDismissTextAlert:@"分享成功"];
                }else{
                    [self showAutoDismissTextAlert:@"分享失败"];
                }
            }];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomRightButton;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        ULBCollectionViewFlowLayout *layout = [[ULBCollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((kScreenWidth - 20*2 - 10*3)/2.0f, (kScreenWidth - 20*2 - 10*3)/2.0f);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JSActivityCell class] forCellWithReuseIdentifier:@"JSActivityCell"];
        [_collectionView registerClass:[JSActivityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JSActivityHeaderView"];
        
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F44336"];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.titleBottomView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomLeftButton];
    [self.view addSubview:self.bottomRightButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleLabel.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(IPHONE_STATUSBAR_HEIGHT);
    }];
    [self.titleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleBottomView.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    [self.bottomLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.bottomLeftButton.size);
        make.left.equalTo(self.view).offset(30);
        make.bottom.equalTo(self.view).offset(-30);
    }];
    [self.bottomRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.bottomRightButton.size);
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-30);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.titleBottomView.mas_bottom).offset(20);
        make.bottom.equalTo(self.bottomLeftButton.mas_top).offset(-20);
    }];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSActivityCell" forIndexPath:indexPath];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        JSActivityHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JSActivityHeaderView" forIndexPath:indexPath];
        header.delegate = self;
        return header;
    }else {
        return nil;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenWidth-20, 95);
}
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    return [UIColor colorWithHexString:@"B22720"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - JSActivityHeaderViewDelegate
- (void)didSelectedHeaderView{
    JSRedPacketViewController *redPackVC = [[JSRedPacketViewController alloc]init];
    redPackVC.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:redPackVC animated:YES complete:nil];
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

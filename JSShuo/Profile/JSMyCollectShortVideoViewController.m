//
//  JSMyCollectShortVideoViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/12/9.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMyCollectShortVideoViewController.h"
#import "JSNetworkManager+Login.h"
#import "JSCollectModel.h"

@interface JSMyCollectShortVideoCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *timeLabel;
@end

@implementation JSMyCollectShortVideoCell

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor randomColor];
    }
    return _imageView;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = @"30：00";
    }
    return _timeLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.timeLabel];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 20));
            make.left.bottom.equalTo(self.contentView);
            
        }];
    }
    return self;
}


@end

@interface JSMyCollectShortVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger currentPage;

@property (nonatomic, strong)UILabel *nodataLabel;
@end

@implementation JSMyCollectShortVideoViewController

- (UILabel *)nodataLabel{
    if (!_nodataLabel) {
        _nodataLabel = [[UILabel alloc]init];
        _nodataLabel.text = @"暂无数据";
        [_nodataLabel sizeToFit];
        _nodataLabel.hidden = YES;
    }
    return _nodataLabel;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((kScreenWidth-20)/3.0f, (kScreenWidth-20)/3.0f * 1.3);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[JSMyCollectShortVideoCell class] forCellWithReuseIdentifier:@"JSMyCollectShortVideoCell"];
    }
    return _collectionView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)refreshDataWithHeaderRefresh:(BOOL)isHeaderRefresh{
    if (isHeaderRefresh) {
        self.currentPage = 1;
        [self.dataArray removeAllObjects];
    }else{
        self.currentPage ++;
    }
    
    [JSNetworkManager requestCollectListWithType:2 pageNumber:self.currentPage complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (isSuccess) {
            NSArray *listArray = contentDict[@"list"];
            for (NSDictionary *dict in listArray) {
                JSCollectModel *model = [MTLJSONAdapter modelOfClass:[JSCollectModel class] fromJSONDictionary:dict error:nil];
                [self.dataArray addObject:model];
            }
            
            //            for (int i=0; i<10; i++) {
            //                JSCollectModel *model = [[JSCollectModel alloc]init];
            //                model.title = @"这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥";
            //                model.channel = @"这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥这是弄啥";
            //                model.publishTime = @"1018-11-11 11:11:11";
            //                [self.dataArray addObject:model];
            //            }
            if (listArray.count < 10) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (self.dataArray.count <= 0) {
                self.nodataLabel.hidden = NO;
                self.collectionView.hidden = YES;
            }else{
                self.nodataLabel.hidden = YES;
                self.collectionView.hidden = NO;
            }
            
            [self.collectionView reloadData];
        }else{
            if (!isHeaderRefresh) {
                self.currentPage --;
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nodataLabel];
    
    [self.nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.nodataLabel.size);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(150);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
     [self.collectionView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;//self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSMyCollectShortVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSMyCollectShortVideoCell" forIndexPath:indexPath];
    return cell;
}




@end

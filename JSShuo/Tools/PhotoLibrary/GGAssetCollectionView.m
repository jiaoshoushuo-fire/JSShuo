//
//  GGAssetCollectionView.m
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import "GGAssetCollectionView.h"
#import <Photos/Photos.h>
#import "GGAssetCollectionCell.h"

static CGFloat const kEdgePadding = 10.0f;

@interface GGAssetCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) AssetMediaOption mediaOption;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <NSDictionary<PHAssetCollection *,NSNumber *> *> *assetCollectionAndCount;

@end

@implementation GGAssetCollectionView

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 12.0f;
        layout.itemSize = CGSizeMake(self.width - 2*kEdgePadding, 79);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(kEdgePadding, kEdgePadding, kEdgePadding, kEdgePadding);
        [_collectionView registerClass:[GGAssetCollectionCell class] forCellWithReuseIdentifier:@"GGAssetCollectionCell"];
       
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame mediaOption:(AssetMediaOption)mediaOption {
    if (self = [super initWithFrame:frame]) {
        self.mediaOption = mediaOption;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [GGPhotoLibrary fetchAssetCollectionsMediaOption:self.mediaOption completion:^(NSArray<NSDictionary<PHAssetCollection *,NSNumber *> *> *result) {
        self.assetCollectionAndCount = result;
        [self.collectionView reloadData];
    }];
}
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetCollectionAndCount.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary<PHAssetCollection *, NSNumber *> *dict = [self.assetCollectionAndCount objectAtIndex:indexPath.item];
    
    GGAssetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GGAssetCollectionCell" forIndexPath:indexPath];
    PHAssetCollection *collection = [[dict allKeys] firstObject];
    NSInteger count = [[[dict allValues] firstObject] integerValue];
    [cell bindWithModel:collection count:count];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary<PHAssetCollection *, NSNumber *> *dict = [self.assetCollectionAndCount objectAtIndex:indexPath.item];
    
    PHAssetCollection *assetCollection = [[dict allKeys] firstObject];
    if (self.assetCollectionHandler) {
        self.assetCollectionHandler(assetCollection);
    }
}

@end

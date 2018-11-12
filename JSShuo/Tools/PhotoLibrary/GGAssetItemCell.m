//
//  GGAssetItemCell.m
//  GuaGua
//
//  Created by  乔中祥 on 2017/11/13.
//  Copyright © 2017年 guagua. All rights reserved.
//

#import "GGAssetItemCell.h"

@interface GGAssetItemCell()
@property (nonatomic, strong) UIImageView *assetImageView;
@property (nonatomic, strong) UILabel *videoDurationLabel;
@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong) UIImageView *gifIcon;
@end

@implementation GGAssetItemCell
- (UIImageView *)assetImageView {
    if (!_assetImageView) {
        _assetImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _assetImageView.clipsToBounds = YES;
        _assetImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _assetImageView;
}
- (UILabel *)videoDurationLabel {
    if (!_videoDurationLabel) {
        _videoDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.contentView.height - 15, self.contentView.width - 10, 13)];
        _videoDurationLabel.textAlignment = NSTextAlignmentRight;
        _videoDurationLabel.textColor = [UIColor whiteColor];
        _videoDurationLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _videoDurationLabel;
}
- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"asset_check_normal"]];
        [_checkImageView sizeToFit];
        _checkImageView.center = CGPointMake(self.contentView.width - 5 - _checkImageView.width/2,
                                             5 + _checkImageView.height/2);
    }
    return _checkImageView;
}

- (UIImageView *)gifIcon {
    if (!_gifIcon) {
        _gifIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gif_indicator"]];
        [_gifIcon sizeToFit];
        _gifIcon.center = CGPointMake(self.contentView.width - 2 - _gifIcon.width / 2, self.contentView.height - 2 - _gifIcon.height / 2);
    }
    return _gifIcon;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _model = nil;
    self.assetImageView.image = nil;
    self.videoDurationLabel.hidden = YES;
    self.checkImageView.image = [UIImage imageNamed:@"asset_check_normal"];
    self.gifIcon.hidden = YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.assetImageView];
        [self.contentView addSubview:self.videoDurationLabel];
        [self.contentView addSubview:self.checkImageView];
        [self.contentView addSubview:self.gifIcon];
        self.gifIcon.hidden = YES;
        self.videoDurationLabel.hidden = YES;
    }
    return self;
}

+ (CGSize)sizeWithModel:(id)model {
    CGFloat width = (kScreenWidth - 2 * 1.5) / 3;
    return CGSizeMake(width, width);
}


- (void)bindWithModel:(id)model {
    _model = model;
    if ([model isKindOfClass:[PHAsset class]]) {
        PHAsset *asset = (PHAsset *)model;
        
        if (SYSTEM_VERSION_NOT_LESS_THAN(@"9.0")) {
            NSArray *sources = [PHAssetResource assetResourcesForAsset:asset];
            PHAssetResource *source = [sources firstObject];
            if ([source.uniformTypeIdentifier isEqualToString:@"com.compuserve.gif"]) {
                self.gifIcon.hidden = NO;
            }
        }
        
        @weakify(self)
        [GGPhotoLibrary requestImageForAsset:asset
                                  preferSize:CGSizeMake(320, 320)
                                  completion:^(UIImage *image, NSDictionary *info) {
                                      @strongify(self)
                                      self.assetImageView.image = image;
                                  }];
        self.videoDurationLabel.hidden = (asset.mediaType != PHAssetMediaTypeVideo);
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            NSInteger duration = (NSInteger)asset.duration;
            NSInteger minute = duration / 60;
            NSInteger second = duration % 60;
            self.videoDurationLabel.text = [NSString stringWithFormat:@"%@:%@%@", @(minute), second < 10 ? @"0" : @"", @(second)];
        }
        self.checkImageView.hidden = NO;
    } else if (model == nil) {
        self.assetImageView.image = [UIImage imageNamed:@"camera_take_photo"];
        self.videoDurationLabel.hidden = YES;
        self.checkImageView.hidden = YES;
    }
}
- (void)markCheck:(BOOL)check {
    self.checkImageView.image = check ? [UIImage imageNamed:@"asset_check_selected"] : [UIImage imageNamed:@"asset_check_normal"];
}

@end

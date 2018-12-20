//
//  JSActivityCell.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/28.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSActivityCell.h"



@implementation JSActivityCenterModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"activityId" : @"activityId",
             @"image":@"image",
             @"name":@"name",
             @"url":@"url"
             };
}

@end

@interface JSActivityCell()
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *begainButton;
@end

@implementation JSActivityCell

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _imageView;
}
- (UIButton *)begainButton{
    if (!_begainButton) {
        _begainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_begainButton setBackgroundImage:[UIImage imageNamed:@"js_activity_cell_button_back"] forState:UIControlStateNormal];
        [_begainButton setTitle:@"开始活动" forState:UIControlStateNormal];
        _begainButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_begainButton setTitleColor:[UIColor colorWithHexString:@"BA3329"] forState:UIControlStateNormal];
        [_begainButton sizeToFit];
    }
    return _begainButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.begainButton];
        
        [self.begainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.begainButton.size);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.bottom.equalTo(self.begainButton.mas_top).offset(-10);
        }];
    }
    return self;
}
- (void)setModel:(JSActivityCenterModel *)model{
    _model = model;
    [self.begainButton setTitle:model.name forState:UIControlStateNormal];
    [self.imageView setImageWithURL:[NSURL URLWithString:model.image] placeholder:nil];
}
@end

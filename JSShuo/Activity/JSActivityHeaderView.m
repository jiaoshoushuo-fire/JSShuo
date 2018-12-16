//
//  JSActivityHeaderView.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/28.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSActivityHeaderView.h"

@interface JSActivityHeaderView ()
@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation JSActivityHeaderView

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"js_activity_zhengdian"];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(self);
//            make.left.equalTo(self).offset(10);
//            make.right.equalTo(self).offset(-10);
//            make.edges.equalTo(self);
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(75);
        }];
        @weakify(self)
        [self.imageView bk_whenTapped:^{
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedHeaderView)]) {
                [self.delegate didSelectedHeaderView];
            
            }
        }];
    }
    return self;
}

@end

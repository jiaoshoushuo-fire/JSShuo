//
//  JSInvitationViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/14.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSInvitationViewController.h"
#import "JSAdjustButton.h"

@interface JSInvitationViewController ()
@property (nonatomic, strong)UIImageView *headerView;
@property (nonatomic, strong)UIButton *shareButton;
@property (nonatomic, strong)UILabel *shareCodeLabel;
@property (nonatomic, strong)YYLabel *alertLabel;

@property (nonatomic, strong)UIView *bottomBar;
@end

@implementation JSInvitationViewController

- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc]init];
        _headerView.image = [UIImage imageNamed:@"js_share_header_back"];
        _headerView.size = CGSizeMake(kScreenWidth-20, (kScreenWidth-20)/2.536);
    }
    return _headerView;
}
- (UIView *)bottomBar{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc]init];
        _bottomBar.backgroundColor = [UIColor whiteColor];
        _bottomBar.size = CGSizeMake(kScreenWidth, 50);
    }
    return _bottomBar;
}
- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"立即分享赚钱" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareButton setBackgroundColor:[UIColor colorWithHexString:@"FBD058"]];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _shareButton.size = CGSizeMake(125, 30);
        _shareButton.clipsToBounds = YES;
        _shareButton.layer.cornerRadius = _shareButton.height/2.0f;
    }
    return _shareButton;
}
- (UILabel *)shareCodeLabel{
    if (!_shareCodeLabel) {
        _shareCodeLabel = [[UILabel alloc]init];
        _shareCodeLabel.textColor = [UIColor whiteColor];
        _shareCodeLabel.font = [UIFont systemFontOfSize:12];
        _shareCodeLabel.textAlignment = NSTextAlignmentCenter;
        _shareCodeLabel.size = CGSizeMake(200, 20);
    }
    return _shareCodeLabel;
}
- (YYLabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[YYLabel alloc]init];
        _alertLabel.displaysAsynchronously = YES;
        _alertLabel.ignoreCommonProperties = YES;
        _alertLabel.backgroundColor = [UIColor colorWithHexString:@"F9F0D5"];
        
        NSString *text = @"邀请一位好友获得8元!";
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"js_profile_news_icon"];
        [imageView sizeToFit];
        
        NSMutableAttributedString *imageAttributeString = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
        [imageAttributeString insertString:@"    " atIndex:0];
        [imageAttributeString appendString:@" "];
        [imageAttributeString appendString:text];
        
        imageAttributeString.font = [UIFont systemFontOfSize:12];
        
        [imageAttributeString setColor:[UIColor colorWithHexString:@"333333"] range:[imageAttributeString.string rangeOfString:text]];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAXFLOAT, 30) text:imageAttributeString];
        
        [_alertLabel setTextLayout:layout];
        _alertLabel.size = layout.textBoundingSize;
        
    }
    return _alertLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.alertLabel];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.shareButton];
    [self.headerView addSubview:self.shareCodeLabel];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.headerView.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.alertLabel.mas_bottom).offset(10);
    }];
    
    [self.shareCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.shareCodeLabel.size);
        make.centerX.equalTo(self.headerView);
        make.bottom.equalTo(self.headerView).offset(-5);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.shareButton.size);
        make.centerX.equalTo(self.headerView);
        make.bottom.equalTo(self.shareCodeLabel.mas_top).offset(-10);
    }];
    
    [self initBottomBar];
}

- (void)initBottomBar{
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        CGFloat tap = 0;
        if (IS_IPHONE_X) {
            tap = -34;
        }
        make.bottom.equalTo(self.view).offset(tap);
    }];
    
    CGFloat width = kScreenWidth/5.0f;
    CGFloat height = 50;
    NSArray *images = @[@"js_profile_invi_firend",@"js_profile_invi_firend",@"js_profile_invi_face",@"js_profile_invi_message",@"js_profile_invi_message"];
    NSArray *titles = @[@"微信邀请",@"朋友圈分享",@"",@"QQ分享",@"短信分享"];
    for (int i = 0; i<5; i++) {
        JSAdjustButton *button = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, 0, width, height);
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor colorWithHexString:@"A7A7A7"] forState:UIControlStateNormal];
        [self.bottomBar addSubview:button];
    }

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

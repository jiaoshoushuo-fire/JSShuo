//
//  JSRedPacketViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/22.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSRedPacketViewController.h"
#import "JSRedPerformViewController.h"
#import "JSNetworkManager+Mission.h"
#import "JSActivityRuleViewController.h"

@interface JSRedPacketViewController ()
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIImageView *titleLabel;
@property (nonatomic, strong)UIImageView *subTitleView;

@property (nonatomic, strong)UIButton *ruleButton;
@property (nonatomic, strong)UIImageView *midView;
@property (nonatomic, strong)UILabel *midTitleLabel;
@property (nonatomic, strong)UIButton *enterButton;
@property (nonatomic, strong)UIView *moneyView;

@property (nonatomic, strong)UIButton *shareButton;
@property (nonatomic, copy)NSString *ruleUrl;
@end

@implementation JSRedPacketViewController

- (UIImageView *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UIImageView alloc]init];
        _titleLabel.image = [UIImage imageNamed:@"js_mission_red_title"];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UIImageView *)subTitleView{
    if (!_subTitleView) {
        _subTitleView = [[UIImageView alloc]init];
        _subTitleView.image = [UIImage imageNamed:@"js_mission_subTitle_back"];
        [_subTitleView sizeToFit];
    }
    return _subTitleView;
}
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"js_mission_red_back"];
//        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}
- (UILabel *)midTitleLabel{
    if (!_midTitleLabel) {
        _midTitleLabel = [[UILabel alloc]init];
        _midTitleLabel.font = [UIFont systemFontOfSize:18];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:@"本场待瓜分红包"];
        [attributeStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor redColor]
                              range:NSMakeRange(5, 2)];
        _midTitleLabel.attributedText = attributeStr;
        [_midTitleLabel sizeToFit];
    }
    return _midTitleLabel;
}
- (UIButton *)enterButton{
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitleColor:[UIColor colorWithHexString:@"7C7C7C"] forState:UIControlStateNormal];
        [_enterButton setTitle:@"立即进场" forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _enterButton.size = CGSizeMake(123, 34);
        _enterButton.backgroundColor = [UIColor colorWithHexString:@"FBE8DE"];
        _enterButton.clipsToBounds = YES;
        _enterButton.layer.cornerRadius = _enterButton.height/2.0f;
        @weakify(self)
        [_enterButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            JSRedPerformViewController *redVC = [[JSRedPerformViewController alloc]init];
            redVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:redVC animated:YES complete:nil];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}
- (UIView *)moneyView{
    if (!_moneyView) {
        _moneyView = [[UIView alloc]init];
    }
    return _moneyView;
}
- (UIButton *)ruleButton{
    if (!_ruleButton) {
        _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ruleButton setTitle:@"活动规则" forState:UIControlStateNormal];
        [_ruleButton setTitleColor:[UIColor colorWithHexString:@"B1190E"] forState:UIControlStateNormal];
        _ruleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_ruleButton setBackgroundImage:[UIImage imageNamed:@"js_mission_guice_back"] forState:UIControlStateNormal];
        [_ruleButton sizeToFit];
        @weakify(self)
        [_ruleButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            JSActivityRuleViewController *webVC = [[JSActivityRuleViewController alloc]initWithUrl:self.ruleUrl];
            [self.rt_navigationController pushViewController:webVC animated:YES complete:nil];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _ruleButton;
}
- (UIImageView *)midView{
    if (!_midView) {
        _midView = [[UIImageView alloc]init];
        _midView.image = [UIImage imageNamed:@"js_guafen_back"];
        _midView.userInteractionEnabled = YES;
    }
    return _midView;
}
- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"js_mission_share_title"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"js_mission_share_title"] forState:UIControlStateHighlighted];
        [_shareButton sizeToFit];
        @weakify(self)
        [_shareButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            NSLog(@"share action");
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _shareButton;
}
- (void)createMoneyViewWithMoney:(NSInteger)money{
    NSString *string = [NSString stringWithFormat:@"￥%@元",@(money)];
    CGFloat width = 30;
    CGFloat tap = ((kScreenWidth - 60)-(string.length*30))/(string.length + 1);
    
    for (int i=0; i<string.length; i++) {
        NSString *temp = [string substringWithRange:NSMakeRange(i, 1)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(tap + (tap + width) * i, 0, width, width)];
        imageView.image = [UIImage imageNamed:@"js_mission_zi_back"];
        UILabel *textLabel = [[UILabel alloc]initWithFrame:imageView.bounds];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont boldSystemFontOfSize:20];
        textLabel.text = temp;
        
        [self.moneyView addSubview:imageView];
        [imageView addSubview:textLabel];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包专场";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.subTitleView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.midView];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.ruleButton];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleLabel.size);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(30);
    }];
    [self.subTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.subTitleView.size);
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(131);
        make.top.mas_equalTo(150);
    }];
    [self.ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.ruleButton.size);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(30);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.shareButton.size);
        CGFloat tap = 60;
        if (IS_IPHONE_X) {
            tap += 34;
        }
        make.bottom.equalTo(self.view).offset(-tap);
        make.centerX.equalTo(self.view);
    }];
    
    [self.midView addSubview:self.midTitleLabel];
    [self.midView addSubview:self.moneyView];
    [self.midView addSubview:self.enterButton];
    
    [self.midTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.midTitleLabel.size);
        make.centerX.equalTo(self.midView);
        make.top.equalTo(self.midView).offset(10);
    }];
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.midView);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.midView);
    }];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.enterButton.size);
        make.centerX.equalTo(self.midView);
        make.bottom.equalTo(self.midView).offset(-10);
    }];
    
    
    [JSNetworkManager requestActivityHomePageComplement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        if (isSuccess) {
            NSInteger amount = [contentDict[@"amount"] integerValue];
            self.ruleUrl = contentDict[@"ruleUrl"];
            [self createMoneyViewWithMoney:amount];
        }
    }];
    // Do any additional setup after loading the view.
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

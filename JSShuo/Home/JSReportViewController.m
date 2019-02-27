
//
//  JSReportViewController.m
//  JSShuo
//
//  Created by li que on 2019/2/19.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import "JSReportViewController.h"
#import "JSDetailNavView.h"
#import "JSNetworkManager+Poster.h"

@interface JSReportViewController ()
@property (nonatomic,strong) JSDetailNavView *navView;
@property (nonatomic,strong) UIView *labelContentView;
@property (nonatomic,strong) NSNumber *selectedNum;
@end

@implementation JSReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"举报";
    [self initContentView];
}

- (void) initContentView {
    UILabel *resoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth-30, 30)];
    resoneLabel.textColor = [UIColor blackColor];
    resoneLabel.textAlignment = NSTextAlignmentLeft;
    resoneLabel.font = [UIFont systemFontOfSize:14];
    resoneLabel.text = @"请选择举报原因";
    [self.view addSubview:resoneLabel];
    
    
    NSArray *textArray = @[@"标题夸张",@"低俗色情",@"广告软文",@"重复旧闻",@"观点错误",@"事实不符",@"网络诈骗",@"疑似抄袭",@"敏感时政"];
    CGFloat leftGap = 15;
    CGFloat topGap = 20;
    CGFloat gap = 10;
    int row = 3;
    CGFloat width = (ScreenWidth - 2*leftGap - (row+1-2)*gap)/row;
    CGFloat height = 30;
    int lineNum = ceil(textArray.count/row);
    self.labelContentView.frame = CGRectMake(0, CGRectGetMaxY(resoneLabel.frame), ScreenWidth, (topGap)*2+lineNum*height+topGap*2);
    [self.view addSubview:_labelContentView];
    for (int i = 0; i < textArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat orignalX = leftGap + (i%row)*(width+gap);
        CGFloat orignalY = topGap + (ceil(i/row))*(height+topGap);
        btn.frame = CGRectMake(orignalX, orignalY, width, height);
//        i / row //行
//        i % row // 列
        [btn setTitle:textArray[i] forState:UIControlStateNormal];
        btn.tag = i+1000+1;
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [[UIColor colorWithHexString:@"A8A8A8"] CGColor];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectedResone:) forControlEvents:UIControlEventTouchUpInside];
        [self.labelContentView addSubview:btn];
    }
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.frame = CGRectMake(15, CGRectGetMaxY(self.labelContentView.frame), ScreenWidth-15*2, 40);
    reportBtn.backgroundColor = [UIColor colorWithHexString:@"F44336"];
    [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    reportBtn.layer.cornerRadius = 5;
    [reportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reportBtn addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reportBtn];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.frame = CGRectMake(15, CGRectGetMaxY(reportBtn.frame), ScreenWidth-15*2, 80);
    bottomLabel.textAlignment = NSTextAlignmentLeft;
    bottomLabel.font = [UIFont systemFontOfSize:13];
    bottomLabel.numberOfLines = 0;
    bottomLabel.textColor = [UIColor colorWithHexString:@"545454"];
    bottomLabel.text = @"叫兽说致力于为您提供最优质的内容，感谢您为我们举报不良内容";
    [self.view addSubview:bottomLabel];
}

- (void) selectedResone:(UIButton *)btn {
    for (UIButton *subview in self.labelContentView.subviews) {
        subview.backgroundColor = [UIColor whiteColor];
        subview.layer.borderColor = [[UIColor colorWithHexString:@"A8A8A8"] CGColor];
    }
    btn.backgroundColor = [UIColor colorWithHexString:@"F44336"];
    btn.layer.borderColor = [[UIColor colorWithHexString:@"F44336"] CGColor];
    NSNumber *reason = [NSNumber numberWithInteger:btn.tag-1000];
    self.selectedNum = reason;
}

- (void) report:(UIButton *)btn {
    if (self.selectedNum) {
        [JSNetworkManager tipOffCircleWithID:self.posterID reason:self.selectedNum complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDic) {
            if (isSuccess) {
                [self.rt_navigationController popViewControllerAnimated:YES complete:^(BOOL finished) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已举报" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alertView show];
                }];
            }else {
                [self.rt_navigationController popViewControllerAnimated:YES complete:^(BOOL finished) {
                    
                }];
            }
        }];
    }
}

- (void) setupNav {
    self.navView = [[JSDetailNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navView.titleLabel.text = @"举报";
    [_navView.backBtn bk_addEventHandler:^(id sender) {
        [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navView];
}

- (UIView *)labelContentView {
    if (!_labelContentView) {
        _labelContentView = [[UIView alloc] init];
    }
    return _labelContentView;
}


@end

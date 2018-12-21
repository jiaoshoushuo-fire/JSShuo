//
//  JSStartupViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSStartupViewController.h"
#import "AppDelegate.h"

@interface JSStartupViewController ()
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation JSStartupViewController

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        
        _scrollView.pagingEnabled = YES;
        
    }
    return _scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor randomColor];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[AppDelegate instance] switchNextRootViewController];
//    BOOL isFirstLogin = [[NSUserDefaults standardUserDefaults]boolForKey:kGuidanceMark];
//    if (isFirstLogin) {
//        [[AppDelegate instance] switchNextRootViewController];
//    }else{
//        NSArray *images = @[@"js_yindao_number1",@"js_yindao_number3"/*,@"js_yindao_number2"*/];
//        NSArray *image_Xs = @[@"js_yindao_number1_x",@"js_yindao_number3_x"/*,@"js_yindao_number2_x"*/];
//        
//        for (int i = 0; i<images.count; i++) {
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
//            imageView.userInteractionEnabled = YES;
//            if (IS_IPHONE_X) {
//                imageView.image = [UIImage imageNamed:image_Xs[i]];
//            }else{
//                imageView.image = [UIImage imageNamed:images[i]];
//            }
//            if (i == images.count - 1) {
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                [button setTitle:@"开启赚钱之旅" forState:UIControlStateNormal];
//                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//                button.titleLabel.font = [UIFont systemFontOfSize:15];
//                button.size = CGSizeMake(100, 30);
//                button.clipsToBounds = YES;
//                button.layer.cornerRadius = button.height/2.0f;
//                button.layer.borderWidth = 0.5;
//                button.layer.borderColor = [[UIColor redColor]CGColor];
//                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//                
//                [imageView addSubview:button];
//                [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.size.mas_equalTo(button.size);
//                    make.centerX.equalTo(imageView);
//                    make.bottom.equalTo(imageView).offset(-20);
//                }];
//            }
//            [self.scrollView addSubview:imageView];
//        }
//        self.scrollView.contentSize = CGSizeMake(kScreenWidth * images.count, 0);
//        [self.view addSubview:self.scrollView];
//        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
//    }
    
}
- (void)buttonAction:(UIButton *)button{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGuidanceMark];
    [[AppDelegate instance] switchNextRootViewController];
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

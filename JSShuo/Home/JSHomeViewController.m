//
//  JSHomeViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSHomeViewController.h"
#import "JSLoginMainViewController.h"

@interface JSHomeViewController ()

@end

@implementation JSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推荐";
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"登陆" forState:UIControlStateNormal];
    [testButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    testButton.frame = CGRectMake(100, 100, 100, 100);
    @weakify(self)
    [testButton bk_addEventHandler:^(id sender) {
        @strongify(self)
        JSLoginMainViewController *loginVC = [[JSLoginMainViewController alloc]init];
        [self.tabBarController presentViewController:loginVC animated:YES completion:nil];
        
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
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

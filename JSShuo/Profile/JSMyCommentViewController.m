//
//  JSMyCommentViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/19.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMyCommentViewController.h"
#import <WMPageController.h>
#import "JSSubMyCommentViewController.h"
#import "JSNetworkManager+Login.h"
#import "JSMyCommentCell.h"

@interface JSMyCommentViewController ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, strong)WMPageController *pageController;
@property (nonatomic, strong)NSArray *topTitles;
@property (nonatomic, strong)NSArray *subVCs;
@end

@implementation JSMyCommentViewController

- (NSArray *)topTitles{
    if (!_topTitles) {
        _topTitles = @[@"我的评论",@"我收到的评论"];
    }
    return _topTitles;
}
- (NSArray *)subVCs{
    if (!_subVCs) {
        JSSubMyCommentViewController *subVC = [[JSSubMyCommentViewController alloc]init];
        subVC.userModel = self.userModel;
        
        JSSubMyCommentViewController *subVC2 = [[JSSubMyCommentViewController alloc]init];
        subVC2.isReceive = YES;
        subVC2.userModel = self.userModel;
        
        _subVCs = @[subVC,subVC2];
    }
    return _subVCs;
}
- (WMPageController *)pageController{
    if (!_pageController) {
        _pageController = [[WMPageController alloc]init];
        _pageController.menuViewStyle = WMMenuViewStyleLine;
        _pageController.menuView.lineColor = [UIColor colorWithHexString:@"F44336"];
        //        _pageController.menuBGColor = [UIColor whiteColor];
        //        _pageController.menuHeight = 42.f;
        _pageController.menuItemWidth = kScreenWidth/2.0f;
        
        _pageController.titleColorNormal = [UIColor colorWithHexString:@"666666"];
        _pageController.titleSizeNormal = 15;
        _pageController.titleColorSelected = [UIColor colorWithHexString:@"F44336"];
        _pageController.titleSizeSelected = 15;
        _pageController.bounces = YES;
        _pageController.delegate = self;
        _pageController.dataSource = self;
        _pageController.selectIndex = 0;
    }
    return _pageController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的评论";
    // Do any additional setup after loading the view.
    [self addChildViewController:self.pageController];
    self.pageController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pageController.view];
    
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"清空" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"F44336"] forState:UIControlStateNormal];
    rightButton.size = CGSizeMake(60, 40);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(cleanUpComment) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

- (void)cleanUpComment{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"你确定要清空评论吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *makeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JSSubMyCommentViewController *vc = self.subVCs[self.pageController.selectIndex];
        if (vc.dataArray.count > 0) {
            NSMutableArray *idsArray = [NSMutableArray array];
            for (JSMyCommentModel *model in vc.dataArray) {
                [idsArray addObject:@(model.commentId).stringValue];
            }
            NSString *string = [idsArray componentsJoinedByString:@","];
            [JSNetworkManager clearCommentWithIs:string Complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
                if (isSuccess) {
                    [self showAutoDismissTextAlert:@"清除成功"];
                    [self performSelector:@selector(dismissSelfVC) withObject:nil afterDelay:2];
                }
            }];
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:makeAction];
    [alertVC addAction:cancelAction];
    [self.rt_navigationController presentViewController:alertVC animated:YES completion:nil];
    
}
- (void)dismissSelfVC{
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}
#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.topTitles.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index < 0 || index > self.topTitles.count - 1) {
        return nil;
    }
    
    
    return self.subVCs[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    return self.topTitles[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, self.view.width, 42);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = 42;
    return CGRectMake(0, originY, self.view.width, self.pageController.view.height - originY);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController * _Nonnull)viewController withInfo:(NSDictionary * _Nonnull)info{
    
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

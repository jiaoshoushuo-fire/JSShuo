//
//  JSBaseViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseViewController.h"
#import "JSNavigationBar.h"

@interface JSBaseViewController ()

@end

@implementation JSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLoginSuccessNoti:) name:kLoginSuccessNotification object:nil];
    // Do any additional setup after loading the view.
}

- (Class)rt_navigationBarClass {
    
    return [JSNavigationBar class];
}
- (void)userLoginSuccessNoti:(NSNotification *)notification{
    
};
- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_top_back"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:target
                                                                      action:action];
    backButtonItem.tintColor = [UIColor colorWithIndex:4];
    return backButtonItem;
}



@end

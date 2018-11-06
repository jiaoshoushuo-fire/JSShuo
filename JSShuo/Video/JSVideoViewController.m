//
//  JSVideoViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSVideoViewController.h"
#import "JSLongVideoCell.h"
#import "JSNetworkManager+LongVideo.h"

@interface JSVideoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *datas;
@end

@implementation JSVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *params = @{@"pageNum":@1,@"channel":@"11",@"pageSize":@20};
    [JSNetworkManager requestLongVideoListWithParams:params complent:^(NSArray * _Nonnull modelsArray) {
        NSLog(@"%@",modelsArray);
        self.datas = modelsArray;
        if (self.tableView) {
            [self.tableView reloadData];
        }
    }];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-60) style:UITableViewStylePlain];
    [_tableView registerClass:[JSLongVideoCell class] forCellReuseIdentifier:@"JSLongVideoCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSLongVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSLongVideoCell" forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40+(ScreenWidth-30)*9/16+9+25;
}



@end

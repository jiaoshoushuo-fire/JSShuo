//
//  JSHomeViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSHomeViewController.h"
#import "JSLoginMainViewController.h"
#import "JSNetworkManager+LongVideo.h"
//#import "JSHomeTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JSShowTypeBigPictureTableViewCell.h"
#import "JSShowTypeSmallPictureTableViewCell.h"
#import "JSShowTypeThreePictureTableViewCell.h"


@interface JSHomeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *datas;
@end

@implementation JSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *params = @{@"pageNum":@1,@"channel":self.genreID,@"pageSize":@20};
    [JSNetworkManager requestLongVideoListWithParams:params complent:^(NSArray * _Nonnull modelsArray) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < modelsArray.count; i++) {
            JSHomeModel *model = modelsArray[i];
            if (model.showType.intValue == 1 || model.showType.intValue == 2 || model.showType.intValue == 3) {
                [tempArr addObject:model];
            }
        }
        self.datas = (NSArray *)tempArr;
        if (self.tableView) {
            [self.tableView reloadData];
        }
    }];
    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-60) style:UITableViewStylePlain];
    self.tableView = [[UITableView alloc] init];
    [_tableView registerClass:[JSShowTypeBigPictureTableViewCell class] forCellReuseIdentifier:@"JSShowTypeBigPictureTableViewCell"];
    [_tableView registerClass:[JSShowTypeSmallPictureTableViewCell class] forCellReuseIdentifier:@"JSShowTypeSmallPictureTableViewCell"];
    [_tableView registerClass:[JSShowTypeThreePictureTableViewCell class] forCellReuseIdentifier:@"JSShowTypeThreePictureTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(ScreenHeight-49-60-38);
    }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSHomeModel *model = self.datas[indexPath.row];
    if (model.showType.intValue == 1) {
        JSShowTypeBigPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSShowTypeBigPictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else if (model.showType.intValue == 2) {
        JSShowTypeSmallPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSShowTypeSmallPictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else if (model.showType.intValue == 3) {
        JSShowTypeThreePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSShowTypeThreePictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else {
        NSLog(@"没有showType字段");
        JSShowTypeSmallPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSShowTypeSmallPictureTableViewCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSHomeModel *model = self.datas[indexPath.row];
    if (model.showType.intValue == 1) {
        return [tableView fd_heightForCellWithIdentifier:@"JSShowTypeBigPictureTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            // 重点(自适应高度必须实现)
            [self setupModelOfBigPictureCell:cell AtIndexPath:indexPath];
        }];
    } else if (model.showType.intValue == 2) {
        return [tableView fd_heightForCellWithIdentifier:@"JSShowTypeSmallPictureTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            // 重点(自适应高度必须实现)
            [self setupModelOfSmallPictureCell:cell AtIndexPath:indexPath];
        }];
    } else if (model.showType.intValue == 3) {
        return [tableView fd_heightForCellWithIdentifier:@"JSShowTypeThreePictureTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            // 重点(自适应高度必须实现)
            [self setupModelOfThreePictureCell:cell AtIndexPath:indexPath];
        }];
    } else {
        NSLog(@"没有showType字段");
    }
    return 0;
}


//预加载Cell内容
- (void)setupModelOfBigPictureCell:(JSShowTypeBigPictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell.model = [_datas objectAtIndex:indexPath.row];
}

- (void)setupModelOfSmallPictureCell:(JSShowTypeSmallPictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell.model = [_datas objectAtIndex:indexPath.row];
}

- (void)setupModelOfThreePictureCell:(JSShowTypeThreePictureTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell.model = [_datas objectAtIndex:indexPath.row];
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

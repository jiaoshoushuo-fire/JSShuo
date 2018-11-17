//
//  JSMyWalletViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/14.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMyWalletViewController.h"
#import "JSWalletSwitchSegmentView.h"
#import "JSAdjustButton.h"
#import "JSMyWalletCell.h"
#import "JSWithdrawViewController.h"
#import "JSNetworkManager+Login.h"
#import "JSConvertViewController.h"
#import "JSIncomeListViewController.h"
#import "JSShareManager.h"


@interface JSMyWalletHeaderView : UIView
@property (nonatomic, strong)YYLabel *alertLabel;
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)UILabel *titleLabel_1;
@property (nonatomic, strong)UILabel *balanceLabel;
@property (nonatomic, strong)UIButton *withdrawButton;
@property (nonatomic, strong)UILabel *titleLabel_2;
@property (nonatomic, strong)UILabel *totalLabel;
@property (nonatomic, strong)UILabel *titleLabel_3;
@property (nonatomic, strong)UILabel *todayLabel;

@property (nonatomic, strong)UIView *convertBackView;
@property (nonatomic, strong)UILabel *convertTitleLabel;
@property (nonatomic, strong)UIButton *convertButton;


@property (nonatomic, strong)UIImageView *bottomIconImage;
@property (nonatomic, strong)UILabel *bottomTitleLabel;
@property (nonatomic, strong)UIImageView *markImageview;

@property (nonatomic, strong)JSWalletSwitchSegmentView *switchView;

@property (nonatomic, strong)JSAccountModel *model;
@end

@implementation JSMyWalletHeaderView

- (JSWalletSwitchSegmentView *)switchView{
    if (!_switchView) {
        _switchView = [[JSWalletSwitchSegmentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [_switchView.optionButtonLeft setTitle:@"金币" forState:UIControlStateNormal];
        [_switchView.optionButtonRight setTitle:@"零钱" forState:UIControlStateNormal];
    }
    return _switchView;
}
- (YYLabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[YYLabel alloc]init];
        _alertLabel.displaysAsynchronously = YES;
        _alertLabel.ignoreCommonProperties = YES;
        _alertLabel.backgroundColor = [UIColor colorWithHexString:@"F9F0D5"];
        
        NSString *text = @"新手必看！为什么邀请好友可以赚取千万金币？";
        
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
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"js_profile_wallet_back"];
        _backImageView.size = CGSizeMake(kScreenWidth - 20, 210);
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _bottomView.size = CGSizeMake(kScreenWidth - 20, 60);
    }
    return _bottomView;
}

- (UILabel *)titleLabel_1{
    if (!_titleLabel_1) {
        _titleLabel_1 = [[UILabel alloc]init];
        _titleLabel_1.font = [UIFont systemFontOfSize:12];
        _titleLabel_1.textColor = [UIColor whiteColor];
        _titleLabel_1.text = @"当前余额";
        [_titleLabel_1 sizeToFit];
    }
    return _titleLabel_1;
}
- (UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.font = [UIFont boldSystemFontOfSize:20];
        _balanceLabel.textColor = [UIColor whiteColor];
    }
    return _balanceLabel;
}
- (UIButton *)withdrawButton{
    if (!_withdrawButton) {
        _withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _withdrawButton.size = CGSizeMake(70, 30);
        _withdrawButton.clipsToBounds = YES;
        _withdrawButton.layer.cornerRadius = 30/2.0f;
        [_withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawButton setTitleColor:[UIColor colorWithHexString:@"EB7155"] forState:UIControlStateNormal];
        _withdrawButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _withdrawButton.backgroundColor = [UIColor whiteColor];
    }
    return _withdrawButton;
}
- (UILabel *)titleLabel_2{
    if (!_titleLabel_2) {
        _titleLabel_2 = [[UILabel alloc]init];
        _titleLabel_2.font = [UIFont systemFontOfSize:12];
        _titleLabel_2.textColor = [UIColor whiteColor];
        _titleLabel_2.text = @"已累计赚取";
        [_titleLabel_2 sizeToFit];
    }
    return _titleLabel_2;
}
- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc]init];
        _totalLabel.font = [UIFont boldSystemFontOfSize:20];
        _totalLabel.textColor = [UIColor whiteColor];
    }
    return _totalLabel;
}
- (UILabel *)titleLabel_3{
    if (!_titleLabel_3) {
        _titleLabel_3 = [[UILabel alloc]init];
        _titleLabel_3.font = [UIFont systemFontOfSize:12];
        _titleLabel_3.textColor = [UIColor whiteColor];
        _titleLabel_3.text = @"今日金币";
        [_titleLabel_3 sizeToFit];
    }
    return _titleLabel_3;
}
- (UILabel *)todayLabel{
    if (!_todayLabel) {
        _todayLabel = [[UILabel alloc]init];
        _todayLabel.font = [UIFont boldSystemFontOfSize:20];
        _todayLabel.textColor = [UIColor whiteColor];
    }
    return _todayLabel;
}
- (UIView *)convertBackView{
    if (!_convertBackView) {
        _convertBackView = [[UIView alloc]init];
        _convertBackView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:0.14];
    }
    return _convertBackView;
}
- (UILabel *)convertTitleLabel{
    if (!_convertTitleLabel) {
        _convertTitleLabel = [[UILabel alloc]init];
        _convertTitleLabel.font = [UIFont systemFontOfSize:12];
        _convertTitleLabel.textColor = [UIColor whiteColor];
        _convertTitleLabel.text = @"汇率：20金币=0.1元";
        [_convertTitleLabel sizeToFit];
    }
    return _convertTitleLabel;
}
- (UIButton *)convertButton{
    if (!_convertButton) {
        _convertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _convertButton.size = CGSizeMake(70, 30);
        _convertButton.clipsToBounds = YES;
        _convertButton.layer.cornerRadius = 30/2.0f;
        [_convertButton setTitle:@"兑换" forState:UIControlStateNormal];
        [_convertButton setTitleColor:[UIColor colorWithHexString:@"EB7155"] forState:UIControlStateNormal];
        _convertButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _convertButton.backgroundColor = [UIColor whiteColor];
    }
    return _convertButton;
}
- (UIImageView *)bottomIconImage{
    if (!_bottomIconImage) {
        _bottomIconImage = [[UIImageView alloc]init];
        _bottomIconImage.size = CGSizeMake(42, 42);
        _bottomIconImage.clipsToBounds = YES;
        _bottomIconImage.layer.cornerRadius = _bottomIconImage.height/2.0f;
        _bottomIconImage.image = [UIImage imageNamed:@"js_profile_default_icon"];
    }
    return _bottomIconImage;
}
- (UILabel *)bottomTitleLabel{
    if (!_bottomTitleLabel) {
        _bottomTitleLabel = [[UILabel alloc]init];
        _bottomTitleLabel.font = [UIFont systemFontOfSize:14];
        _bottomTitleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _bottomTitleLabel.text = @"我的徒弟";
        [_bottomTitleLabel sizeToFit];
    }
    return _bottomTitleLabel;
}
- (UIImageView *)markImageview{
    if (!_markImageview) {
        _markImageview = [[UIImageView alloc]init];
        _markImageview.image = [UIImage imageNamed:@"personalCenter_arrow"];
        [_markImageview sizeToFit];
    }
    return _markImageview;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.alertLabel];
        [self addSubview:self.backImageView];
        [self addSubview:self.bottomView];
        [self addSubview:self.switchView];
        
        [self.backImageView addSubview:self.titleLabel_1];
        [self.backImageView addSubview:self.balanceLabel];
        [self.backImageView addSubview:self.withdrawButton];
        
        [self.backImageView addSubview:self.titleLabel_2];
        [self.backImageView addSubview:self.totalLabel];
        [self.backImageView addSubview:self.titleLabel_3];
        [self.backImageView addSubview:self.todayLabel];
        
        [self.backImageView addSubview:self.convertBackView];
        [self.convertBackView addSubview:self.convertTitleLabel];
        [self.convertBackView addSubview:self.convertButton];
        
        [self.bottomView addSubview:self.bottomIconImage];
        [self.bottomView addSubview:self.bottomTitleLabel];
        [self.bottomView addSubview:self.markImageview];
        
        [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(30);
        }];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.mas_equalTo(self.alertLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(210);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.mas_equalTo(self.backImageView.mas_bottom).offset(10);
            make.height.mas_equalTo(60);
        }];
        
        [self.titleLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel_1.size);
            make.left.equalTo(self.backImageView).offset(20);
            make.top.equalTo(self.backImageView).offset(18);
        }];
        
        [self.withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.withdrawButton.size);
            make.top.mas_equalTo(self.titleLabel_1.mas_top);
            make.right.equalTo(self.backImageView).offset(-24);
        }];
        
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel_1.mas_left);
            make.top.mas_equalTo(self.titleLabel_1.mas_bottom).offset(5);
            make.right.mas_equalTo(self.withdrawButton.mas_left);
            make.height.mas_equalTo(35);
        }];
        
        [self.titleLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel_2.size);
            make.left.mas_equalTo(self.titleLabel_1.mas_left);
            make.top.mas_equalTo(self.balanceLabel.mas_bottom).offset(10);
        }];
        
        [self.titleLabel_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel_3.size);
            make.left.mas_equalTo(self.titleLabel_2.mas_right).offset(70);
            make.top.mas_equalTo(self.titleLabel_2.mas_top);
        }];
        
        [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel_2.mas_left);
            make.height.mas_equalTo(35);
            make.right.mas_equalTo(self.todayLabel.mas_left);
            make.top.mas_equalTo(self.titleLabel_2.mas_bottom).offset(5);
        }];
        
        [self.todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel_3.mas_left);
            make.right.mas_equalTo(self.withdrawButton.mas_right);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(self.totalLabel.mas_top);
        }];
        
        [self.convertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backImageView);
            make.height.mas_equalTo(43);
            make.bottom.equalTo(self.backImageView).offset(-20);
        }];
        
        [self.convertTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.convertTitleLabel.size);
            make.left.equalTo(self.convertBackView).offset(20);
            make.centerY.equalTo(self.convertBackView);
        }];
        [self.convertButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.convertButton.size);
            make.right.equalTo(self.convertBackView).offset(-24);
            make.centerY.mas_equalTo(self.convertTitleLabel.mas_centerY);
        }];
        
        [self.bottomIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.bottomIconImage.size);
            make.left.equalTo(self.bottomView).offset(10);
            make.centerY.equalTo(self.bottomView);
        }];
        [self.bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.bottomTitleLabel.size);
            make.left.mas_equalTo(self.bottomIconImage.mas_right).offset(12);
            make.centerY.mas_equalTo(self.bottomIconImage.mas_centerY);
        }];
        [self.markImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.markImageview.size);
            make.right.equalTo(self.bottomView).offset(-20);
            make.centerY.mas_equalTo(self.bottomIconImage.mas_centerY);
        }];
        
        [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(50);
        }];
    }
    return self;
}

- (void)setModel:(JSAccountModel *)model{
    _model = model;
    self.balanceLabel.text = [NSString stringWithFormat:@"￥%@",@(model.money)];
    self.totalLabel.text = [NSString stringWithFormat:@"￥%@",@(model.totalMoney)];
    self.todayLabel.text = [NSString stringWithFormat:@"￥%@",@(model.todayCoin)];
    self.convertTitleLabel.text = [NSString stringWithFormat: @"汇率：%@金币=1元",@(model.exchangeRate)];
    
}
@end

@interface JSMyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,JSConvertViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)JSMyWalletHeaderView *headerView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)JSAdjustButton *incomeListButton;
@property (nonatomic, strong)JSAdjustButton *shareButton;

@property (nonatomic, strong)UILabel *footerLabel;

@property (nonatomic, strong)NSMutableArray *goldDataArray;
@property (nonatomic, strong)NSMutableArray *looseDataArray;
@property (nonatomic, assign)BOOL isGold;

@property (nonatomic, assign)NSInteger currentGoldPage;
@property (nonatomic, assign)NSInteger currentLoosePage;
@end

@implementation JSMyWalletViewController

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
        _bottomView.layer.shadowOffset = CGSizeMake(0, 1);
        _bottomView.layer.shadowOpacity = 0.5;
        _bottomView.layer.shadowRadius = 3;
    }
    return _bottomView;
}
- (NSMutableArray *)goldDataArray{
    if (!_goldDataArray) {
        _goldDataArray = [NSMutableArray array];
        
    }
    return _goldDataArray;
}
- (NSMutableArray *)looseDataArray{
    if (!_looseDataArray) {
        _looseDataArray = [NSMutableArray array];
        
    }
    return _looseDataArray;
}
- (UILabel *)footerLabel{
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc]init];
        _footerLabel.text = @"只显示最近3日的收入情况";
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _footerLabel.textColor = [UIColor colorWithHexString:@"C8C8C8"];
        _footerLabel.font = [UIFont systemFontOfSize:16];
        _footerLabel.size = CGSizeMake(kScreenWidth, 30);
    }
    return _footerLabel;
}

- (JSAdjustButton *)incomeListButton{
    if (!_incomeListButton) {
        _incomeListButton = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        _incomeListButton.position = JSImagePositionLeft;
        _incomeListButton.itemSpace = 10;
        [_incomeListButton setImage:[UIImage imageNamed:@"js_profile_mywallet_income"] forState:UIControlStateNormal];
        [_incomeListButton setTitle:@"收入榜" forState:UIControlStateNormal];
        [_incomeListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _incomeListButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_incomeListButton setBackgroundImage:[UIImage imageNamed:@"js_tixian_back_image"] forState:UIControlStateNormal];
        @weakify(self)
        [_incomeListButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            JSIncomeListViewController *incomeVC = [[JSIncomeListViewController alloc]init];
            [self.rt_navigationController pushViewController:incomeVC animated:YES complete:nil];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _incomeListButton;
}
- (JSAdjustButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        _shareButton = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        _shareButton.position = JSImagePositionLeft;
        _shareButton.itemSpace = 10;
        [_shareButton setImage:[UIImage imageNamed:@"js_profile_mywallet_share"] forState:UIControlStateNormal];
        [_shareButton setTitle:@"晒收入赚金币" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"js_tixian_back_image"] forState:UIControlStateNormal];
        
        
        [_shareButton bk_addEventHandler:^(id sender) {
            
            [JSShareManager shareWithTitle:@"测试title" Text:@"测试text" Image:[UIImage imageNamed:@"js_profile_mywallet_share"] Url:@"https://www.baidu.com/" complement:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self showAutoDismissTextAlert:@"分享成功"];
                }else{
                    [self showAutoDismissTextAlert:@"分享失败"];
                }
            }];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
- (JSMyWalletHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[JSMyWalletHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 370)];
        @weakify(self)
        [_headerView.withdrawButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            JSWithdrawViewController *withVC = [[JSWithdrawViewController alloc]init];
            withVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:withVC animated:YES complete:nil];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_headerView.convertButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            JSConvertViewController *convertVC = [[JSConvertViewController alloc]init];
            convertVC.hidesBottomBarWhenPushed = YES;
            convertVC.accountModel = self.headerView.model;
            convertVC.delegate = self;
            [self.rt_navigationController pushViewController:convertVC animated:YES complete:nil];
        } forControlEvents:UIControlEventTouchUpInside];
        
        _headerView.switchView.selectedIndexChangedHandler = ^(NSUInteger index) {
            @strongify(self);
            self.isGold = index == 0 ? YES : NO;
            
            if (self.isGold) {
                if (self.goldDataArray.count <= 0) {
                    [self.tableView.mj_header beginRefreshing];
                }
            }else{
                if (self.looseDataArray.count <= 0) {
                    [self.tableView.mj_header beginRefreshing];
                }
            }
            [self.tableView reloadData];
        };
        
    }
    return _headerView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JSMyWalletCell class] forCellReuseIdentifier:@"JSMyWalletCell"];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerLabel;
        
        @weakify(self)
        _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self refreshDataListWithHeaderRefresh:YES];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self refreshDataListWithHeaderRefresh:NO];
        }];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        CGFloat tap = 0;
        if (IS_IPHONE_X) {
            tap = 34;
        }
        make.bottom.equalTo(self.view).offset(-tap);
    }];
    [self.bottomView addSubview:self.incomeListButton];
    [self.bottomView addSubview:self.shareButton];
    
    [self.incomeListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.shareButton.mas_left).offset(-30);
        make.width.mas_equalTo(self.shareButton.mas_width).dividedBy(2.0f);
        make.centerY.equalTo(self.bottomView);
        make.height.mas_equalTo(35);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.incomeListButton.mas_right).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.width.mas_equalTo(self.incomeListButton.mas_width).multipliedBy(2.0f);
        make.centerY.equalTo(self.bottomView);
        make.height.mas_equalTo(35);
    }];
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-1);
    }];
    // Do any additional setup after loading the view.
    _isGold = YES;
    self.currentGoldPage = 1;
    self.currentLoosePage = 1;
    
    [self refreshHeaderData];
    
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)refreshHeaderData{
    [JSNetworkManager queryAccountInfoWithComplement:^(BOOL isSuccess, JSAccountModel * _Nonnull accountModel) {
        if (isSuccess) {
            self.headerView.model = accountModel;
        }
    }];
}
- (void)refreshDataListWithHeaderRefresh:(BOOL)isHeaderRefresh{
    NSInteger typeIndex = self.isGold ? 1:2;
    if (isHeaderRefresh) {
        if (self.isGold) {
            self.currentGoldPage = 1;
            [self.goldDataArray removeAllObjects];
        }else{
            self.currentLoosePage = 1;
            [self.looseDataArray removeAllObjects];
        }
    }else{
        if (self.isGold) {
            self.currentGoldPage ++;
        }else{
            self.currentLoosePage ++;
        }
    }
    
    [JSNetworkManager queryListWithTypeIndex:typeIndex pageNumber:self.isGold ? self.currentGoldPage : self.currentLoosePage complement:^(BOOL isSuccess, NSDictionary * _Nonnull contenDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (isSuccess) {
            NSArray *listArray = contenDict[@"list"];
            for (NSDictionary *dict in listArray) {
                NSError *error = nil;
                JSDealModel *model = [MTLJSONAdapter modelOfClass:[JSDealModel class] fromJSONDictionary:dict error:&error];
                
                if (self.isGold) {
                    [self.goldDataArray addObject:model];
                }else{
                    [self.looseDataArray addObject:model];
                }
            }
            
            if (listArray.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
            
        }else{
            if (isHeaderRefresh) {
                if (self.isGold) {
                    
                }else{
                    
                }
            }else{
                
                if (self.isGold) {
                    self.currentGoldPage --;
                }else{
                    self.currentLoosePage --;
                }
            }
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isGold ? self.goldDataArray.count : self.looseDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSMyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSMyWalletCell" forIndexPath:indexPath];
    if (self.isGold) {
        JSDealModel *model = self.goldDataArray[indexPath.row];
        [cell configDealModel:model withType:1];
        
    }else{
        JSDealModel *model = self.looseDataArray[indexPath.row];

        [cell configDealModel:model withType:2];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma  mark - JSConvertViewControllerDelegate
- (void)didRefreshWithdrawViewController{
    [self refreshHeaderData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"JS_Refresh_Profile_info" object:nil];
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

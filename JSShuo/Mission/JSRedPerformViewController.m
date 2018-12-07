//
//  JSRedPerformViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/23.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSRedPerformViewController.h"
#import "CountDown.h"
#import "JSOpenRedPackCell.h"
#import "JSNetworkManager+Mission.h"
#import "JSActivityModel.h"

@interface JSCountDownView : UIView
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *hourLabel;
@property (nonatomic, strong)UILabel *blankLabel_1;
@property (nonatomic, strong)UILabel *minuteLabel;
@property (nonatomic, strong)UILabel *blankLabel_2;
@property (nonatomic, strong)UILabel *secondLabel;
@property (nonatomic, strong)UIView *backView;
@end

@implementation JSCountDownView

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.size = CGSizeMake(self.titleLabel.width+20+32*3+20*2, 32);
    }
    return _backView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"距离抢红包还有";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UILabel *)blankLabel_1{
    if (!_blankLabel_1) {
        _blankLabel_1 = [[UILabel alloc]init];
        _blankLabel_1.size = CGSizeMake(20, 25);
        _blankLabel_1.textColor = [UIColor whiteColor];
        _blankLabel_1.font = [UIFont systemFontOfSize:18];
        _blankLabel_1.text = @":";
        _blankLabel_1.textAlignment = NSTextAlignmentCenter;
    }
    return _blankLabel_1;
}
- (UILabel *)blankLabel_2{
    if (!_blankLabel_2) {
        _blankLabel_2 = [[UILabel alloc]init];
        _blankLabel_2.size = CGSizeMake(20, 25);
        _blankLabel_2.textColor = [UIColor whiteColor];
        _blankLabel_2.font = [UIFont systemFontOfSize:18];
        _blankLabel_2.text = @":";
        _blankLabel_2.textAlignment = NSTextAlignmentCenter;
    }
    return _blankLabel_2;
}
- (UILabel *)hourLabel{
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc]init];
        _hourLabel.font = [UIFont systemFontOfSize:18];
        _hourLabel.textColor = [UIColor colorWithHexString:@"F6332D"];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.backgroundColor = [UIColor colorWithHexString:@"FEDB03"];
        _hourLabel.size = CGSizeMake(32, 32);
        _hourLabel.clipsToBounds = YES;
        _hourLabel.layer.cornerRadius = 5;
    }
    return _hourLabel;
}
- (UILabel *)minuteLabel{
    if (!_minuteLabel) {
        _minuteLabel = [[UILabel alloc]init];
        _minuteLabel.font = [UIFont systemFontOfSize:18];
        _minuteLabel.textColor = [UIColor colorWithHexString:@"F6332D"];
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
        _minuteLabel.backgroundColor = [UIColor colorWithHexString:@"FEDB03"];
        _minuteLabel.size = CGSizeMake(32, 32);
        _minuteLabel.clipsToBounds = YES;
        _minuteLabel.layer.cornerRadius = 5;
    }
    return _minuteLabel;
}
- (UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc]init];
        _secondLabel.font = [UIFont systemFontOfSize:18];
        _secondLabel.textColor = [UIColor colorWithHexString:@"F6332D"];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.backgroundColor = [UIColor colorWithHexString:@"FEDB03"];
        _secondLabel.size = CGSizeMake(32, 32);
        _secondLabel.clipsToBounds = YES;
        _secondLabel.layer.cornerRadius = 5;
    }
    return _secondLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.hourLabel];
        [self.backView addSubview:self.blankLabel_1];
        [self.backView addSubview:self.minuteLabel];
        [self.backView addSubview:self.blankLabel_2];
        [self.backView addSubview:self.secondLabel];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.backView.size);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel.size);
            make.left.equalTo(self.backView);
            make.centerY.equalTo(self.backView);
        }];
        
        [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.hourLabel.size);
            make.left.equalTo(self.titleLabel.mas_right).offset(20);
            make.centerY.equalTo(self.backView);
        }];
        [self.blankLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.blankLabel_1.size);
            make.left.equalTo(self.hourLabel.mas_right);
            make.centerY.equalTo(self.backView);
        }];
        [self.minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.minuteLabel.size);
            make.left.equalTo(self.blankLabel_1.mas_right);
            make.centerY.equalTo(self.backView);
        }];
        [self.blankLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.blankLabel_2.size);
            make.left.equalTo(self.minuteLabel.mas_right);
            make.centerY.equalTo(self.backView);
        }];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.secondLabel.size);
            make.left.equalTo(self.blankLabel_2.mas_right);
            make.centerY.equalTo(self.backView);
        }];
    }
    return self;
}

@end

@interface JSRedPerformViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *moneyView;
@property (nonatomic, strong)UILabel *topTitleLabel;
@property (nonatomic, strong)JSCountDownView *countDownView;
@property (nonatomic, strong)UIImageView *openPackView;
@property (nonatomic, strong)UIButton *openButton;

@property (nonatomic, strong)CountDown *countDown;

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)JSActivityModel *currentModel;
@property (nonatomic, strong)NSArray *userList;

@end

@implementation JSRedPerformViewController

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"昨日抢红包达人";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((kScreenWidth-30)/2.0f, 35);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[JSOpenRedPackCell class] forCellWithReuseIdentifier:@"JSOpenRedPackCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
- (CountDown *)countDown{
    if (!_countDown) {
        _countDown = [[CountDown alloc]init];
    }
    return _countDown;
}
- (UIImageView *)openPackView{
    if (!_openPackView) {
        _openPackView = [[UIImageView alloc]init];
        _openPackView.image = [UIImage imageNamed:@"js_mission_kai_highlight"];
        [_openPackView sizeToFit];
        @weakify(self)
        [_openPackView bk_whenTapped:^{
            @strongify(self)
            [self openRedPackage];
        }];
    }
    return _openPackView;
}
- (UIButton *)openButton{
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openButton setTitle:@"点我领红包" forState:UIControlStateNormal];
        _openButton.backgroundColor = [UIColor colorWithHexString:@"F7EC78"];
        _openButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_openButton setTitleColor:[UIColor colorWithHexString:@"FE1F32"] forState:UIControlStateNormal];
        _openButton.size = CGSizeMake(84, 27);
        _openButton.clipsToBounds = YES;
        _openButton.layer.cornerRadius = _openButton.height/2.0f;
        @weakify(self)
        [_openButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            [self openRedPackage];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}
- (JSCountDownView *)countDownView{
    if (!_countDownView) {
        _countDownView = [[JSCountDownView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
    }
    return _countDownView;
}
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3];
    }
    return _topView;
}
- (UIView *)moneyView{
    if (!_moneyView) {
        _moneyView = [[UIView alloc]init];
        
    }
    return _moneyView;
}
- (UILabel *)topTitleLabel{
    if (!_topTitleLabel) {
        _topTitleLabel = [[UILabel alloc]init];
        _topTitleLabel.textColor = [UIColor whiteColor];
        _topTitleLabel.font = [UIFont systemFontOfSize:15];
        _topTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topTitleLabel;
}
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"js_mission_hongbao_back"];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
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
    // Do any additional setup after loading the view.
    self.title = @"红包专场";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.moneyView];
    [self.topView addSubview:self.topTitleLabel];
    
    [self.view addSubview:self.countDownView];
    
    [self.view addSubview:self.openPackView];
    [self.view addSubview:self.openButton];
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.titleLabel.size);
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.openButton.mas_bottom).offset(15);
        
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(100);
    }];
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topView);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(20);
    }];
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topView);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.topView).offset(-15);
    }];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(32);
        make.top.equalTo(self.topView.mas_bottom).offset(20);
    }];
    
    [self.openPackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.openPackView.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.countDownView.mas_bottom).offset(10);
    }];
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.openButton.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.openPackView.mas_bottom).offset(15);
    }];
    [JSNetworkManager requestCurrentActivityComplement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        if (isSuccess) {
            self.currentModel = [MTLJSONAdapter modelOfClass:[JSActivityModel class] fromJSONDictionary:contentDict error:nil];
            [self createMoneyViewWithMoney:self.currentModel.amount/100];
            self.topTitleLabel.text = [NSString stringWithFormat:@"本场红包数量：%@",@(self.currentModel.num)];
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            
            dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";
            NSDate *firDate = [dateFormatter dateFromString:self.currentModel.nextStartTime];
            
            [self.countDown countDownWithStratDate:[NSDate date] finishDate:firDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
                self.countDownView.hourLabel.text = [NSString stringWithFormat:@"%02ld",(long)hour];
                self.countDownView.minuteLabel.text = [NSString stringWithFormat:@"%02ld",(long)minute];
                self.countDownView.secondLabel.text = [NSString stringWithFormat:@"%02ld",(long)second];
                
                if (day == 0 && hour == 0 && minute == 0 & second == 0) {
                    [self initOpenViewIsEnable:YES];
                }
            }];
            
            [self initOpenViewIsEnable:self.currentModel.canGrab];
        }
    }];
    
    [JSNetworkManager requestOpenedRedPackageListComplement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        if (isSuccess) {
            NSArray *dataList = (NSArray *)contentDict;
            self.userList = [MTLJSONAdapter modelsOfClass:[JSActivityUserModel class] fromJSONArray:dataList error:nil];
            [self.collectionView reloadData];
        }
    }];
}
- (void)initOpenViewIsEnable:(BOOL)isEnable{
    if (isEnable) {
        self.openPackView.image = [UIImage imageNamed:@"js_mission_kai_highlight"];
        self.openButton.backgroundColor = [UIColor colorWithHexString:@"F7EC78"];
    }else{
        self.openPackView.image = [UIImage imageNamed:@"js_mission_kai_hui"];
        self.openButton.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
- (void)openRedPackage{
    [self showWaitingHUD];
    [JSNetworkManager requestOpenedPackageWithID:self.currentModel.grabRedPackageId Complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        [self hideWaitingHUD];
        if (isSuccess) {
            NSDictionary *openedDict = contentDict[@"reward"];
            NSError *error = nil;
            JSActivityOpenPackageModel *model = [MTLJSONAdapter modelOfClass:[JSActivityOpenPackageModel class] fromJSONDictionary:openedDict error:&error];
            [self showAutoDismissTextAlert:@(model.amount).stringValue];
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.countDown destoryTimer];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.userList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSOpenRedPackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSOpenRedPackCell" forIndexPath:indexPath];
    JSActivityUserModel *model = self.userList[indexPath.row];
    cell.model = model;
    return cell;
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

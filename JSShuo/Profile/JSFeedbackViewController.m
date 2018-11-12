//
//  JSFeedbackViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/12.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSFeedbackViewController.h"
#import "GGAssetsPickerViewController.h"
#import "JSNetworkManager+Login.h"

@class GGFeebackThirdCell,GGFeebackThirdCellImageView;
@interface GGFeebackSecondCell:UITableViewCell<YYTextViewDelegate>
//@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)YYTextView *contentTextView;
@property (nonatomic, strong)UILabel *numberAlertLabel;
@property (nonatomic, strong)UIView *backView;
@end
@implementation GGFeebackSecondCell


- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _backView;
}

- (UILabel *)numberAlertLabel{
    if (!_numberAlertLabel) {
        _numberAlertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
        _numberAlertLabel.font = [UIFont systemFontOfSize:15];
        _numberAlertLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _numberAlertLabel.textAlignment = NSTextAlignmentRight;
        _numberAlertLabel.text = @"0/1000";
        _numberAlertLabel.right = kScreenWidth-10;
        _numberAlertLabel.top = self.contentTextView.bottom;
    }
    return _numberAlertLabel;
}
- (YYTextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[YYTextView alloc]initWithFrame:CGRectMake(10,  5 , kScreenWidth-20, /*200*/120)];
        _contentTextView.scrollEnabled = YES;
        _contentTextView.placeholderFont = [UIFont systemFontOfSize:16];
        _contentTextView.placeholderTextColor = [UIColor colorWithHexString:@"999999"];
        _contentTextView.placeholderText = @"请填写您的意见";
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.textColor = [UIColor colorWithHexString:@"333333"];
        _contentTextView.textAlignment = NSTextAlignmentLeft;
        _contentTextView.delegate = self;
    }
    return _contentTextView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentTextView];
        [self.contentView addSubview:self.numberAlertLabel];
        [self.contentView addSubview:self.backView];
        self.backView.top = self.numberAlertLabel.bottom + 10;
    }
    return self;
}
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length >= 1000 && text.length > 0) {
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    
    return YES;
}
- (void)textViewDidChange:(YYTextView *)textView{
    self.numberAlertLabel.text = [NSString stringWithFormat:@"%@/1000",@(textView.text.length)];
}
@end

@protocol GGFeebackThirdCellDelegate <NSObject>
- (void)thirdCell:(GGFeebackThirdCell *)cell didSelectedAddView:(GGFeebackThirdCellImageView *)view withImageViews:(NSArray *)imageViews;
- (void)thirdCell:(GGFeebackThirdCell *)cell didSelectedDeleteView:(GGFeebackThirdCellImageView *)view withImageViews:(NSArray *)imageViews;

@end

@interface GGFeebackThirdCellImageView : UIView
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *deleteButton;
@property (nonatomic, strong)PHAsset *asset;
@property (nonatomic, copy) NSString *imagePath;
@end

@implementation GGFeebackThirdCellImageView
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"ggcj_addImage_feedback"];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"ggcj_feedback_close"] forState:UIControlStateNormal];
        _deleteButton.size = CGSizeMake(20, 20);
        _deleteButton.top = 0;
        _deleteButton.right = self.width;
        _deleteButton.hidden = YES;
    }
    return _deleteButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.deleteButton];
    }
    return self;
}
- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(640, 640);
    [GGPhotoLibrary requestImageForAsset:asset preferSize:size completion:^(UIImage *image, NSDictionary *info) {
        self.imageView.image = image;
        self.deleteButton.hidden = NO;
    }];
}
- (void)setImagePath:(NSString *)imagePath{
    _imagePath = imagePath;
    self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    self.deleteButton.hidden = NO;
}
@end


@interface GGFeebackThirdCell:UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)NSMutableArray *imageViews;
@property (nonatomic, strong)NSArray *assets;
@property (nonatomic, weak)id <GGFeebackThirdCellDelegate>delegate;
@property (nonatomic, strong)UIView *backView;
@end
@implementation GGFeebackThirdCell

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _backView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        NSString *title = @"您也可以截图把出现的BUG问题发给我们";
        
        _titleLabel.font = [UIFont systemFontOfSize:16];
        
        _titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _titleLabel.text = title;
        [_titleLabel sizeToFit];
        _titleLabel.left = 10;
        _titleLabel.top = 10;
    }
    return _titleLabel;
}
- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}
//- (NSMutableArray *)assets{
//    if (!_assets) {
//        _assets = [NSMutableArray array];
//    }
//    return _assets;
//}
- (void)updateImageWithAssets:(NSArray *)assets{
    //    [self.assets addObjectsFromArray:assets];
    _assets = assets;
    CGFloat width = (kScreenWidth- 10*5)/4.0f;
    for (int i=0; i<self.imageViews.count; i++) {
        GGFeebackThirdCellImageView *imageView = self.imageViews[i];
        imageView.left = 10+(width+10)*i;
        if (i<self.assets.count) {
            id objectAsset = self.assets[i];
            imageView.hidden = NO;
            if ([objectAsset isKindOfClass:[PHAsset class]]) {
                PHAsset *itemAsset = objectAsset;
                imageView.asset = itemAsset;
            }else if ([objectAsset isKindOfClass:[NSString class]]){
                NSString *imagePath = objectAsset;
                imageView.imagePath = imagePath;
            }
            
        }else if (i==self.assets.count){
            imageView.asset = nil;
            imageView.imagePath = nil;
            imageView.imageView.image = [UIImage imageNamed:@"ggcj_addImage_feedback"];
            imageView.hidden = NO;
            imageView.deleteButton.hidden = YES;
        }else{
            imageView.hidden = YES;
            imageView.asset = nil;
            imageView.imagePath = nil;
            imageView.imageView.image = [UIImage imageNamed:@"ggcj_addImage_feedback"];
        }
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        CGFloat width = (kScreenWidth- 10*5)/4.0f;
        CGFloat height = width;
        
        for (int i=0; i<3; i++) {
            GGFeebackThirdCellImageView *imageView = [[GGFeebackThirdCellImageView alloc]initWithFrame:CGRectMake(10+(width+10)*i, self.titleLabel.bottom+10, width, height)];
            if (i!=0) {
                imageView.hidden = YES;
            }
            imageView.imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageFromPicker:)];
            [imageView addGestureRecognizer:tap];
            [imageView.deleteButton bk_addEventHandler:^(UIButton *sender) {
                GGFeebackThirdCellImageView *superView = (GGFeebackThirdCellImageView *)sender.superview;
                if ([self.delegate respondsToSelector:@selector(thirdCell:didSelectedDeleteView:withImageViews:)]) {
                    [self.delegate thirdCell:self didSelectedDeleteView:superView withImageViews:self.imageViews];
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [self.imageViews addObject:imageView];
            [self.contentView addSubview:imageView];
            
            [self.contentView addSubview:self.backView];
            self.backView.top = self.titleLabel.bottom + 10 + height + 10;
        }
    }
    return self;
}
- (void)addImageFromPicker:(UITapGestureRecognizer *)tap{
    GGFeebackThirdCellImageView *tapView = (GGFeebackThirdCellImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(thirdCell:didSelectedAddView:withImageViews:)]) {
        [self.delegate thirdCell:self didSelectedAddView:tapView withImageViews:self.imageViews];
    }
    
}
@end



@interface JSFeedbackViewController ()<UITableViewDelegate,UITableViewDataSource,GGFeebackThirdCellDelegate,GGAssetPickerViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,strong)dispatch_group_t group;
@property (nonatomic,strong)dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableArray *currentAssets;
@end

@implementation JSFeedbackViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableFooterView = [self createFooterView];
//        [_tableView registerClass:[GGFeebackFirstCell class] forCellReuseIdentifier:@"GGFeebackFirstCell"];
        [_tableView registerClass:[GGFeebackSecondCell class] forCellReuseIdentifier:@"GGFeebackSecondCell"];
        [_tableView registerClass:[GGFeebackThirdCell class] forCellReuseIdentifier:@"GGFeebackThirdCell"];
//        [_tableView registerClass:[GGFeebackFourthCell class] forCellReuseIdentifier:@"GGFeebackFourthCell"];
        
    }
    return _tableView;
}
- (NSMutableArray *)currentAssets{
    if (!_currentAssets) {
        _currentAssets = [NSMutableArray array];
    }
    return _currentAssets;
}
- (UIView *)createFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"eeeeeee"];
    UIButton * loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutButton.frame = CGRectMake(0, 10, kScreenWidth-40, 40) ;
//    loginOutButton.frame = CGRectMake(kScreenWidth/2-80, 10, 160, 40) ;
    loginOutButton.centerX = footerView.centerX;
    [loginOutButton setTitle:@"提交" forState:UIControlStateNormal];
    loginOutButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [loginOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOutButton.backgroundColor = [UIColor colorWithHexString:@"F44336"];
    loginOutButton.clipsToBounds = YES;
    loginOutButton.layer.cornerRadius = 20;
    [loginOutButton bk_addEventHandler:^(id sender) {
        //提交
        [self reportFeedback];
    } forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:loginOutButton];
    return footerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"建议反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
//
    _group = dispatch_group_create();
    _queue = dispatch_queue_create("com.ggcj.feedback", DISPATCH_QUEUE_CONCURRENT);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        
        case 0:{
            GGFeebackSecondCell *secondCell = [tableView dequeueReusableCellWithIdentifier:@"GGFeebackSecondCell" forIndexPath:indexPath];
//            secondCell.delegate = self;
            cell = secondCell;
        }break;
        case 1:{
            GGFeebackThirdCell *thirdCell = [tableView dequeueReusableCellWithIdentifier:@"GGFeebackThirdCell" forIndexPath:indexPath];
            thirdCell.delegate = self;
            cell = thirdCell;
        }break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 10+/*200*/120+20+10+10-5;
            break;
        case 1:{
            CGFloat height = (kScreenWidth- 10*5)/4.0f;
            return 10+20+10+height+10+10;
        }break;
            
        default:
            break;
    }
    return 0;
}
#pragma mark - GGFeebackThirdCellDelegate
- (void)thirdCell:(GGFeebackThirdCell *)cell didSelectedDeleteView:(GGFeebackThirdCellImageView *)view withImageViews:(NSArray *)imageViews{
    if (view.asset) {
        [self.currentAssets removeObject:view.asset];
        GGFeebackThirdCell *cell = (GGFeebackThirdCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell updateImageWithAssets:self.currentAssets];
    }else if (view.imagePath){
        [self.currentAssets removeObject:view.imagePath];
        GGFeebackThirdCell *cell = (GGFeebackThirdCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell updateImageWithAssets:self.currentAssets];
    }
}
- (void)thirdCell:(GGFeebackThirdCell *)cell didSelectedAddView:(GGFeebackThirdCellImageView *)view withImageViews:(NSArray *)imageViews{
    
    if (!view.asset && !view.imagePath) {
        NSInteger max = 3-self.currentAssets.count;
        GGAssetsPickerViewController *picker = [[GGAssetsPickerViewController alloc] init];
        picker.allowTakePhoto = YES;
        picker.option = AssetMediaOptionImage;
        picker.maxAssetCount = max;
        picker.allowPreviewAndEdit = NO;
        picker.pickerDelegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
#pragma mark - GGAssetPickerViewControllerDelegate
- (void)picker:(GGAssetsPickerViewController *)picker didSelectAssets:(NSArray<PHAsset *> *)assetsPicked {
    @weakify(self)
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        if (assetsPicked.count > 0) {
            GGFeebackThirdCell *cell = (GGFeebackThirdCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
            [self.currentAssets addObjectsFromArray:assetsPicked];
            [cell updateImageWithAssets:self.currentAssets];
        }
    }];
}
- (void)picker:(GGAssetsPickerViewController *)picker didSelectImageAtPath:(NSString *)path {
    @weakify(self)
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        if ([path isNotBlank]) {
            GGFeebackThirdCell *cell = (GGFeebackThirdCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
            [self.currentAssets addObject:path];
            [cell updateImageWithAssets:self.currentAssets];
        }
    }];
    
}
- (void)reportFeedback{
    GGFeebackSecondCell *secondCell = (GGFeebackSecondCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    NSString *alertString = nil;
    if (secondCell.contentTextView.text.length <= 0) {
        alertString = @"请输入您的建议";
    }else if (secondCell.contentTextView.text.length > 1000){
        alertString = @"输入内容不能超过1000字";
    }
    if (alertString.length > 0 ) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:alertString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:cancelAction];
        
        [self.rt_navigationController presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    //x没处理图片，后期需要改
    [JSNetworkManager feedbackText:secondCell.contentTextView.text image:nil complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        if (isSuccess) {
            [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
        }
    }];
    
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

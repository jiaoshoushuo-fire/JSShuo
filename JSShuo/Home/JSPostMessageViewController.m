//
//  JSPostMessageViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2019/1/29.
//  Copyright © 2019年  乔中祥. All rights reserved.
//

#import "JSPostMessageViewController.h"
#import "GGAssetsPickerViewController.h"
#import "JSNetworkManager+Poster.h"
#import "JSPrivacyViewController.h"

@interface JSPostMessageFirstCell : UITableViewCell<YYTextViewDelegate>
@property (nonatomic, strong)YYTextView *contentTextView;
@property (nonatomic, strong)UITextField *titleTextField;
@property (nonatomic, strong)UIView *lineView;

@end

@implementation JSPostMessageFirstCell
- (YYTextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[YYTextView alloc]initWithFrame:CGRectMake(10,  5 , kScreenWidth-20, 200)];
        _contentTextView.scrollEnabled = YES;
        _contentTextView.placeholderFont = [UIFont systemFontOfSize:16];
        _contentTextView.placeholderTextColor = [UIColor colorWithHexString:@"999999"];
        _contentTextView.placeholderText = @"正文：必填，5~2000个中文汉字";
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.textColor = [UIColor colorWithHexString:@"545454"];
        _contentTextView.textAlignment = NSTextAlignmentLeft;
        _contentTextView.delegate = self;
    }
    return _contentTextView;
}
- (UITextField *)titleTextField{
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 30)];
        _titleTextField.font = [UIFont systemFontOfSize:18];
        _titleTextField.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _titleTextField.placeholder = @"标题：选填，不超过25字";
    }
    return _titleTextField;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
        
    }
    return _lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.contentTextView];
        [self.contentView addSubview:self.titleTextField];
        [self.contentView addSubview:self.lineView];
        
        [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(30);
            make.top.equalTo(self.contentView).offset(10);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.titleTextField.mas_bottom).offset(10);
        }];
        [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(200);
            make.top.equalTo(self.lineView.mas_bottom);
        }];
    }
    return self;
}
+ (CGFloat)heightForCell{
    return 250;
}

@end



@interface JSPostMessageImageView : UIView
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *deleteButton;
@property (nonatomic, strong)PHAsset *asset;
@property (nonatomic, copy) NSString *imagePath;
@end

@implementation JSPostMessageImageView
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"js_home_postImage_add"];
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
@class JSPostMessageSecondCell;
@protocol JSPostMessageSecondCellDelegate <NSObject>
- (void)thirdCell:(JSPostMessageSecondCell *)cell didSelectedAddView:(JSPostMessageImageView *)view withImageViews:(NSArray *)imageViews;
- (void)thirdCell:(JSPostMessageSecondCell *)cell didSelectedDeleteView:(JSPostMessageImageView *)view withImageViews:(NSArray *)imageViews;

@end

@interface JSPostMessageSecondCell : UITableViewCell
@property (nonatomic, strong)NSMutableArray *imageViews;
@property (nonatomic, strong)NSArray *assets;
@property (nonatomic, weak)id <JSPostMessageSecondCellDelegate>delegate;
@end

@implementation JSPostMessageSecondCell


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
        JSPostMessageImageView *imageView = self.imageViews[i];
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
            imageView.imageView.image = [UIImage imageNamed:@"js_home_postImage_add"];
            imageView.hidden = NO;
            imageView.deleteButton.hidden = YES;
        }else{
            imageView.hidden = YES;
            imageView.asset = nil;
            imageView.imagePath = nil;
            imageView.imageView.image = [UIImage imageNamed:@"js_home_postImage_add"];
        }
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat width = (kScreenWidth- 10*5)/4.0f;
        CGFloat height = width;
        
        for (int i=0; i<3; i++) {
            JSPostMessageImageView *imageView = [[JSPostMessageImageView alloc]initWithFrame:CGRectMake(10+(width+10)*i, 10, width, height)];
            if (i!=0) {
                imageView.hidden = YES;
            }
            imageView.imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageFromPicker:)];
            [imageView addGestureRecognizer:tap];
            [imageView.deleteButton bk_addEventHandler:^(UIButton *sender) {
                JSPostMessageImageView *superView = (JSPostMessageImageView *)sender.superview;
                if ([self.delegate respondsToSelector:@selector(thirdCell:didSelectedDeleteView:withImageViews:)]) {
                    [self.delegate thirdCell:self didSelectedDeleteView:superView withImageViews:self.imageViews];
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [self.imageViews addObject:imageView];
            [self.contentView addSubview:imageView];
            
        }
    }
    return self;
}
- (void)addImageFromPicker:(UITapGestureRecognizer *)tap{
    JSPostMessageImageView *tapView = (JSPostMessageImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(thirdCell:didSelectedAddView:withImageViews:)]) {
        [self.delegate thirdCell:self didSelectedAddView:tapView withImageViews:self.imageViews];
    }
    
}
+ (CGFloat)heightForCell{
    CGFloat width = (kScreenWidth- 10*5)/4.0f;
    return width + 20;
}
@end
@interface JSPostMessageThirdCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subLabel_1;
@property (nonatomic, strong)UILabel *subLabel_2;
@property (nonatomic, strong)UILabel *subLabel_3;
@property (nonatomic, strong)YYLabel *subLabel_4;
@property (nonatomic, strong)UIView *leftLine;
@property (nonatomic, strong)UIView *rightLine;
@end

@implementation JSPostMessageThirdCell

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"发贴须知";
        [_titleLabel sizeToFit];
        _titleLabel.textColor = [UIColor colorWithHexString:@"546D86"];
    }
    return _titleLabel;
}
- (UIView *)leftLine{
    if (!_leftLine) {
        _leftLine = [[UIView alloc]init];
        _leftLine.backgroundColor = [UIColor colorWithHexString:@"546D86"];
    }
    return _leftLine;
}
- (UIView *)rightLine{
    if (!_rightLine) {
        _rightLine = [[UIView alloc]init];
        _rightLine.backgroundColor = [UIColor colorWithHexString:@"546D86"];
    }
    return _rightLine;
}

//1、任何人都可以发贴，没有等级限制；
//2、多发有质量的帖子，严禁水贴，情节严重会封号哦；
//3、禁止发布与政治安全、色情、赌博有关的帖子，违规将不会通过审核。
//4、我已阅读用户协议与隐私条款
- (UILabel *)subLabel_1{
    if (!_subLabel_1) {
        _subLabel_1 = [[UILabel alloc]init];
        _subLabel_1.font = [UIFont systemFontOfSize:14];
        _subLabel_1.textColor = [UIColor colorWithHexString:@"545454"];
        _subLabel_1.numberOfLines = 0;
        _subLabel_1.text = @"1、任何人都可以发贴，没有等级限制；";
        CGSize size = [_subLabel_1 sizeThatFits:CGSizeMake(kScreenWidth-20, MAXFLOAT)];
        _subLabel_1.size = size;
        
    }
    return _subLabel_1;
}

- (UILabel *)subLabel_2{
    if (!_subLabel_2) {
        _subLabel_2 = [[UILabel alloc]init];
        _subLabel_2.font = [UIFont systemFontOfSize:14];
        _subLabel_2.textColor = [UIColor colorWithHexString:@"545454"];
        _subLabel_2.numberOfLines = 0;
        _subLabel_2.text = @"2、多发有质量的帖子，严禁水贴，情节严重会封号哦；";
        CGSize size = [_subLabel_2 sizeThatFits:CGSizeMake(kScreenWidth-20, MAXFLOAT)];
        _subLabel_2.size = size;
        
    }
    return _subLabel_2;
}

- (UILabel *)subLabel_3{
    if (!_subLabel_3) {
        _subLabel_3 = [[UILabel alloc]init];
        _subLabel_3.font = [UIFont systemFontOfSize:14];
        _subLabel_3.textColor = [UIColor colorWithHexString:@"545454"];
        _subLabel_3.numberOfLines = 0;
        _subLabel_3.text = @"3、禁止发布与政治安全、色情、赌博有关的帖子，违规将不会通过审核。";
        CGSize size = [_subLabel_3 sizeThatFits:CGSizeMake(kScreenWidth-20, MAXFLOAT)];
        _subLabel_3.size = size;
        
    }
    return _subLabel_3;
}

- (YYLabel *)subLabel_4 {
    if (!_subLabel_4) {
        _subLabel_4 = [[YYLabel alloc] init];
        _subLabel_4.displaysAsynchronously = YES;
        _subLabel_4.ignoreCommonProperties = YES;
        
        @weakify(self);
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setImage:[UIImage imageNamed:@"js_agree_selected"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"js_agree_selected"] forState:UIControlStateSelected];
        [selectButton sizeToFit];
        
        [selectButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            NSLog(@"agreem selectbutton tap");
        } forControlEvents:UIControlEventTouchUpInside];
        
        NSString *string_1 = @"我已阅读并同意";
        NSString *string_2 = @"《用户协议》";
        
        NSMutableAttributedString *textString = [self stringWithContent:selectButton string:string_1 highlightString:string_2];
        [textString setColor:[UIColor colorWithHexString:@"999999"] range:[textString.string rangeOfString:string_1]];
        [textString setColor:[UIColor colorWithHexString:@"E81E2D"] range:[textString.string rangeOfString:string_2]];
        textString.font = [UIFont systemFontOfSize:12];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAXFLOAT, 25) text:textString];
        [_subLabel_4 setTextLayout:layout];
        _subLabel_4.size = layout.textBoundingSize;
    }
    return _subLabel_4;
}

- (NSMutableAttributedString *)stringWithContent:(UIButton *)button string:(NSString *)string highlightString:(NSString *)highlightString{
    NSMutableAttributedString *reslutString = [[NSMutableAttributedString alloc]initWithString:@""];
    if (button) {
        NSMutableAttributedString *imageAttributeString = [NSMutableAttributedString attachmentStringWithContent:button contentMode:UIViewContentModeCenter attachmentSize:button.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
        [reslutString appendAttributedString:imageAttributeString];
        [reslutString appendString:@" "];
    }
    [reslutString appendString:string];
    [reslutString appendString:highlightString];
    
    
    [self setHighlightInfo:@{} withRange:[reslutString.string rangeOfString:highlightString] toText:reslutString];
    return reslutString;
}

- (void)setHighlightInfo:(NSDictionary*)info withRange:(NSRange)range toText:(NSMutableAttributedString *)text {
    if (range.length == 0 || text.length == 0) return;
    {
        NSString *str = text.string;
        unichar *chars = malloc(str.length * sizeof(unichar));
        if (!chars) return;
        [str getCharacters:chars range:NSMakeRange(0, str.length)];
        
        NSUInteger start = range.location, end = range.location + range.length;
        for (int i = 0; i < str.length; i++) {
            unichar c = chars[i];
            if (0xD800 <= c && c <= 0xDBFF) { // UTF16 lead surrogates
                if (start > i) start++;
                if (end > i) end++;
            }
        }
        free(chars);
        if (end <= start) return;
        range = NSMakeRange(start, end - start);
    }
    
    if (range.location >= text.length) return;
    if (range.location + range.length > text.length) return;
    
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 3;
    border.insets = UIEdgeInsetsMake(-2, -2, -2, -2);
    border.fillColor = [UIColor colorWithHexString:@"ebeef0"];
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setBackgroundBorder:border];
    highlight.userInfo = info;
    
    [text setTextHighlight:highlight range:range];
    [text setColor:[UIColor colorWithHexString:@"E81E2D"] range:range];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.leftLine];
        [self.contentView addSubview:self.rightLine];
        [self.contentView addSubview:self.subLabel_1];
        [self.contentView addSubview:self.subLabel_2];
        [self.contentView addSubview:self.subLabel_3];
        [self.contentView addSubview:self.subLabel_4];
        
        [self.subLabel_4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel_4.size);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.left.equalTo(self.contentView).offset(10);
        }];
        [self.subLabel_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel_3.size);
            make.bottom.equalTo(self.subLabel_4.mas_top);
            make.left.equalTo(self.contentView).offset(10);
        }];
        [self.subLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel_2.size);
            make.bottom.equalTo(self.subLabel_3.mas_top);
            make.left.equalTo(self.contentView).offset(10);
        }];
        [self.subLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel_1.size);
            make.bottom.equalTo(self.subLabel_2.mas_top);
            make.left.equalTo(self.contentView).offset(10);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel.size);
            make.bottom.equalTo(self.subLabel_1.mas_top).offset(-30);
            make.centerX.equalTo(self.contentView);
        }];
        [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.titleLabel.mas_left).offset(-26);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(1);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(26);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(1);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
    }
    return self;
}

+ (CGFloat)heightForCell{
    CGFloat height = (kScreenWidth- 10*5)/4.0f + 20;
    CGFloat height2 = 240;
    return kScreenHeight - IPHONE_NAVIGATIONBAR_HEIGHT - height - height2;
}

@end

@interface JSPostMessageViewController ()<UITableViewDelegate,UITableViewDataSource,JSPostMessageSecondCellDelegate,GGAssetPickerViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *currentAssets;

@property (nonatomic,strong)dispatch_group_t group;
@property (nonatomic,strong)dispatch_queue_t queue;

@end

@implementation JSPostMessageViewController
- (NSMutableArray *)currentAssets{
    if (!_currentAssets) {
        _currentAssets = [NSMutableArray array];
    }
    return _currentAssets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建帖子";
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"F44336"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_top_back"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(backAction:)];
    backButtonItem.tintColor = [UIColor colorWithIndex:4];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    _group = dispatch_group_create();
    _queue = dispatch_queue_create("com.jss.postmessage", DISPATCH_QUEUE_CONCURRENT);
    // Do any additional setup after loading the view.
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JSPostMessageFirstCell class] forCellReuseIdentifier:@"JSPostMessageFirstCell"];
        [_tableView registerClass:[JSPostMessageSecondCell class] forCellReuseIdentifier:@"JSPostMessageSecondCell"];
        [_tableView registerClass:[JSPostMessageThirdCell class] forCellReuseIdentifier:@"JSPostMessageThirdCell"];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}
//提交
- (void)rightBarButtonAction:(UIButton *)button{
    NSString *alertString = nil;
    JSPostMessageFirstCell *firstCell = (JSPostMessageFirstCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
//    JSPostMessageSecondCell *secondCell = (JSPostMessageSecondCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    
    if (firstCell.contentTextView.text.length < 5 || firstCell.contentTextView.text.length > 2000) {
        alertString = @"正文必填，5~2000个中文汉字！";
    }
    if (firstCell.titleTextField.text.length > 25) {
        alertString = @"标题不能超过25字！";
    }
    if (alertString.length > 0 ) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:alertString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:cancelAction];
        
        [self.rt_navigationController presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    NSMutableArray *images = [NSMutableArray array];
    
    for (id object in self.currentAssets) {
        dispatch_group_enter(self.group);
        __block UIImage *reslutImage = nil;
        if ([object isKindOfClass:[NSString class]]) {
            reslutImage = [UIImage imageWithContentsOfFile:(NSString *)object];
            
            NSData *data = [JSTool zipNSDataWithImage:reslutImage];
            UIImage *lastImage = [UIImage imageWithData:data];
            [images addObject:lastImage];
            
            dispatch_group_leave(self.group);
        }else if ([object isKindOfClass:[PHAsset class]]){
            PHAsset *asset = (PHAsset *)object;
            [GGPhotoLibrary requestImageForAsset:asset preferSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) completion:^(UIImage *image, NSDictionary *info) {
                NSData *data = [JSTool zipNSDataWithImage:image];
                UIImage *lastImage = [UIImage imageWithData:data];
                [images addObject:lastImage];
                dispatch_group_leave(self.group);
            }];
        }
    }
    dispatch_group_notify(self.group, self.queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWaitingHUD];
            [JSNetworkManager postPublishTitle:firstCell.titleTextField.text text:firstCell.contentTextView.text images:images complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
                [self hideWaitingHUD];
                if (isSuccess) {
                    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
                }
            }];
        });
    });
    
    
}
//返回
- (void)backAction:(UIBarButtonItem *)barButton{
    JSPostMessageFirstCell *firstCell = (JSPostMessageFirstCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (firstCell.titleTextField.text.length > 0 ||  firstCell.contentTextView.text.length > 0 || self.currentAssets.count > 0) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"帖子未发送，返回将删除此帖子，确定删除么？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *makeSureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:makeSureAction];
        
        [self.rt_navigationController presentViewController:alertVC animated:YES completion:nil];
    }else{
       [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        JSPostMessageFirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"JSPostMessageFirstCell" forIndexPath:indexPath];
        cell = firstCell;
    }else if (indexPath.row == 1){
        JSPostMessageSecondCell *secondCell = [tableView dequeueReusableCellWithIdentifier:@"JSPostMessageSecondCell" forIndexPath:indexPath];
        secondCell.delegate = self;
        cell = secondCell;
    }else if (indexPath.row == 2){
        JSPostMessageThirdCell *thirdCell = [tableView dequeueReusableCellWithIdentifier:@"JSPostMessageThirdCell" forIndexPath:indexPath];
        @weakify(self);
        thirdCell.subLabel_4.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            JSPrivacyViewController *privacyVC = [[JSPrivacyViewController alloc]initWithUrl:@"http://api.jiaoshoutt.com/v1/page/protocal/user"];
            privacyVC.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:privacyVC animated:YES complete:nil];
        };
        cell = thirdCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [JSPostMessageFirstCell heightForCell];
    }else if (indexPath.row == 1){
        return [JSPostMessageSecondCell heightForCell];
    }else if (indexPath.row == 2){
        return [JSPostMessageThirdCell heightForCell];
    }
    return 0;
}


#pragma mark - GGFeebackThirdCellDelegate
- (void)thirdCell:(JSPostMessageSecondCell *)cell didSelectedDeleteView:(JSPostMessageImageView *)view withImageViews:(NSArray *)imageViews{
    if (view.asset) {
        [self.currentAssets removeObject:view.asset];
        JSPostMessageSecondCell *cell = (JSPostMessageSecondCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell updateImageWithAssets:self.currentAssets];
    }else if (view.imagePath){
        [self.currentAssets removeObject:view.imagePath];
        JSPostMessageSecondCell *cell = (JSPostMessageSecondCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell updateImageWithAssets:self.currentAssets];
    }
}
- (void)thirdCell:(JSPostMessageSecondCell *)cell didSelectedAddView:(JSPostMessageImageView *)view withImageViews:(NSArray *)imageViews{
    
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
            JSPostMessageSecondCell *cell = (JSPostMessageSecondCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
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
            JSPostMessageSecondCell *cell = (JSPostMessageSecondCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
            [self.currentAssets addObject:path];
            [cell updateImageWithAssets:self.currentAssets];
        }
    }];
    
}

@end

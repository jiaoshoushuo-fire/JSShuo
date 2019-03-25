//
//  JSWithdrawViewController.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/13.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSWithdrawViewController.h"
#import "JSAdjustButton.h"
#import "JSNetworkManager+Login.h"
#import "JSWithdrawModel.h"
#import "JSWithdrawAlertView.h"
@interface JSWithdrawItemView:UIImageView
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, strong)JSWithdrawItemModel *itemModel;
@property (nonatomic, assign)BOOL isSelected;
@end

@implementation JSWithdrawItemView
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.textAlignment = NSTextAlignmentCenter;
        _subLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _subLabel.font = [UIFont systemFontOfSize:12];
    }
    return _subLabel;
}
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.image = [UIImage imageNamed:@"js_tixian_beijing2"];
        self.titleLabel.textColor = [UIColor redColor];
        self.subLabel.textColor = [UIColor redColor];
        self.layer.borderWidth = 0.0f;
    }else{
        self.image = nil;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.subLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.layer.borderWidth = 1.0f;
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [[UIColor colorWithHexString:@"999999"]CGColor];
        self.layer.borderWidth = 1.0f;
        self.userInteractionEnabled = YES;
        [self addSubview:self.titleLabel];
        [self addSubview:self.subLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(22);
            make.top.equalTo(self).offset(8);
        }];
        
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.height.mas_equalTo(17);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
    }
    return self;
}
- (void)setItemModel:(JSWithdrawItemModel *)itemModel{
    _itemModel = itemModel;
    self.titleLabel.text = [NSString stringWithFormat:@"%@元",@(itemModel.amount/100)];
    self.subLabel.text = [NSString stringWithFormat:@"售价%@零钱",@(itemModel.money/100)];
}
@end

@protocol JSWithdrawFirstCellDelegate <NSObject>
- (void)didSelectedAliPlay:(BOOL)isAlipay;
- (void)didSelectedShoppingButton;
@end

@interface JSWithdrawFirstCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel_1;
@property (nonatomic, strong)UILabel *moneyLabel;
@property (nonatomic, strong)JSAdjustButton *storeButton;
@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *titleLabel_2;
@property (nonatomic, strong)JSAdjustButton *aliplayButton;
@property (nonatomic, strong)JSAdjustButton *wechatPlayButton;

@property (nonatomic, weak)id <JSWithdrawFirstCellDelegate>delegate;
@end

@protocol JSWithdrawSecondCellDelegate <NSObject>

- (void)didSelectedItemModel:(JSWithdrawItemModel *)model;

@end

@interface JSWithdrawSecondCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel_3;
@property (nonatomic, strong)NSMutableArray *withDrawItems;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, strong)JSWithdrawModel *withDrawModel;

@property (nonatomic, strong)JSWithdrawItemModel *currentItemModel;

@property (nonatomic, weak)id<JSWithdrawSecondCellDelegate>delegate;
@end

@interface JSWithdrawThirdCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel_4;
@property (nonatomic, strong)UILabel *subLabel_1;
@property (nonatomic, strong)UILabel *subLabel_2;
@property (nonatomic, strong)UILabel *subLabel_3;
@property (nonatomic, strong)UILabel *subLabel_4;
@property (nonatomic, strong)UILabel *subLabel_5;
@end
@implementation JSWithdrawThirdCell

- (UILabel *)titleLabel_4{
    if (!_titleLabel_4) {
        _titleLabel_4 = [[UILabel alloc]init];
        _titleLabel_4.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel_4.font = [UIFont systemFontOfSize:16];
        _titleLabel_4.text = @"注意事项";
        [_titleLabel_4 sizeToFit];
    }
    return _titleLabel_4;
}

- (UILabel *)subLabel_1{
    if (!_subLabel_1) {
        _subLabel_1 = [[UILabel alloc]init];
        _subLabel_1.textColor = [UIColor colorWithHexString:@"666666"];
        _subLabel_1.font = [UIFont systemFontOfSize:16];
        NSString *text = @"1、提现需至少实名绑定微信或支付宝中的一个且已绑定手机；";
        
        
        _subLabel_1.text = text;
        _subLabel_1.numberOfLines = 0;
        
        CGFloat height = [_subLabel_1 sizeThatFits:CGSizeMake(kScreenWidth - 20, MAXFLOAT)].height;
        _subLabel_1.size = CGSizeMake(kScreenWidth - 20, height);
    }
    return _subLabel_1;
}
- (UILabel *)subLabel_2{
    if (!_subLabel_2) {
        _subLabel_2 = [[UILabel alloc]init];
        _subLabel_2.textColor = [UIColor colorWithHexString:@"666666"];
        _subLabel_2.font = [UIFont systemFontOfSize:16];
        NSString *text = @"2、支付宝/微信提现均需填写账户及真实姓名，到账时间为1-5个工作日，如遇高峰期可能会延时，请您耐心等待；";
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:text];
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"F44336"] range:[text rangeOfString:@"1-5个工作日"]];
        _subLabel_2.attributedText = attributeString;
        _subLabel_2.numberOfLines = 0;
        CGFloat height = [_subLabel_2 sizeThatFits:CGSizeMake(kScreenWidth - 20, MAXFLOAT)].height;
        _subLabel_2.size = CGSizeMake(kScreenWidth - 20, height);
        
    }
    return _subLabel_2;
}
- (UILabel *)subLabel_3{
    if (!_subLabel_3) {
        _subLabel_3 = [[UILabel alloc]init];
        _subLabel_3.textColor = [UIColor colorWithHexString:@"666666"];
        _subLabel_3.font = [UIFont systemFontOfSize:16];
        NSString *text = @"3、叫兽说不欢迎用户使用非正常途径包括但不限于手机模拟器，改号软件等第三方程序修改硬件参数等作弊手段参与活动。一经发现，叫兽说有权收回所有奖励；";
        
        _subLabel_3.text = text;
        _subLabel_3.numberOfLines = 0;
        
        CGFloat height = [_subLabel_3 sizeThatFits:CGSizeMake(kScreenWidth - 20, MAXFLOAT)].height;
        _subLabel_3.size = CGSizeMake(kScreenWidth - 20, height);
    }
    return _subLabel_3;
}
- (UILabel *)subLabel_4{
    if (!_subLabel_4) {
        _subLabel_4 = [[UILabel alloc]init];
        _subLabel_4.textColor = [UIColor colorWithHexString:@"666666"];
        _subLabel_4.font = [UIFont systemFontOfSize:16];
        NSString *text = @"4、提现结果会通过消息反馈给用户；";
        
        _subLabel_4.text = text;
        _subLabel_4.numberOfLines = 0;
        
        CGFloat height = [_subLabel_4 sizeThatFits:CGSizeMake(kScreenWidth - 20, MAXFLOAT)].height;
        _subLabel_4.size = CGSizeMake(kScreenWidth - 20, height);
    }
    return _subLabel_4;
}

- (UILabel *)subLabel_5{
    if (!_subLabel_5) {
        _subLabel_5 = [[UILabel alloc]init];
        _subLabel_5.textColor = [UIColor colorWithHexString:@"666666"];
        _subLabel_5.font = [UIFont systemFontOfSize:16];
        NSString *text = @"5、本活动与苹果公司无关。";
        
        _subLabel_5.text = text;
        _subLabel_5.numberOfLines = 0;
        
        CGFloat height = [_subLabel_5 sizeThatFits:CGSizeMake(kScreenWidth - 20, MAXFLOAT)].height;
        _subLabel_5.size = CGSizeMake(kScreenWidth - 20, height);
    }
    return _subLabel_5;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLabel_4];
        [self.contentView addSubview:self.subLabel_1];
        [self.contentView addSubview:self.subLabel_2];
        [self.contentView addSubview:self.subLabel_3];
        [self.contentView addSubview:self.subLabel_4];
        [self.contentView addSubview:self.subLabel_5];
        
        [self.titleLabel_4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel_4.size);
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        [self.subLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel_1.size);
            make.left.equalTo(self.contentView).offset(10);
            make.top.mas_equalTo(self.titleLabel_4.mas_bottom).offset(20);
        }];
        [self.subLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel_2.size);
            make.left.equalTo(self.contentView).offset(10);
            make.top.mas_equalTo(self.subLabel_1.mas_bottom).offset(5);
        }];
        [self.subLabel_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel_3.size);
            make.left.equalTo(self.contentView).offset(10);
            make.top.mas_equalTo(self.subLabel_2.mas_bottom).offset(5);
        }];
        [self.subLabel_4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel_4.size);
            make.left.equalTo(self.contentView).offset(10);
            make.top.mas_equalTo(self.subLabel_3.mas_bottom).offset(5);
        }];
        [self.subLabel_5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.subLabel_5.size);
            make.left.equalTo(self.contentView).offset(10);
            make.top.mas_equalTo(self.subLabel_4.mas_bottom).offset(5);
        }];
    }
    return self;
}
@end

@implementation JSWithdrawSecondCell
- (UILabel *)titleLabel_3{
    if (!_titleLabel_3) {
        _titleLabel_3 = [[UILabel alloc]init];
        _titleLabel_3.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel_3.font = [UIFont systemFontOfSize:16];
        _titleLabel_3.text = @"提现金额";
        [_titleLabel_3 sizeToFit];
    }
    return _titleLabel_3;
}

- (NSMutableArray *)withDrawItems{
    if (!_withDrawItems) {
        _withDrawItems = [NSMutableArray array];
    }
    return _withDrawItems;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"FEF2F1"];
    }
    return _bottomView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"F44336"];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor colorWithHexString:@"F44336"];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel_3];
        for (int i=0; i<7; i++) {
            JSWithdrawItemView *itemView = [[JSWithdrawItemView alloc]init];
            itemView.size = CGSizeMake(90, 60);
            itemView.hidden = YES;
            [self.contentView addSubview:itemView];
            [self.withDrawItems addObject:itemView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [itemView addGestureRecognizer:tap];
        }
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.titleLabel];
        [self.bottomView addSubview:self.contentLabel];
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    JSWithdrawItemView *itemView = (JSWithdrawItemView *)tap.view;
    for (JSWithdrawItemView *view in self.withDrawItems) {
        if (view == itemView) {
//            view.isSelected = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedItemModel:)]) {
                [self.delegate didSelectedItemModel:view.itemModel];
            }
        }else{
//            view.isSelected = NO;
        }
    }
}
- (void)setWithDrawModel:(JSWithdrawModel *)withDrawModel currentItemModel:(JSWithdrawItemModel *)currentItemModel{
    _withDrawModel = withDrawModel;
    _currentItemModel = currentItemModel;
    
    for (int i=0; i<withDrawModel.ruleList.count; i++) {
        JSWithdrawItemModel *itemModel = withDrawModel.ruleList[i];
        JSWithdrawItemView *itemView = self.withDrawItems[i];
        itemView.itemModel = itemModel;
        itemView.hidden = NO;
        
        if (currentItemModel) {
            if (currentItemModel.withdrawRuleId == itemModel.withdrawRuleId) {
                itemView.isSelected = YES;
            }else{
                itemView.isSelected = NO;
            }
            
        }else{
            if (i == 0) {
                itemView.isSelected = YES;
                _currentItemModel = itemModel;
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedItemModel:)]) {
                    [self.delegate didSelectedItemModel:itemView.itemModel];
                }
            }else{
                itemView.isSelected = NO;
            }
        }
        
    }
    self.titleLabel.text = self.currentItemModel.title;
    [self.titleLabel sizeToFit];
    
    self.contentLabel.text = self.currentItemModel.itemDescription;
    
    CGFloat height = [self.currentItemModel.itemDescription heightForFont:self.contentLabel.font width:kScreenWidth-40];
    self.contentLabel.size = CGSizeMake(kScreenWidth-40, height);
    
    [self setNeedsLayout];
}

+ (CGFloat)heightWithDrawModel:(JSWithdrawModel *)withDrawModel itemModel:(JSWithdrawItemModel *)itemModel{
    CGFloat height = 10;
    height += 20;
    NSInteger index = withDrawModel.ruleList.count%3 > 0 ? 1 : 0;
    CGFloat itemsHeight = (60 + 25)*((withDrawModel.ruleList.count/3)+index);
    height += itemsHeight;
    
    CGFloat contentHeight = [itemModel.itemDescription heightForFont:[UIFont systemFontOfSize:14] width:kScreenWidth-40];
    
    height +=15;
    height +=20;
    height +=10;
    height +=contentHeight;
    height +=15;
    height += 10;
    return height;
};
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel_3.left = 20;
    self.titleLabel_3.top = 10;
    
    CGFloat tap = (kScreenWidth -90*3-20*2)/2.0f;
    for (int i=0; i<self.withDrawItems.count; i++) {
        
        JSWithdrawItemView *itemView = self.withDrawItems[i];
        itemView.left = 20 + (90+tap)*(i%3);
        itemView.top = self.titleLabel_3.bottom + 10 + (60 + 25)*(i/3);
    }
    NSInteger index = self.withDrawModel.ruleList.count%3 > 0 ? 1 : 0;
    CGFloat bottomTap = self.titleLabel_3.bottom + 10 + (60 + 25)*((self.withDrawModel.ruleList.count/3)+index);
    
    self.bottomView.frame = CGRectMake(10, bottomTap, kScreenWidth-20, self.titleLabel.height + self.contentLabel.height + 15 + 10 + 15);
    
    self.titleLabel.left = 10;
    self.titleLabel.top = 15;
    
    self.contentLabel.left = 10;
    self.contentLabel.top = self.titleLabel.bottom + 10;
}

@end


@implementation JSWithdrawFirstCell

-(UILabel *)titleLabel_1{
    if (!_titleLabel_1) {
        _titleLabel_1 = [[UILabel alloc]init];
        _titleLabel_1.font = [UIFont systemFontOfSize:12];
        _titleLabel_1.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel_1.text = @"当前余额";
        [_titleLabel_1 sizeToFit];
    }
    return _titleLabel_1;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:17];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"3333333"];
        _moneyLabel.text = @"9999.99";
    }
    return _moneyLabel;
}
- (JSAdjustButton *)storeButton{
    if (!_storeButton) {
        _storeButton = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        [_storeButton setImage:[UIImage imageNamed:@"js_profile_chongzhi_shangcheng"] forState:UIControlStateNormal];
        _storeButton.position = JSImagePositionLeft;
        _storeButton.itemSpace = 10;
        [_storeButton setTitle:@"商城" forState:UIControlStateNormal];
        [_storeButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _storeButton.size = CGSizeMake(85, 30);
        _storeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _storeButton.clipsToBounds = YES;
        _storeButton.layer.cornerRadius = _storeButton.height/2.0f;
        _storeButton.backgroundColor = [UIColor whiteColor];
        _storeButton.layer.borderWidth = 1.0f;
        _storeButton.layer.borderColor = [[UIColor colorWithHexString:@"999999"]CGColor];
        _storeButton.hidden = YES;
        @weakify(self)
        [_storeButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedShoppingButton)]) {
                [self.delegate didSelectedShoppingButton];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _storeButton;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"ABABAB"];
        _contentLabel.font = [UIFont systemFontOfSize:10];
        _contentLabel.text = @"每在商城成功兑换物品一次将获得1次1元提现";
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (UILabel *)titleLabel_2{
    if (!_titleLabel_2) {
        _titleLabel_2 = [[UILabel alloc]init];
        _titleLabel_2.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel_2.font = [UIFont systemFontOfSize:16];
        _titleLabel_2.text = @"提现方式";
        [_titleLabel_2 sizeToFit];
    }
    return _titleLabel_2;
}
- (JSAdjustButton *)aliplayButton{
    if (!_aliplayButton) {
        _aliplayButton = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        [_aliplayButton setTitle:@"支付宝" forState:UIControlStateNormal];
        _aliplayButton.itemSpace = 10;
        _aliplayButton.position = JSImagePositionLeft;
        _aliplayButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_aliplayButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [_aliplayButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_aliplayButton setImage:[UIImage imageNamed:@"js_tixian_zhifubao"] forState:UIControlStateNormal];
        _aliplayButton.clipsToBounds = YES;
        _aliplayButton.layer.cornerRadius = 5;
        _aliplayButton.layer.borderWidth = 1.0;
        _aliplayButton.layer.borderColor = [[UIColor colorWithHexString:@"999999"]CGColor];
        [_aliplayButton setBackgroundImage:[UIImage imageNamed:@"js_tixian_beijing1"] forState:UIControlStateSelected];
        [_aliplayButton setBackgroundImage:nil forState:UIControlStateNormal];
        @weakify(self)
        [_aliplayButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            self.wechatPlayButton.selected = NO;
            self.aliplayButton.selected = YES;
            self.aliplayButton.layer.borderWidth = 0.0;
            self.wechatPlayButton.layer.borderWidth = 1.0;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedAliPlay:)]) {
                [self.delegate didSelectedAliPlay:YES];
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _aliplayButton;
}
- (JSAdjustButton *)wechatPlayButton{
    if (!_wechatPlayButton) {
        _wechatPlayButton = [JSAdjustButton buttonWithType:UIButtonTypeCustom];
        [_wechatPlayButton setTitle:@"微信" forState:UIControlStateNormal];
        _wechatPlayButton.itemSpace = 10;
        _wechatPlayButton.position = JSImagePositionLeft;
        _wechatPlayButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_wechatPlayButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [_wechatPlayButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_wechatPlayButton setImage:[UIImage imageNamed:@"js_tixian_wechat"] forState:UIControlStateNormal];
        [_wechatPlayButton setBackgroundImage:[UIImage imageNamed:@"js_tixian_beijing1"] forState:UIControlStateSelected];
        [_wechatPlayButton setBackgroundImage:nil forState:UIControlStateNormal];
        _wechatPlayButton.clipsToBounds = YES;
        _wechatPlayButton.layer.cornerRadius = 5;
        _wechatPlayButton.layer.borderWidth = 1.0;
        _wechatPlayButton.layer.borderColor = [[UIColor colorWithHexString:@"999999"]CGColor];
        
        @weakify(self)
        [_wechatPlayButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            self.wechatPlayButton.selected = YES;
            self.aliplayButton.selected = NO;
            self.aliplayButton.layer.borderWidth = 1.0;
            self.wechatPlayButton.layer.borderWidth = 0.0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedAliPlay:)]) {
                [self.delegate didSelectedAliPlay:NO];
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatPlayButton;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor  = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.titleLabel_1];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.storeButton];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.titleLabel_2];
        [self.bottomView addSubview:self.aliplayButton];
        [self.bottomView addSubview:self.wechatPlayButton];
        
        self.contentLabel.hidden = YES;
        
        [self.titleLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel_1.size);
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(20);
        }];
        [self.storeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.storeButton.size);
            make.top.mas_equalTo(self.titleLabel_1.mas_bottom);
            make.right.equalTo(self.contentView).offset(-20);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel_1.mas_left);
            make.right.mas_equalTo(self.storeButton.mas_left).offset(-20);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self.storeButton.mas_centerY);
            
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.contentLabel.size);
            make.right.mas_equalTo(self.storeButton.mas_right);
            make.top.mas_equalTo(self.storeButton.mas_bottom).offset(5);
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(45+20+10+10+10);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(5);
        }];
        
        [self.titleLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.titleLabel_2.size);
            make.top.equalTo(self.bottomView).offset(10);
            make.left.equalTo(self.bottomView).offset(20);
        }];
        
        [self.aliplayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView).offset(20);
            make.right.mas_equalTo(self.wechatPlayButton.mas_left).offset(-35);
            make.height.mas_equalTo(45);
            make.top.mas_equalTo(self.titleLabel_2.mas_bottom).offset(10);
            make.width.mas_equalTo(self.wechatPlayButton.mas_width);
            
        }];
        [self.wechatPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomView).offset(-20);
            make.left.mas_equalTo(self.aliplayButton.mas_right).offset(35);
            make.height.mas_equalTo(45);
            make.top.mas_equalTo(self.titleLabel_2.mas_bottom).offset(10);
            make.width.mas_equalTo(self.aliplayButton.mas_width);
        }];
        
        //默认选中支付宝
        self.wechatPlayButton.selected = NO;
        self.aliplayButton.selected = YES;
        self.aliplayButton.layer.borderWidth = 0.0;
        self.wechatPlayButton.layer.borderWidth = 1.0;
        
    }
    return self;
}
@end

@interface JSWithdrawViewController ()<UITableViewDelegate,UITableViewDataSource,JSWithdrawFirstCellDelegate,JSWithdrawSecondCellDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)JSWithdrawModel *withdrawModel;
@property (nonatomic, copy)NSString *currentMethod;
@property (nonatomic, strong)JSWithdrawItemModel *currentItemModel;
@end


@implementation JSWithdrawViewController

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.tableFooterView = [self footerView];
        [_tableview registerClass:[JSWithdrawFirstCell class] forCellReuseIdentifier:@"JSWithdrawFirstCell"];
        [_tableview registerClass:[JSWithdrawSecondCell class] forCellReuseIdentifier:@"JSWithdrawSecondCell"];
        [_tableview registerClass:[JSWithdrawThirdCell class] forCellReuseIdentifier:@"JSWithdrawThirdCell"];
        
    }
    return _tableview;
}
- (UIView *)footerView{
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.size = CGSizeMake(kScreenWidth, 55);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(kScreenWidth-20, 45);
    [button setTitle:@"立即提现" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"js_tixian_back_image"] forState:UIControlStateNormal];
    [footerView addSubview:button];
    button.top = 10;
    button.centerX = kScreenWidth/2.0f;
    
    [button addTarget:self action:@selector(getMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}
- (void)getMoneyAction:(UIButton *)button{
    if (self.currentItemModel && self.currentMethod) {
        [self showWaitingHUD];
        [JSNetworkManager queryUserInformationWitchComplement:^(BOOL isSuccess, JSProfileUserModel * _Nonnull userModel) {
            [self hideWaitingHUD];
            if (isSuccess) {
                if (userModel.bindStatus == 1) {//已绑定手机
                    [self withdrawProcessModel:userModel];
                }else{//未绑定手机 先弹绑定手机提示
                    [JSWithdrawAlertView showAlertViewWithSuperView:self.navigationController.view type:JSWithdrawAlertViewTypeBindIPhone isBind:NO handle:^(BOOL isSuccess, NSString * _Nonnull name, NSString * _Nonnull alipayAccount) {
                        if (isSuccess) {
                            [self withdrawProcessModel:userModel];
                        }
                    }];
                }
            }
        }];
//        [JSNetworkManager getMoneyWithMethod:self.currentMethod count:self.currentItemModel.amount complement:^(NSInteger code, NSString * _Nonnull message) {
//            [self hideWaitingHUD];
//            switch (code) {
//                case 0:{//提现成功
//                    [self showAutoDismissTextAlert:@"提现申请已提交，审核中"];
//                    [self performSelector:@selector(dismissSelfVC) withObject:nil afterDelay:2];
//                }break;
//                case 101:{//绑定手机号
//                    [JSWithdrawAlertView showAlertViewWithSuperView:self.navigationController.view type:JSWithdrawAlertViewTypeBindIPhone isBind:NO handle:^(BOOL isSuccess) {
//                        if (isSuccess) {
//                            [self getMoneyAction:nil];
//                        }
//                    }];
//
//                }break;
//                case 102:{//微信未绑定
//                    [JSWithdrawAlertView showAlertViewWithSuperView:self.navigationController.view type:JSWithdrawAlertViewTypeWechat isBind:NO handle:^(BOOL isSuccess) {
//                        if (isSuccess) {
//                            [self getMoneyAction:nil];
//                        }
//                    }];
//                }break;
//                case 103:{//支付宝未绑定
//                    [JSWithdrawAlertView showAlertViewWithSuperView:self.navigationController.view type:JSWithdrawAlertViewTypeAlipay isBind:NO handle:^(BOOL isSuccess) {
//                        if (isSuccess) {
//                            [self getMoneyAction:nil];
//                        }
//                    }];
//                }break;
//
//                default:
//                    [self showAutoDismissTextAlert:message];
//                    break;
//            }
//        }];

    }
}
- (void)withdrawProcessModel:(JSProfileUserModel *)userModel{
    if ([self.currentMethod isEqualToString:@"ALIPAY"]) {
        [JSWithdrawAlertView showAlertViewWithSuperView:self.navigationController.view type:JSWithdrawAlertViewTypeAlipay isBind:NO handle:^(BOOL isSuccess, NSString * _Nonnull name, NSString * _Nonnull alipayAccount) {
            if (isSuccess) {
                [self showWaitingHUD];
                [JSNetworkManager getMoneyWithMethod:self.currentMethod count:self.currentItemModel.amount realName:name alipayId:alipayAccount complement:^(NSInteger code, NSString * _Nonnull message) {
                    [self hideWaitingHUD];
                    if (code == 0) {
                        [self showAutoDismissTextAlert:@"提现申请已提交，审核中"];
                        [self performSelector:@selector(dismissSelfVC) withObject:nil afterDelay:2];
                    }else{
                        [self showAutoDismissTextAlert:message];
                    }
                }];
            }
        }];
        
    }else if ([self.currentMethod isEqualToString:@"WECHAT"]){
        [JSWithdrawAlertView showAlertViewWithSuperView:self.navigationController.view type:JSWithdrawAlertViewTypeWechat isBind:userModel.isWechatBind == 1 handle:^(BOOL isSuccess, NSString * _Nonnull name, NSString * _Nonnull alipayAccount) {
            if (isSuccess) {
                [self showWaitingHUD];
                [JSNetworkManager getMoneyWithMethod:self.currentMethod count:self.currentItemModel.amount realName:name alipayId:alipayAccount complement:^(NSInteger code, NSString * _Nonnull message) {
                    [self hideWaitingHUD];
                    if (code == 0) {
                        [self showAutoDismissTextAlert:@"提现申请已提交，审核中"];
                        [self performSelector:@selector(dismissSelfVC) withObject:nil afterDelay:2];
                    }else{
                        [self showAutoDismissTextAlert:message];
                    }
                }];
            }
        }];
    }
}

- (void)dismissSelfVC{
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentMethod = @"ALIPAY";
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [JSNetworkManager queryWithdrawInfoWithComplement:^(BOOL isSuccess, NSDictionary * _Nonnull dataDict) {
        if (isSuccess) {
            NSError *error = nil;
            self.withdrawModel = [MTLJSONAdapter modelOfClass:[JSWithdrawModel class] fromJSONDictionary:dataDict error:&error];
            [self.tableview reloadData];
        }
    }];
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
        JSWithdrawFirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"JSWithdrawFirstCell" forIndexPath:indexPath];
        firstCell.moneyLabel.text = [NSString stringWithFormat:@"%0.2f零钱", self.withdrawModel.amount/100.0f];
        firstCell.delegate = self;
        cell = firstCell;
    }else if (indexPath.row == 1){
        JSWithdrawSecondCell *secondCell = [tableView dequeueReusableCellWithIdentifier:@"JSWithdrawSecondCell" forIndexPath:indexPath];
        
        [secondCell setWithDrawModel:self.withdrawModel currentItemModel:self.currentItemModel];
        
        secondCell.delegate = self;
        cell = secondCell;
    }else if (indexPath.row == 2){
        JSWithdrawThirdCell *thirdCell = [tableView dequeueReusableCellWithIdentifier:@"JSWithdrawThirdCell" forIndexPath:indexPath];
        cell = thirdCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 180;
    }else if (indexPath.row == 1){
        return [JSWithdrawSecondCell heightWithDrawModel:self.withdrawModel itemModel:self.currentItemModel];
    }else if (indexPath.row == 2){
        return 310;
    }
    return 180;
}
#pragma mark - JSWithdrawFirstCellDelegate

- (void)didSelectedAliPlay:(BOOL)isAlipay{
    self.currentMethod = isAlipay ? @"ALIPAY":@"WECHAT";
}
- (void)didSelectedShoppingButton{
    [self showAutoDismissTextAlert:@"开发中、敬请期待"];
}
#pragma mark - JSWithdrawSecondCellDelegate
- (void)didSelectedItemModel:(JSWithdrawItemModel *)model{
    self.currentItemModel = model;
    [self.tableview reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
}


@end

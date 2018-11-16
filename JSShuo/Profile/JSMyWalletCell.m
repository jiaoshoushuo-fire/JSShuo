//
//  JSMyWalletCell.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/16.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMyWalletCell.h"
#import "JSAccountModel.h"

@interface JSMyWalletCell()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UILabel *goldLabel;
@property (nonatomic, strong)UILabel *timeSubLabel;
@property (nonatomic, strong)UIView *line;
@end

@implementation JSMyWalletCell

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titleLabel;
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    }
    return _line;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _contentLabel;
}
- (UILabel *)goldLabel{
    if (!_goldLabel) {
        _goldLabel = [[UILabel alloc]init];
        _goldLabel.font = [UIFont systemFontOfSize:15];
        _goldLabel.textColor = [UIColor redColor];
        _goldLabel.textAlignment = NSTextAlignmentRight;
    }
    return _goldLabel;
}
- (UILabel *)timeSubLabel{
    if (!_timeSubLabel) {
        _timeSubLabel = [[UILabel alloc]init];
        _timeSubLabel.font = [UIFont systemFontOfSize:12];
        _timeSubLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _timeSubLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeSubLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.goldLabel];
        [self.contentView addSubview:self.timeSubLabel];
        [self.contentView addSubview:self.line];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.height.mas_equalTo(20);
            make.top.equalTo(self.contentView).offset(5);
            make.width.mas_equalTo((kScreenWidth-20)/2.0f);
        }];
        [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.titleLabel.mas_top);
            make.width.mas_equalTo(self.titleLabel.mas_width);
        }];
        
        [self.timeSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.goldLabel.mas_right);
            make.top.mas_equalTo(self.goldLabel.mas_bottom).offset(8);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(120);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.top.mas_equalTo(self.timeSubLabel.mas_top);
            make.height.mas_equalTo(self.timeSubLabel.mas_height);
            make.right.mas_equalTo(self.timeSubLabel.mas_left);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)configDealModel:(JSDealModel *)model withType:(NSInteger)type{
    self.dealModel = model;
    
    if (type == 1) {//金币
        if (model.inOrOut == 1) {
            self.goldLabel.text = [NSString stringWithFormat:@"+%@金币",@(model.coin)];
            self.goldLabel.textColor = [UIColor redColor];
        }else if (model.inOrOut == 2){
            self.goldLabel.text = [NSString stringWithFormat:@"-%@金币",@(model.coin)];
            self.goldLabel.textColor = [UIColor greenColor];
        }
        
    }else if (type == 2){//零钱
        if (model.inOrOut == 1) {
            self.goldLabel.text = [NSString stringWithFormat:@"+%@元",@(model.money)];
            self.goldLabel.textColor = [UIColor redColor];
        }else if (model.inOrOut == 2){
            self.goldLabel.text = [NSString stringWithFormat:@"-%@元",@(model.money)];
            self.goldLabel.textColor = [UIColor greenColor];
        }
    }
}
- (void)setDealModel:(JSDealModel *)dealModel{
    _dealModel = dealModel;
    if (dealModel.type == 1) {
        self.titleLabel.text = @"签到";
    }else if (dealModel.type == 2){
        self.titleLabel.text = @"零钱兑换金币";
    }else if (dealModel.type == 3){
        self.titleLabel.text = @"金币兑换零钱";
    }else if (dealModel.type == 4){
        self.titleLabel.text = @"注册";
    }
    self.contentLabel.text = dealModel.dealdescription;
    self.timeSubLabel.text = dealModel.createTime;
    
}
- (void)testModel{
    self.titleLabel.text = @"金币转换零钱";
    self.contentLabel.text = @"昨日系统金币转换零钱";
    self.goldLabel.text = @"-18金币";
    self.timeSubLabel.text = @"2018-11-15 04:46:35";
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  JSMissionCell.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/22.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMissionCell.h"

@interface JSMissionSubCell()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *actionButton;
@property (nonatomic, strong)UILabel *complementedLabel;
@end
@implementation JSMissionSubCell

- (UILabel *)complementedLabel{
    if (!_complementedLabel) {
        _complementedLabel  = [[UILabel alloc]init];
        _complementedLabel.text = @"已完成";
        _complementedLabel.font = [UIFont systemFontOfSize:15];
        _complementedLabel.textAlignment = NSTextAlignmentCenter;
        _complementedLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _complementedLabel.size = CGSizeMake(60, 20);
        _complementedLabel.clipsToBounds = YES;
        _complementedLabel.layer.cornerRadius = 10;
        _complementedLabel.layer.borderColor = [[UIColor colorWithHexString:@"999999"]CGColor];
        _complementedLabel.layer.borderWidth = 0.5f;
    }
    return _complementedLabel;
}
- (UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setImage:[UIImage imageNamed:@"js_mission_finished"] forState:UIControlStateNormal];
        [_actionButton sizeToFit];
        @weakify(self)
        [_actionButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedGoFinishedCellWithModel:)]) {
                [self.delegate didSelectedGoFinishedCellWithModel:self.subModel];
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (void)createCGPath:(CGFloat)height{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithHexString:@"E9E9E9"] CGColor]];
    shapeLayer.lineWidth = 1.0f ;
    CGPathMoveToPoint(solidShapePath, NULL, 15, 0);
    
    CGPathAddLineToPoint(solidShapePath, NULL, 15,height);
    [shapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [self.layer addSublayer:shapeLayer];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.complementedLabel];
        [self.contentView addSubview:self.actionButton];
    }
    return self;
}
- (void)setSubModel:(JSMissSubModel *)subModel{
    _subModel = subModel;
    self.titleLabel.text = subModel.misDescription;
    if (![subModel.taskNo isEqualToString:@"T5"]) {
        if (subModel.isDone == 1) {//已完成
            self.complementedLabel.hidden = NO;
            self.actionButton.hidden = YES;
        }else{//未完成
            self.complementedLabel.hidden = YES;
            self.actionButton.hidden = NO;
        }
    }else{
        self.complementedLabel.hidden = YES;
        self.actionButton.hidden = YES;
    }
    [self setNeedsLayout];
}

+ (CGFloat)heightForString:(NSString *)text{
    CGFloat height = 20;
    CGFloat contentHeight = [text heightForFont:[UIFont systemFontOfSize:14] width:kScreenWidth-120];
    return height += contentHeight;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(kScreenWidth-120, MAXFLOAT)];
    self.titleLabel.size = size;
    self.titleLabel.left = 30;
    self.titleLabel.top = 10;
    
    self.complementedLabel.right = self.actionButton.right = kScreenWidth - 20;
    self.complementedLabel.centerY = self.actionButton.centerY = self.titleLabel.centerY;
    
    [self createCGPath:size.height+20];
}
@end

@interface JSMissionCell ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *hotImageView;
@property (nonatomic, strong)UIImageView *markImageView;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, strong)UIImageView *rowImageView;
@end

@implementation JSMissionCell
- (void)createCGPath{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithHexString:@"E9E9E9"] CGColor]];
    shapeLayer.lineWidth = 1.0f ;
    CGPathMoveToPoint(solidShapePath, NULL, 15, 0);
    CGPathAddLineToPoint(solidShapePath, NULL, 15,17.5);
    CGPathAddEllipseInRect(solidShapePath, nil, CGRectMake(7.50f,  17.50f, 15.0f, 15.0f));
    
    CGPathMoveToPoint(solidShapePath, NULL, 15, 32.5);
    CGPathAddLineToPoint(solidShapePath, NULL, 15,50);
    [shapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [self.layer addSublayer:shapeLayer];
}
- (UIImageView *)rowImageView{
    if (!_rowImageView) {
        _rowImageView = [[UIImageView alloc]init];
        _rowImageView.image = [UIImage imageNamed:@"js_mession_down"];
        [_rowImageView sizeToFit];
    }
    return _rowImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}
- (UIImageView *)hotImageView{
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc]init];
        _hotImageView.image = [UIImage imageNamed:@"js_mession_hot"];
        [_hotImageView sizeToFit];
    }
    return _hotImageView;
}
- (UIImageView *)markImageView{
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc]init];
    }
    return _markImageView;
}
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.textColor = [UIColor colorWithHexString:@"F44336"];
        _subLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCGPath];
        [self addSubview:self.titleLabel];
        [self addSubview:self.hotImageView];
        [self addSubview:self.markImageView];
        [self addSubview:self.subLabel];
        [self addSubview:self.rowImageView];
    }
    return self;
}
- (void)setModel:(JSMissionModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    [self.titleLabel sizeToFit];
    
    self.hotImageView.hidden = model.isHot == 1 ? NO : YES;
    self.subLabel.text = model.rewardDescription;
    [self.subLabel sizeToFit];
    
    if (model.rewardType == 1) {
        self.markImageView.image = [UIImage imageNamed:@"js_mession_hongbao"];
    }else if (model.rewardType == 2){
        self.markImageView.image = [UIImage imageNamed:@"js_mession_jinbi"];
    }

    self.rowImageView.image = model.isOpen ? [UIImage imageNamed:@"js_mession_up"]:[UIImage imageNamed:@"js_mession_down"];
    [self.markImageView sizeToFit];
    [self setNeedsLayout];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.left = 30;
    self.hotImageView.left = self.titleLabel.right + 10;
    
    self.rowImageView.right = self.width - 10;
    self.markImageView.right = self.rowImageView.left - 10;
    self.subLabel.right = self.markImageView.left - 10;
    
    self.titleLabel.centerY = self.hotImageView.centerY = self.markImageView.centerY = self.subLabel.centerY = self.rowImageView.centerY = self.height/2.0f;
    
}
- (void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    self.rowImageView.image = isOpen ? [UIImage imageNamed:@"js_mession_up"]:[UIImage imageNamed:@"js_mession_down"];
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

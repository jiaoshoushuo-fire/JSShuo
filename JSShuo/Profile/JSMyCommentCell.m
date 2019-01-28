//
//  JSMyCommentCell.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/19.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMyCommentCell.h"

@implementation JSMyCommentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId" : @"userId",
             @"commentId" : @"commentId",
             @"name" : @"name",
             @"portrait" : @"portrait",
             @"content" : @"content",
             @"createTime" : @"createTime",
             @"type":@"type",
             @"articleId":@"articleId"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"content"]){
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            return [value stringByURLDecode];
            //            return value;
        }];
    }
    return nil;
}

@end

@interface JSMyCommentCell ()
@property (nonatomic, strong)UIImageView *iconImage;
@property (nonatomic, strong)UILabel *nickName;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIButton *deleateButton;

@end

@implementation JSMyCommentCell

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
        _iconImage.clipsToBounds = YES;
        _iconImage.layer.cornerRadius = 20.0f;
    }
    return _iconImage;
}
- (UIButton *)deleateButton{
    if (!_deleateButton) {
        _deleateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleateButton.size = CGSizeMake(50, 20);
        _deleateButton.clipsToBounds = YES;
        _deleateButton.layer.cornerRadius = _deleateButton.height/2.0f;
        _deleateButton.layer.borderColor = [[UIColor redColor]CGColor];
        _deleateButton.layer.borderWidth = 0.5f;
        [_deleateButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _deleateButton.titleLabel.font = [UIFont systemFontOfSize:15];
        @weakify(self)
        [_deleateButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDeleateButton:)]) {
                [self.delegate didSelectedDeleateButton:self.model];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleateButton;
}
- (UILabel *)nickName{
    if (!_nickName) {
        _nickName = [[UILabel alloc]init];
        _nickName.font = [UIFont boldSystemFontOfSize:16];
        _nickName.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _nickName;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _timeLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"];
    }
    return _lineView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.nickName];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.deleateButton];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}
- (void)setModel:(JSMyCommentModel *)model{
    _model = model;
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.portrait] placeholder:nil];
    self.nickName.text = model.name;
    [self.nickName sizeToFit];
    
    self.timeLabel.text = model.createTime;
    [self.timeLabel sizeToFit];
    
    self.contentLabel.text = model.content;
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconImage.frame = CGRectMake(10, 10, 40, 40);
    self.nickName.top = self.iconImage.top;
    self.nickName.left = self.iconImage.right + 10;
    
    self.timeLabel.left = self.nickName.left;
    self.timeLabel.top = self.nickName.bottom + 5;
    
    self.deleateButton.right = kScreenWidth - 10;
    self.deleateButton.centerY = self.iconImage.centerY;
    
    CGFloat contentHieght = [self.contentLabel sizeThatFits:CGSizeMake(kScreenWidth - 70, MAXFLOAT)].height;
    self.contentLabel.frame = CGRectMake(self.nickName.left, self.iconImage.bottom + 10, kScreenWidth - 70, contentHieght);
    
    self.lineView.frame = CGRectMake(0, self.contentLabel.bottom + 10, kScreenWidth, 0.5f);
}

+ (CGFloat)heightForRowWithModel:(JSMyCommentModel *)model{
    CGFloat height = 10 + 40 + 10;
    CGFloat contentHeight = [model.content heightForFont:[UIFont systemFontOfSize:15] width:kScreenWidth - 70];
    height += contentHeight;
    height += 10;
    return height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  JSMessageCell.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/8.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSMessageCell.h"

@interface JSMessageCellDetailView : UIView
@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UIImageView *arrowImageView;

@end

@implementation JSMessageCellDetailView

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    }
    return _line;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = [UIColor colorWithHexString:@"C8C8C8"];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.text = @"查看详情";
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}
- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]init];
        _arrowImageView.backgroundColor = [UIColor redColor];
        _arrowImageView.userInteractionEnabled = YES;
    }
    return _arrowImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.line];
        [self addSubview:self.detailLabel];
        [self addSubview:self.arrowImageView];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(1.0f);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(self.detailLabel.size);
            make.centerY.equalTo(self);
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.size.mas_equalTo(CGSizeMake(8, 12));
            make.centerY.equalTo(self);
        }];
    }
    return self;
}
@end

@interface JSMessageCell()


@property (nonatomic, strong)UILabel *messageTitleLabel;
@property (nonatomic, strong)UILabel *messageContentLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIView *topLine;
@property (nonatomic, strong)JSMessageCellDetailView *detailView;
@property (nonatomic, strong)UIView *messageContentView;
@end

@implementation JSMessageCell

- (UIView *)messageContentView{
    if (!_messageContentView) {
        _messageContentView = [[UIView alloc]init];
        _messageContentView.backgroundColor = [UIColor whiteColor];
    }
    return _messageContentView;
}
- (UILabel *)messageTitleLabel{
    if (!_messageTitleLabel) {
        _messageTitleLabel = [[UILabel alloc]init];
        _messageTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        _messageTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _messageTitleLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithHexString:@"64A0E6"];
    }
    return _timeLabel;
}
- (UILabel *)messageContentLabel{
    if (!_messageContentLabel) {
        _messageContentLabel = [[UILabel alloc]init];
        _messageContentLabel.font = [UIFont systemFontOfSize:12];
        _messageContentLabel.numberOfLines = 0;
        _messageContentLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _messageContentLabel;
}
- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    }
    return _topLine;
}
- (JSMessageCellDetailView *)detailView{
    if (!_detailView) {
        _detailView = [[JSMessageCellDetailView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 35)];
    }
    return _detailView;
}
+ (CGFloat)heightWithModel:(JSMessageModel *)model{
    CGFloat height = 10;
    height += 5;
    height += 20;
    height += 5;
    
    height += 10;
    CGFloat contentHeight = [model.content heightForFont:[UIFont systemFontOfSize:12] width:kScreenWidth-20*2];
    
    height += contentHeight;
    height += 35;
    
    return height;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.messageContentView];
        [self.messageContentView addSubview:self.messageTitleLabel];
        [self.messageContentView addSubview:self.timeLabel];
        [self.messageContentView addSubview:self.messageContentLabel];
        [self.messageContentView addSubview:self.topLine];
        [self.messageContentView addSubview:self.detailView];
    }
    return self;
}
- (void)setMessageModel:(JSMessageModel *)messageModel{
    _messageModel = messageModel;
    self.messageTitleLabel.text = self.messageModel.type == 1 ? @"系统通知":@"系统公告";
    [self.messageTitleLabel sizeToFit];
    self.timeLabel.text = messageModel.createTime;
    [self.timeLabel sizeToFit];
    
    self.messageContentLabel.text = messageModel.content;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.messageContentView.left = self.messageContentView.top = 10;
    self.messageContentView.width = kScreenWidth-20;
    
    
    self.messageTitleLabel.left = 5;
    self.messageTitleLabel.top = 5;
    
    self.timeLabel.right = self.messageContentView.width - 5;
    self.timeLabel.centerY = self.messageTitleLabel.centerY;
    
    self.topLine.left = 0;
    self.topLine.width = self.messageContentView.width;
    self.topLine.top = self.messageTitleLabel.bottom + 5;
    self.topLine.height = 1;
    
    CGFloat contentHeight = [self.messageModel.content heightForFont:[UIFont systemFontOfSize:12] width:kScreenWidth-20*2];
    
    self.messageContentLabel.size = CGSizeMake(kScreenWidth-20*2, contentHeight);
    self.messageContentLabel.left = 10;
    self.messageContentLabel.top = self.topLine.bottom + 10;
    
    self.detailView.left = 0;
    self.detailView.top = self.messageContentLabel.bottom + 5;
    
    self.messageContentView.height = 5 + self.messageTitleLabel.height + 5 + 1 + 10 + contentHeight + 5+ self.detailView.height;
    
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

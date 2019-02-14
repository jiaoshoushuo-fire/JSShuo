//
//  JSCircleMyTableViewCell.m
//  JSShuo
//
//  Created by li que on 2019/2/14.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import "JSCircleMyTableViewCell.h"

@implementation JSCircleMyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setModel:(JSCircleListModel *)model {
    _model = model;
    if (model.images.count > 0) { // 有图
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.stateLabel];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(120, 120/16.0*9));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(8);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(self.iconImageView.height);
            make.right.mas_equalTo(-15);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView);
            make.width.mas_equalTo(ScreenWidth/2-15);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(8);
            make.height.mas_equalTo(20);
        }];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.timeLabel);
            make.width.mas_equalTo(ScreenWidth/2-15);
            make.height.mas_equalTo(20);
        }];
        self.titleLabel.text = model.title.length > 0 ? model.title : @"无标题";
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:@"placeHolder_16_9"]];
        self.timeLabel.text = model.createTimeDesc;
        // 状态标题
        self.stateLabel.text = model.auditStatusDesc;
        if (model.auditStatus.intValue == 1) { // 审核中
            self.stateLabel.textColor = [UIColor colorWithHexString:@"546D86"];
        } else if (model.auditStatus.intValue == 2) { // 通过审核
            self.stateLabel.textColor = [UIColor colorWithHexString:@"9B9B9B"];
        } else if (model.auditStatus.intValue == 3) { // 未通过审核
            self.stateLabel.textColor = [UIColor colorWithHexString:@"F44336"];
        } else {
            self.stateLabel.textColor = [UIColor blackColor];
        }
    } else { // 没有图片
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.stateLabel];
//        self.titleLabel.preferredMaxLayoutWidth = ScreenWidth-30;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(-15);
            make.height.mas_offset(25);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(ScreenWidth/2-15);
        }];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(self.timeLabel);
            make.width.mas_equalTo(ScreenWidth/2-15);
        }];
        self.titleLabel.text = model.title.length > 0 ? model.title : @"无标题";
        self.timeLabel.text = model.createTimeDesc;
        // 状态标题
        self.stateLabel.text = model.auditStatusDesc;
        if (model.auditStatus.intValue == 1) { // 审核中
            self.stateLabel.textColor = [UIColor colorWithHexString:@"546D86"];
        } else if (model.auditStatus.intValue == 2) { // 通过审核
            self.stateLabel.textColor = [UIColor colorWithHexString:@"9B9B9B"];
        } else if (model.auditStatus.intValue == 3) { // 未通过审核
            self.stateLabel.textColor = [UIColor colorWithHexString:@"F44336"];
        } else {
            self.stateLabel.textColor = [UIColor blackColor];
        }
    }
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth-30, 1));
    }];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
    }
    return _lineView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _stateLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor colorWithHexString:@"545454"];
    }
    return _timeLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0D0D0D"];
    }
    return _titleLabel;
}


@end

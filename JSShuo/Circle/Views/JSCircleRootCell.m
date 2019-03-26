//
//  JSCircleRootCell.m
//  JSShuo
//
//  Created by  乔中祥 on 2019/3/25.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import "JSCircleRootCell.h"

@interface JSCircleRootCell ()
@property (nonatomic, strong)UIButton *circlePersonalButton;
@end

@implementation JSCircleRootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.circlePersonalButton];
        [self.circlePersonalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.circlePersonalButton.size);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(10);
        }];
    }
    return self;
}
- (UIButton *)circlePersonalButton{
    if (!_circlePersonalButton) {
        _circlePersonalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _circlePersonalButton.size = CGSizeMake(30, 30);
        [_circlePersonalButton setImage:[UIImage imageNamed:@"Icon_dropdown_blue"] forState:UIControlStateNormal];
        [_circlePersonalButton addTarget:self action:@selector(personalAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _circlePersonalButton;
}
- (void)personalAction:(UIButton *)button{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"不感兴趣" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.noInterestBlock) {
            self.noInterestBlock();
        }
    }];
    NSString *string = [NSString stringWithFormat:@"屏蔽作者：%@",self.model.nickname];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.shieldAuthor) {
            self.shieldAuthor();
        }
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self.viewController presentViewController:alertVC animated:YES completion:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

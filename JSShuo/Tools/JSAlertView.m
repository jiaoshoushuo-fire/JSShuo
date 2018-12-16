//
//  JSAlertView.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/12/4.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAlertView.h"
#import "UIImage+Extension.h"


@interface JSAlertView()
@property (nonatomic, strong)UIImageView *contentView;
@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)JSMissionRewardModel *rewardModel;
@property (nonatomic, strong)UIButton *actionButton;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, assign)JSALertType alertType;
@property (nonatomic, strong)UIImageView *goldImageView;

@property (nonatomic, copy)void(^handleBlock)(void);
@end

@implementation JSAlertView


- (UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:16];
        @weakify(self)
        [_actionButton bk_addEventHandler:^(id sender) {
            @strongify(self)
            
            [self dismissAlertView];
            if (self.handleBlock) {
                self.handleBlock();
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}
- (UIImageView *)goldImageView{
    if (!_goldImageView) {
        _goldImageView = [[UIImageView alloc]init];
        _goldImageView.image = [UIImage imageNamed:@"js_mession_gold_icon"];
        _goldImageView.size = CGSizeMake(280, 256);
    }
    return _goldImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"FFC600"];
        _titleLabel.font = [UIFont systemFontOfSize:29];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
//FF653A
- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.font = [UIFont systemFontOfSize:14];
        _subLabel.textColor = [UIColor colorWithHexString:@"FF653A"];
        _subLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subLabel;
}
- (UIImageView *)contentView{
    if (!_contentView) {
        _contentView = [[UIImageView alloc]init];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"js_alert_cancel"] forState:UIControlStateNormal];
        _cancelButton.size = CGSizeMake(40, 40);
        [_cancelButton addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSString *)url{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cancelButton];
        [self addSubview:self.contentView];
        
        // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        
        // 2.恢复默认设置
        [filter setDefaults];
        
        // 3. 给过滤器添加数据
        NSString *dataString = url;
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        // 注意，这里的value必须是NSData类型
        [filter setValue:data forKeyPath:@"inputMessage"];
        
        // 4. 生成二维码
        CIImage *outputImage = [filter outputImage];
        
        // 5. 显示二维码
        self.contentView.image = [UIImage creatNonInterpolatedUIImageFormCIImage:outputImage withSize:250];
        self.contentView.size = CGSizeMake(250, 250);
        
        
        self.cancelButton.center = CGPointMake(self.width/2.0f, self.height/2.0 + self.contentView.height/2.0f + 40);
        
        self.contentView.center = CGPointMake(self.width/2.0f, self.height/2.0f);
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame withType:(JSALertType)alertType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [self addSubview:self.cancelButton];
        _alertType = alertType;
        switch (alertType) {
            case JSALertTypeFirstLoginIn:{
                self.contentView.image = [UIImage imageNamed:@"js_alert_firstLogin"];
                self.contentView.size = CGSizeMake(280, 295);
                [self.contentView addSubview:self.titleLabel];
                self.titleLabel.top = 52;
                self.titleLabel.size = CGSizeMake(93, 52);
                [self.contentView addSubview:self.subLabel];
                
                self.subLabel.top = 172;
                self.subLabel.size = CGSizeMake(178, 22);
                
                [self.contentView addSubview:self.actionButton];
                
                self.actionButton.size = CGSizeMake(93, 26);
                self.actionButton.bottom = self.contentView.height - 18;
                [self.actionButton setTitle:@"立即领取" forState:UIControlStateNormal];
                
                self.cancelButton.center = CGPointMake(self.width/2.0f, self.height/2.0 + self.contentView.height/2.0f + 40);
                
                self.contentView.center = CGPointMake(self.width/2.0f, self.height/2.0f);
                self.titleLabel.centerX = self.subLabel.centerX = self.actionButton.centerX = self.contentView.width/2.0f;
            }break;
            case JSALertTypeSignIn:{
                
                self.contentView.image = [UIImage imageNamed:@"js_alert_signin"];
                self.contentView.size = CGSizeMake(280, 328);
                //新用户注册最高可获得 188元 超大红包
                [self.contentView addSubview:self.subLabel];
                
                self.subLabel.numberOfLines = 2;
                self.subLabel.textColor = [UIColor whiteColor];
                self.subLabel.font = [UIFont systemFontOfSize:16];
                NSString *countString = @"188元";
                NSString *alertString = [NSString stringWithFormat:@"新用户注册最高可获得 %@ 超大红包",countString];
                
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:alertString];
                [AttributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:20.0]
                                      range:[alertString rangeOfString:countString]];
                
                self.subLabel.attributedText = AttributedStr;
                
                
                self.subLabel.size = CGSizeMake(158, 68);
                self.subLabel.bottom = self.contentView.height - 100;
                
                [self.contentView addSubview:self.actionButton];
                
                //
                self.actionButton.size = CGSizeMake(119, 36);
                self.actionButton.bottom = self.contentView.height - 64;
                [self.actionButton setTitle:@"立即注册" forState:UIControlStateNormal];
                
                self.cancelButton.center = CGPointMake(self.width/2.0f, self.height/2.0 + self.contentView.height/2.0f + 40);
                
                self.contentView.center = CGPointMake(self.width/2.0f, self.height/2.0f);
                self.titleLabel.centerX = self.subLabel.centerX = self.actionButton.centerX = self.contentView.width/2.0f;
                
            }break;
            case JSALertTypeGold:{
                self.contentView.size = CGSizeMake(280, 326);
                [self.contentView addSubview:self.goldImageView];
                self.subLabel.font = [UIFont systemFontOfSize:18];
                self.subLabel.textAlignment = NSTextAlignmentCenter;
                self.subLabel.textColor = [UIColor whiteColor];
                
                self.subLabel.size = CGSizeMake(200, 20);
                
                [self.actionButton setTitle:@"点击领取" forState:UIControlStateNormal];
                [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.actionButton.titleLabel.font = [UIFont systemFontOfSize:15];
                self.actionButton.backgroundColor = [UIColor colorWithHexString:@"FBD207"];
                
                self.actionButton.size = CGSizeMake(150, 30);
                self.actionButton.clipsToBounds = YES;
                self.actionButton.layer.cornerRadius = self.actionButton.height/2.0f;
                [self.contentView addSubview:self.subLabel];
                [self.contentView addSubview:self.actionButton];
                self.goldImageView.top = 0;
                self.subLabel.top = self.goldImageView.bottom + 10 ;
                self.actionButton.top = self.subLabel.bottom + 10 ;
                
                
                self.cancelButton.center = CGPointMake(self.width/2.0f, self.height/2.0 + self.contentView.height/2.0f + 40);
                
                self.contentView.center = CGPointMake(self.width/2.0f, self.height/2.0f);
                self.subLabel.centerX = self.goldImageView.centerX = self.actionButton.centerX = self.contentView.width/2.0f;
                
            }break;
                
            default:
                break;
        }
    }
    return self;
}
- (void)setRewardModel:(JSMissionRewardModel *)rewardModel{
    _rewardModel = rewardModel;
    switch (self.alertType) {
        case JSALertTypeFirstLoginIn:{
            NSString *typeString = rewardModel.amountType == 1 ? @"金币":@"元";
            NSString *countString = [NSString stringWithFormat:@"%.02f",rewardModel.amount/100.0f];
            self.titleLabel.text = [NSString stringWithFormat:@"%@%@",countString,typeString];
            self.subLabel.text = [NSString stringWithFormat:@"恭喜你获得%@红包",self.titleLabel.text];
        }break;
        case JSALertTypeSignIn:{
            
        }break;
        case JSALertTypeGold:{
            NSString *typeString = rewardModel.amountType == 1 ? @"金币":@"元";
            NSString *countString = [NSString stringWithFormat:@"%.02f",rewardModel.amount/100.0f];
            self.subLabel.text = [NSString stringWithFormat:@"获得%@%@",countString,typeString];
        }break;
            
        default:
            break;
    }
    
}
+ (void)showAlertViewWithType:(JSALertType)alertType rewardModel:(JSMissionRewardModel *)model superView:(UIView *)superView handle:(void(^)(void)) handle{
    JSAlertView *alertView = [[JSAlertView alloc]initWithFrame:superView.bounds withType:alertType];
    alertView.rewardModel = model;
    alertView.handleBlock = handle;
    [superView addSubview:alertView];
}
+ (void)showCIQRCodeImageWithUrl:(NSString *)url superView:(UIView *)superView{
    JSAlertView *alertView = [[JSAlertView alloc]initWithFrame:superView.bounds withUrl:url];
    [superView addSubview:alertView];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        [self addSubview:self.contentView];
        self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.contentView.transform =
                             CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                              animations:^{
                                                  self.contentView.transform = CGAffineTransformIdentity;
                                              }];
                         }];
    }
}

- (void)dismissAlertView{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    anim.toValue = @(0.0f);
    anim.duration = 0.15;
    anim.removedOnCompletion = YES;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self removeFromSuperview];
    };
    [self.contentView pop_addAnimation:anim forKey:@"alpha"];
}
@end

//
//  JSSearchTopNavView.h
//  JSShuo
//
//  Created by li que on 2018/11/15.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol sendKeywordDelegate <NSObject>

- (void) passKeyword:(NSString *)keyword;

@end

@interface JSSearchTopNavView : UIView<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIView *searchContentView;
@property (nonatomic,strong) UIImageView *mirrorImgView;
@property (nonatomic,strong) UITextField *searchTextField;
@property (nonatomic,strong) UIButton *cancleBtn;

@property (nonatomic,weak) id<sendKeywordDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

//
//  JSDetailBottomSendCommentView.h
//  JSShuo
//
//  Created by li que on 2018/11/20.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface JSDetailBottomSendCommentView : UIView <UITextFieldDelegate>

@property (nonatomic,strong) UIView *sendCommentContentView;
@property (nonatomic,strong) UIImageView *editImgView;
//@property (nonatomic,strong) UITextField *sendCommentTextFiled;
@property (nonatomic,strong) UILabel *sendCommentLabel;
@property (nonatomic,strong) UIImageView *expressionImgView;

@property (nonatomic,strong) UIButton *chatBtn;
@property (nonatomic,strong) UILabel *commentNum;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) UILabel *praiseNum;
@property (nonatomic,strong) UIButton *collectionBtn;
@property (nonatomic,strong) UIButton *shareBtn;


@end

NS_ASSUME_NONNULL_END

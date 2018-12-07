//
//  JSBottomPopSendCommentView.h
//  JSShuo
//
//  Created by li que on 2018/11/27.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSBottomPopSendCommentView : UIView

+ (void) showInputBarWithView:(UIView *)superView articleId:(NSString *)articleID complement:(void(^)(NSDictionary *comment))complement;

@end

NS_ASSUME_NONNULL_END

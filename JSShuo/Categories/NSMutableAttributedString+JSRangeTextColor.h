//
//  NSMutableAttributedString+JSRangeTextColor.h
//  JSShuo
//
//  Created by li que on 2018/11/24.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (JSRangeTextColor)

+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color ;

@end

NS_ASSUME_NONNULL_END

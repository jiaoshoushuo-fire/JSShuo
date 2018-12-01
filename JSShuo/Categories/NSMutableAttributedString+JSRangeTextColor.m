//
//  NSMutableAttributedString+JSRangeTextColor.m
//  JSShuo
//
//  Created by li que on 2018/11/24.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "NSMutableAttributedString+JSRangeTextColor.h"

@implementation NSMutableAttributedString (JSRangeTextColor)

#pragma mark - 富文本设置部分字体颜色

+ (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color {
    
    NSRange hightlightTextRange = [text rangeOfString:rangeText];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    if (hightlightTextRange.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:hightlightTextRange];
        return attributeStr;
    } else {
        return [rangeText copy];
    }
}

@end

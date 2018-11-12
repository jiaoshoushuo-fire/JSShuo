//
//  NSString+Path.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/9.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

- (NSString *)cachePath{
    NSString *fileName = [self lastPathComponent];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:fileName];
}

- (NSString *)documentPath{
    NSString *fileName = [self lastPathComponent];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:fileName];
    
}

- (NSString *)tmpPath{
    NSString *fileName = [self lastPathComponent];
    NSString *path = NSTemporaryDirectory();
    return [path stringByAppendingPathComponent:fileName];
}

- (NSAttributedString *)attributedStringWithFont:(UIFont *)font
                                           color:(UIColor *)color
                                     lineSpacing:(CGFloat)lineSpacing
                                       alignment:(NSTextAlignment)alignment {
    NSString *text = [self stringByTrim];
    if (![text isNotBlank]) return nil;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    NSUInteger textLength = [text length];
    
    //字体
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, textLength)];
    //颜色
    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, textLength)];
    //行距
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    if (lineSpacing != 0) {
        style.lineSpacing = lineSpacing;
    }
    style.alignment = alignment;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, textLength)];
    
    return attributedText;
}


@end

//
//  NSString+Path.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/9.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Path)
- (NSString *)cachePath;

- (NSString *)documentPath;

- (NSString *)tmpPath;

- (NSAttributedString *)attributedStringWithFont:(UIFont *)font
                                           color:(UIColor *)color
                                     lineSpacing:(CGFloat)lineSpacing
                                       alignment:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END

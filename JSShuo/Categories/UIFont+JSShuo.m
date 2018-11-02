//
//  UIFont+JSShuo.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "UIFont+JSShuo.h"

@implementation UIFont (JSShuo)

+ (instancetype)fontWithIndex:(NSInteger)index{
    UIFont *font = [UIFont systemFontOfSize:15];
    switch (index) {
        case 1:
            font = [UIFont systemFontOfSize:18];
            break;
        case 2:
            font = [UIFont systemFontOfSize:16];
            break;
        case 3:
            font = [UIFont systemFontOfSize:15];
            break;
        case 4:
            font = [UIFont systemFontOfSize:14];
            break;
        case 5:
            font = [UIFont systemFontOfSize:13];
            break;
        case 6:
            font = [UIFont systemFontOfSize:12];
            break;
        case 7:
            font = [UIFont systemFontOfSize:11];
            break;
        case 8:
            font = [UIFont systemFontOfSize:10];
            break;
            
        default:
            break;
    }
    return font;
}
@end

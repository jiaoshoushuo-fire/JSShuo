//
//  UIColor+JSShuo.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "UIColor+JSShuo.h"

@implementation UIColor (JSShuo)

+ (instancetype)colorWithIndex:(NSInteger)index {
    
    UIColor *color = [UIColor whiteColor];
    switch (index) {
        case 1:
            color = [UIColor colorWithHexString:@"333333"];
            break;
        case 2:
            color = [UIColor colorWithHexString:@"999999"];
            break;
        case 3:
            color = [UIColor colorWithHexString:@"aaaaaa"];
            break;
        case 4:
            color = [UIColor colorWithHexString:@"00bf8f"];
            break;
        case 5:
            color = [UIColor colorWithHexString:@"6681c0"];
            break;
        case 6:
            color = [UIColor colorWithHexString:@"342c47"];
            break;
        case 7:
            color = [UIColor colorWithHexString:@"fe5f4a"];
            break;
        case 8:
            color = [UIColor colorWithHexString:@"f2f4f4"];
            break;
        case 9:
            color = [UIColor colorWithHexString:@"e3e3e3"];
            break;
        case 10:
            color = [UIColor colorWithHexString:@"e6eaea"]; // 无图片 默认颜色
            break;
        case 11:
            color = [UIColor colorWithHexString:@"ff9600"]; // 无图片 默认颜色
            break;
        case 100:
            color = [UIColor colorWithHexString:@"26d6c8"]; // 原1.x版本themeColorValue11
            break;
        case 101:
            color = [UIColor colorWithHexString:@"fa8c14"]; // 原1.x版本themeColorValue17
            break;
        default:
            break;
    }
    return color;
}


+ (instancetype)randomColor {
    static NSInteger index = 0;
    NSArray *colorArray = @[@"cbe9ea",@"e8edfc",@"eef6f4",@"ffebdf",@"edfbff",@"ffe9e9",@"ebf9f5",@"d9eef5",@"d1e5ea"];
    index = index % 9;
    NSString *colorHex = [colorArray objectAtIndex:index];
    index ++;
    return [UIColor colorWithHexString:colorHex];
}

+ (instancetype)channelColorWithIndex:(NSInteger)index {
    UIColor *color = [UIColor whiteColor];
    switch (index) {
        case 0:
            color = [UIColor colorWithHexString:@"e9ae3d"];
            break;
        case 1:
            color = [UIColor colorWithHexString:@"5cc9dd"];
            break;
        case 2:
            color = [UIColor colorWithHexString:@"d988ae"];
            break;
        case 3:
            color = [UIColor colorWithHexString:@"8c94f2"];
            break;
        case 4:
            color = [UIColor colorWithHexString:@"6cc585"];
            break;
            
        default:
            break;
    }
    return color;
}


@end

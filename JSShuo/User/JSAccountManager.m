//
//  JSAccountManager.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/2.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSAccountManager.h"

@implementation JSAccountManager

+ (instancetype)shareManager{
    static JSAccountManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JSAccountManager alloc]init];
    });
    return manager;
}
@end

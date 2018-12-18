//
//  JSShortVideoModel.m
//  JSShuo
//
//  Created by li que on 2018/11/5.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSShortVideoModel.h"

@implementation JSShortVideoModel

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        NSString *Description = [dictionary valueForKey:@"description"];
        Description = Description.length == 0 ? @"没有值" : Description;
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempDic removeObjectForKey:@"description"];
        [tempDic setValue:Description forKey:@"Description"];
        
        [self setValuesForKeysWithDictionary:tempDic];
    }
    return self;
}

+ (JSShortVideoModel *) modelWithDictionary:(NSDictionary *)dic {
    JSShortVideoModel *model = [[JSShortVideoModel new] initWithDictionary:dic];
    return model;
}


+ (NSArray *) modelsWithArray:(NSArray *)array {
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    if (array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            JSShortVideoModel *model = [JSShortVideoModel modelWithDictionary:array[i]];
            [tempArr addObject:model];
        }
        return (NSArray *)tempArr;
    } else {
        return nil;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"class name>> %@----UndefinedKey:%@",NSStringFromClass([self class]),key);
}

@end

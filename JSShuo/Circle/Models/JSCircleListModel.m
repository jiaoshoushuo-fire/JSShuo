//
//  JSCircleListModel.m
//  JSShuo
//
//  Created by li que on 2019/1/30.
//  Copyright © 2019  乔中祥. All rights reserved.
//

#import "JSCircleListModel.h"

@implementation JSCircleListModel

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        NSString *Description = [dictionary valueForKey:@"description"];
        Description = Description.length == 0 ? @"没有值" : Description;
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempDic removeObjectForKey:@"description"];
        [tempDic setValue:Description forKey:@"Description"];
        
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+ (JSCircleListModel *) modelWithDictionary:(NSDictionary *)dic {
    JSCircleListModel *model = [[JSCircleListModel new] initWithDictionary:dic];
    return model;
}


+ (NSArray *) modelsWithArray:(NSArray *)array {
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    if (array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            JSCircleListModel *model = [JSCircleListModel modelWithDictionary:array[i]];
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

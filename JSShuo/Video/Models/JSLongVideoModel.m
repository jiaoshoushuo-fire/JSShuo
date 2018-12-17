//
//  JSLongVideoModel.m
//  JSShuo
//
//  Created by li que on 2018/11/5.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSLongVideoModel.h"

@implementation JSLongVideoModel

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
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+ (JSLongVideoModel *) modelWithDictionary:(NSDictionary *)dic {
    JSLongVideoModel *model = [[JSLongVideoModel new] initWithDictionary:dic];
    return model;
}


+ (NSArray *) modelsWithArray:(NSArray *)array {
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    if (array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            JSLongVideoModel *model = [JSLongVideoModel modelWithDictionary:array[i]];
            [tempArr addObject:model];
        }
        return (NSArray *)tempArr;
    } else {
        return nil;
    }
}



@end

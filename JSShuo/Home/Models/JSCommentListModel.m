//
//  JSCommentListModel.m
//  JSShuo
//
//  Created by li que on 2018/11/18.
//  Copyright © 2018  乔中祥. All rights reserved.
//

#import "JSCommentListModel.h"
#import "NSMutableAttributedString+JSRangeTextColor.h"
#import "UILabel+QLAdd.h"

@implementation JSCommentListModel

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (CGFloat) getReplayHeight:(JSCommentListModel *)model {
    CGFloat totalHeight = 0.0;
    for (int i = 0; i < model.replyList.count; i++) {
        NSString *contentStr = [model.replyList[i] objectForKey:@"content"]; // 回复的内容
        NSString *replyNickName = [model.replyList[i] objectForKey:@"replyNickname"]; // 回复某个评论的userName
        NSString *combinStr = [NSString stringWithFormat:@"%@回复：%@",replyNickName,contentStr];
        NSMutableAttributedString *indroStr = [NSMutableAttributedString setupAttributeString:combinStr rangeText:replyNickName textColor:[UIColor colorWithHexString:@"4A90E2"]];
        
        UILabel *label = [[UILabel alloc] init];
        label.attributedText = indroStr;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.lineBreakMode=NSLineBreakByTruncatingTail;
        label.characterSpace=2;
        label.lineSpace=3;
        CGSize labSize = [label getLableRectWithMaxWidth:ScreenWidth-15-40-16-15-14];
        //            CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        //            CGFloat endMessageLabH = messageLabAotuH > MessageMAX_H?MessageMAX_H:messageLabAotuH;
        totalHeight += labSize.height;
    }
    return totalHeight + (10+5)*model.replyList.count;
}

+ (JSCommentListModel *) modelWithDictionary:(NSDictionary *)dic {
    JSCommentListModel *model = [[JSCommentListModel new] initWithDictionary:dic];
    return model;
}


+ (NSArray *) modelsWithArray:(NSArray *)array {
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    if (array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            JSCommentListModel *model = [JSCommentListModel modelWithDictionary:array[i]];
            [tempArr addObject:model];
        }
        return (NSArray *)tempArr;
    } else {
        return nil;
    }
}


@end

//
//  JSHomeViewController.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/1.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef  NS_ENUM(NSInteger, JSPageShowType){
    JSHomePage = 1,
    JSSearchResultPage
};

@interface JSHomeViewController : JSBaseViewController

@property (nonatomic,copy) NSString *genreID;
@property (nonatomic,assign) JSPageShowType type;
@property (nonatomic,copy) NSString *keywrod;
@property (nonatomic,assign) int searchType;

@end

NS_ASSUME_NONNULL_END

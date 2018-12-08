//
//  JSActivityHeaderView.h
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/28.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JSActivityHeaderViewDelegate <NSObject>

- (void)didSelectedHeaderView;

@end

@interface JSActivityHeaderView : UICollectionReusableView

@property (nonatomic, weak)id<JSActivityHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

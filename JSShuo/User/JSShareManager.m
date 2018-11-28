//
//  JSShareManager.m
//  JSShuo
//
//  Created by  乔中祥 on 2018/11/17.
//  Copyright © 2018年  乔中祥. All rights reserved.
//

#import "JSShareManager.h"
#import "GFPopMenuView.h"
#import "JSAccountManager+QQ.h"
#import "JSAccountManager+Wechat.h"

@interface JSShareManager()<GFPopMenuViewDelegate>
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *shareText;
@property (nonatomic, copy)NSString *shareUrl;
@property (nonatomic, strong)UIImage *shareImage;
@property (nonatomic, copy)void(^complementBlock)(BOOL isSuccess);
@end

@implementation JSShareManager

+ (instancetype)shareManager{
    static JSShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JSShareManager alloc]init];
    });
    return manager;
}
+(void)shareWithTitle:(NSString *)title Text:(NSString *)shareText Image:(UIImage *)shareImage Url:(NSString *)url complement:(void(^)(BOOL isSuccess))complement{
    JSShareManager *manager = [JSShareManager shareManager];
    manager.title = title;
    manager.shareText = shareText;
    manager.shareImage = shareImage;
    manager.shareUrl = url;
    manager.complementBlock = complement;
    
    [GFPopMenuView showInView:[UIApplication sharedApplication].keyWindow hander:nil delegate:manager];
}

#pragma mark - GFPopMenuViewDelegate

- (void)popMenu:(GFPopMenuView *)popMenu clickItemAtIndex:(NSUInteger)itemIndex{
    switch (itemIndex) {
        case 0:{
            [JSAccountManager shareURLToQQ:self.shareUrl title:self.title description:self.shareText thumbnail:self.shareImage type:GFShareTypeQQ handler:^(BOOL success, BOOL cancel) {
                if (self.complementBlock) {
                    self.complementBlock(success);
                }
            }];
        }break;
        case 1:{
            [JSAccountManager shareURLToWechat:self.shareUrl title:self.title description:self.shareText thumbnail:self.shareImage type:GFShareTypeWechatSession handler:^(BOOL success, BOOL cancel) {
                if (self.complementBlock) {
                    self.complementBlock(success);
                }
            }];
        }break;
        case 2:{
            
        }break;
        case 3:{
            
        }break;
        case 4:{
            
        }break;
            
        default:
            break;
    }
}
@end

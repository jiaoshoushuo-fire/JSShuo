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
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "JSNetworkManager+Login.h"

@interface JSShareManager()<GFPopMenuViewDelegate,MFMessageComposeViewControllerDelegate>
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
                if (success) {
                    [self reportShareSuccessMessage];
                }
                if (self.complementBlock) {
                    self.complementBlock(success);
                }
            }];
        }break;
        case 1:{
            [JSAccountManager shareURLToWechat:self.shareUrl title:self.title description:self.shareText thumbnail:self.shareImage type:GFShareTypeWechatSession handler:^(BOOL success, BOOL cancel) {
                if (success) {
                    [self reportShareSuccessMessage];
                }
                if (self.complementBlock) {
                    self.complementBlock(success);
                }
            }];
        }break;
        case 2:{
            [JSAccountManager shareURLToWechat:self.shareUrl title:self.title description:self.shareText thumbnail:self.shareImage type:GFShareTypeWechatTimeline handler:^(BOOL success, BOOL cancel) {
                if (success) {
                    [self reportShareSuccessMessage];
                }
                if (self.complementBlock) {
                    self.complementBlock(success);
                }
            }];
        }break;
        case 3:{//短信  
            if( [MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
                controller.recipients = @[@"10086"];//发送短信的号码，数组形式入参
                controller.navigationBar.tintColor = [UIColor redColor];
                controller.body = @"body"; //此处的body就是短信将要发生的内容
                controller.messageComposeDelegate = self;
                JSMainViewController *mainVC = [AppDelegate instance].mainViewController;
                RTRootNavigationController *currentNav = mainVC.selectedViewController;
                UIViewController *currentVC = currentNav.rt_topViewController;
                
                [currentVC presentViewController:controller animated:YES completion:nil];
                
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                message:@"该设备不支持短信功能"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }break;
        case 4:{
            
        }break;
            
        default:
            break;
    }
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            if (self.complementBlock) {
                self.complementBlock(YES);
            }
            [self reportShareSuccessMessage];
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            if (self.complementBlock) {
                self.complementBlock(NO);
            }
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            if (self.complementBlock) {
                self.complementBlock(NO);
            }
            break;
        default:
            break;
    }
}

- (void)reportShareSuccessMessage{
    [JSNetworkManager requestShareSuccessWithUrl:self.shareUrl complement:^(BOOL isSuccess, NSDictionary * _Nonnull contentDict) {
        
    }];
}

@end

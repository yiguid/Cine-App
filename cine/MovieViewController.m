//
//  SecondViewController.m
//  cine
//
//  Created by Guyi on 15/10/27.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MovieViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface MovieViewController ()
@property MBProgressHUD *hud;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    //    [self.hud show:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    [animation setType:kCATransitionFade]; //淡入淡出kCATransitionFade
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginScene"];
    self.view.window.rootViewController = loginVC;
}

- (void)share: (NSString *)type {
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    if (imageArray)
    {
        [shareParams SSDKSetupShareParamsByText:@"测试测试 @value(url)"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://www.mob.com"]
                                          title:@"分享测试"
                                           type:SSDKContentTypeImage];
    }
    
    //2、分享
    SSDKPlatformType shareType;
    if ([type isEqualToString:@"weibo"]) {
        shareType = SSDKPlatformTypeSinaWeibo;
    }else if ([type isEqualToString:@"weixin"]) {
        shareType = SSDKPlatformTypeWechat;
    }else{
        shareType = SSDKPlatformTypeQQ;
    }
    
    [ShareSDK share:shareType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 self.hud.labelText = @"分享成功...";//显示提示
                 [self.hud show:YES];
                 NSLog(@"分享成功",nil);
                 [self.hud hide:YES];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 self.hud.labelText = @"分享失败...";//显示提示
                 [self.hud show:YES];
                 NSLog(@"分享失败",nil);
                 [self.hud hide:YES];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 self.hud.labelText = @"分享已取消...";//显示提示
                 [self.hud show:YES];
                 NSLog(@"分享已取消",nil);
                 [self.hud hide:YES];
                 break;
             }
             default:
                 break;
         }
     }];
}

- (IBAction)shareEvent:(id)sender {
    [self share:@"weibo"];
}

- (IBAction)wechatShare:(id)sender {
    [self share:@"weixin"];
}

- (IBAction)QQShare:(id)sender {
    [self share:@"qq"];
}
@end

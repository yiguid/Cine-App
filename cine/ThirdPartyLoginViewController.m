//
//  ThirdPartyLoginViewController.m
//  cine
//
//  Created by Guyi on 15/11/2.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ThirdPartyLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "RegexKitLite.h"

@interface ThirdPartyLoginViewController ()

@end

@implementation ThirdPartyLoginViewController

- (void)modifyUIButton: (UIButton *) button {
    button.backgroundColor = [UIColor grayColor];
    CGRect rect = button.frame;
    rect.size.height = 50;
    button.frame = rect;
    button.layer.cornerRadius = 6.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self modifyUIButton:self.startBtn];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *thirdPartyPlatform = [accountDefaults objectForKey:@"platform"];
    SSDKPlatformType platform;
    NSString *avatarKey;
    if ([thirdPartyPlatform isEqualToString:@"weibo"]) {
        platform = SSDKPlatformTypeSinaWeibo;
        avatarKey = @"avatar_hd";
    }else if ([thirdPartyPlatform isEqualToString:@"weixin"]) {
        platform = SSDKPlatformTypeWechat;
        avatarKey = @"headimgurl";
    }else{
        platform = SSDKPlatformTypeQQ;
        avatarKey = @"figureurl_qq_2";
    }
    [ShareSDK getUserInfo:platform
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               if (state == SSDKResponseStateSuccess) {
                   NSLog(user.nickname,nil);
                   self.nickname.text = user.nickname;
//                   self.info.text = [NSString stringWithFormat:@"%lu",(unsigned long)user.gender];
//                   NSLog(user.birthday,nil);
//                   NSLog(user.description,nil);
                   NSString *str = [user.description stringByReplacingOccurrencesOfString:@" " withString:@""];
                   str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                   //NSLog(str,nil);
                   //str = @"{67 \"76avatar_hd234http://tp1.sinaimg.cn/1656028792/180/5652883792/1";
                   NSString *regexString = @"(.+)avatar_hd\"=\"(.+)\";\"avatar_large(.+)";
                   NSString *avatarImgUrl = [str stringByMatching:regexString capture:2L];
                   NSLog(avatarImgUrl, nil);
                   NSLog(@"123", nil);
                   NSURL *url = [NSURL URLWithString:avatarImgUrl];
                   self.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                   //NSLog([NSString stringWithFormat: @"%ld", (long)user.friendCount],nil);
               }
               else
                   NSLog(@"获取错误",nil);
           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBack:(id)sender {
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScene"];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush]; //淡入淡出kCATransitionFade
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    self.view.window.rootViewController = loginVC;
}

- (IBAction)start:(id)sender {
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    [animation setType:kCATransitionFade]; //淡入淡出kCATransitionFade
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    
    UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarScene"];
    
    //把tabs都加入
    UIStoryboard *cineStoryboard = [UIStoryboard storyboardWithName:@"Cine" bundle:nil];
    UINavigationController *cineNavigationController = [cineStoryboard instantiateViewControllerWithIdentifier:@"CineScene"];
    //        cineNavigationController.title = @"123";
    //        cineNavigationController.tabBarItem.image = [UIImage imageNamed:@"back.png"];
    cineNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
    [tabBarController addChildViewController:cineNavigationController];
    
    //follow
    UIStoryboard *followStoryboard = [UIStoryboard storyboardWithName:@"Follow" bundle:nil];
    UINavigationController *followNavigationController = [followStoryboard instantiateViewControllerWithIdentifier:@"FollowScene"];
    //        cineNavigationController.title = @"123";
    //        cineNavigationController.tabBarItem.image = [UIImage imageNamed:@"back.png"];
    followNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    [tabBarController addChildViewController:followNavigationController];
    
    //movie
    UIStoryboard *movieStoryboard = [UIStoryboard storyboardWithName:@"Movie" bundle:nil];
    UINavigationController *movieNavigationController = [movieStoryboard instantiateViewControllerWithIdentifier:@"MovieScene"];
    //        cineNavigationController.title = @"123";
    //        cineNavigationController.tabBarItem.image = [UIImage imageNamed:@"back.png"];
    movieNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:2];
    [tabBarController addChildViewController:movieNavigationController];
    
    //my
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    UINavigationController *myNavigationController = [myStoryboard instantiateViewControllerWithIdentifier:@"MyScene"];
    //        cineNavigationController.title = @"123";
    //        cineNavigationController.tabBarItem.image = [UIImage imageNamed:@"back.png"];
    myNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:3];
    [tabBarController addChildViewController:myNavigationController];
    
    self.view.window.rootViewController = tabBarController;
}
@end

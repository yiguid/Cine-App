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
#import "RestAPI.h"
#import "AFNetworking.h"
#import "UITabBar+badge.h"
#import "EvaluationModel.h"
#import "MJExtension.h"

@interface ThirdPartyLoginViewController ()

@property MBProgressHUD *hud;
@property NSMutableArray *zanarr;
@property NSMutableArray *pinglunarr;
@property NSMutableArray *ganxiearr;

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
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"登录中...";//显示提示
    // hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    
    // Do any additional setup after loading the view.
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *thirdPartyPlatform = [accountDefaults objectForKey:@"platform"];
    SSDKPlatformType platform;
    NSString *avatarKey;
    if ([thirdPartyPlatform isEqualToString:@"weibo"]) {
        platform = SSDKPlatformTypeSinaWeibo;
        self.platformType = @"2";
        avatarKey = @"(.+)avatar_hd\"=\"(.+)\";\"avatar_large(.+)";
    }else if ([thirdPartyPlatform isEqualToString:@"weixin"]) {
        platform = SSDKPlatformTypeWechat;
        self.platformType = @"0";
        avatarKey = @"(.+)headimgurl=\"(.+)\";language(.+)";
    }else{
        platform = SSDKPlatformTypeQQ;
        self.platformType = @"3";
        avatarKey = @"(.+)figureurl_qq_2\"=\"(.+)\";gender(.+)";
    }
    [ShareSDK getUserInfo:platform
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               if (state == SSDKResponseStateSuccess) {
                   //platformType
                   //用户昵称
                   NSLog(user.nickname,nil);
                   self.nicknameParam = user.nickname;
                   //唯一标识
                   NSLog(user.uid,nil);
                   self.platformId = user.uid;
                   //user.gender = 0
                   self.gender = [NSString stringWithFormat:@"%lu",(unsigned long)user.gender];
                   
                   self.nickname.text = user.nickname;
//                   self.info.text = [NSString stringWithFormat:@"%lu",(unsigned long)user.gender];
//                   NSLog(user.birthday,nil);
//                   NSLog(user.description,nil);
                   NSString *str = [user.description stringByReplacingOccurrencesOfString:@" " withString:@""];
                   str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                   //NSLog(str,nil);
                   //str = @"{67 \"76avatar_hd234http://tp1.sinaimg.cn/1656028792/180/5652883792/1";
                   //NSString *regexString = @"(.+)avatar_hd\"=\"(.+)\";\"avatar_large(.+)";
                   NSString *avatarImgUrl = [str stringByMatching:avatarKey capture:2L];
                   NSLog(avatarImgUrl, nil);
                   self.avatarURL = avatarImgUrl;
                   NSLog(@"type:%@",self.platformType, nil);
                   
                   NSURL *url = [NSURL URLWithString:avatarImgUrl];
                   self.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                   //NSLog([NSString stringWithFormat: @"%l", (long)user.friendCount],nil);
                   
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
    [self.hud show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    //传入的参数

    NSDictionary *parameters = @{@"platformId":self.platformId,@"platformType":self.platformType,@"nickname":self.nicknameParam,@"avatarURL":self.avatarURL,@"gender":self.gender};
    //你的接口地址
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASE_API,@"platform"];
    //发送请求
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject allKeys] containsObject:@"error"]) {
//            [self.hud hide:YES];
            self.hud.labelText = @"用户名密码错误...";//显示提示
            [self.hud show:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.hud hide:YES];
                
            });
        }
        else {
            //存储token值
            NSString *token = responseObject[@"token"];
            //存储用户id
            NSString *userID = responseObject[@"id"];
            
            //  NSLog(@"-------%@", token);
            
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setObject:token forKey:@"token"];
            [userDef setObject:userID forKey:@"userID"];
            //获取七牛存储的token
            [manager GET:QINIU_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //存储token值
                NSString *qiniuToken = responseObject[@"token"];
                //存储用户id
                NSString *qiniuDomain = responseObject[@"domain"];
                [userDef setObject:qiniuToken forKey:@"qiniuToken"];
                [userDef setObject:qiniuDomain forKey:@"qiniuDomain"];
                [userDef synchronize];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Qiniu Error: %@", error);
            }];
            
            
            CATransition *animation = [CATransition animation];
            [animation setDuration:1.0];
            [animation setType:kCATransitionFade]; //淡入淡出kCATransitionFade
            [animation setSubtype:kCATransitionFromRight];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
            
            UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarScene"];
            
            //tabbar样式
            NSInteger offset = 6;
            
            //把tabs都加入
            UIStoryboard *cineStoryboard = [UIStoryboard storyboardWithName:@"Cine" bundle:nil];
            UINavigationController *cineNavigationController = [cineStoryboard instantiateViewControllerWithIdentifier:@"CineScene"];
            //        cineNavigationController.title = @"123";
            //        cineNavigationController.tabBarItem.image = [UIImage imageNamed:@"back.png"];
            //cineNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
            //必须要加 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal， 太坑爹了！！！
            cineNavigationController.tabBarItem.image = [[UIImage imageNamed:@"1_n@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            cineNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"1_p@2x.png"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [cineNavigationController.tabBarItem setImageInsets:UIEdgeInsetsMake(offset, 0, -offset, 0)];
            [tabBarController addChildViewController:cineNavigationController];
            
            //follow
            UIStoryboard *followStoryboard = [UIStoryboard storyboardWithName:@"Follow" bundle:nil];
            UINavigationController *followNavigationController = [followStoryboard instantiateViewControllerWithIdentifier:@"FollowScene"];
            
            
            
            //        cineNavigationController.title = @"123";
            //        cineNavigationController.tabBarItem.image = [UIImage imageNamed:@"back.png"];
            //        followNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
            
            followNavigationController.tabBarItem.image = [[UIImage imageNamed:@"2_n@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            followNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"follow-selected@2x.png"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [followNavigationController.tabBarItem setImageInsets:UIEdgeInsetsMake(offset, 0, -offset, 0)];
            [tabBarController addChildViewController:followNavigationController];
            
            //movie
            UIStoryboard *movieStoryboard = [UIStoryboard storyboardWithName:@"Movie" bundle:nil];
            UINavigationController *movieNavigationController = [movieStoryboard instantiateViewControllerWithIdentifier:@"MovieScene"];
            //        cineNavigationController.title = @"123";
            //        cineNavigationController.tabBarItem.image = [UIImage imageNamed:@"back.png"];
            //        movieNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:2];
            
            movieNavigationController.tabBarItem.image = [[UIImage imageNamed:@"3_n@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            movieNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"3_p@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [movieNavigationController.tabBarItem setImageInsets:UIEdgeInsetsMake(offset, 0, -offset, 0)];
            [tabBarController addChildViewController:movieNavigationController];
            
            //my
            UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
            UINavigationController *myNavigationController = [myStoryboard instantiateViewControllerWithIdentifier:@"MyScene"];
            //        cineNavigationController.title = @"123";
            //        cineNavigationController.tabBarItem.image = [UIImage imageNamed:@"back.png"];
            //        myNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:3];
            
            myNavigationController.tabBarItem.image = [[UIImage imageNamed:@"4_n@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            myNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"4_p@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [myNavigationController.tabBarItem setImageInsets:UIEdgeInsetsMake(offset, 0, -offset, 0)];
            [tabBarController addChildViewController:myNavigationController];
            
            self.view.window.rootViewController = tabBarController;
            
            NSString *url1 =[NSString stringWithFormat:@"%@/%@/votes",BASE_API,userID];
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
            [manager GET:url1 parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"请求返回,%@",responseObject);
                     
                     self.zanarr = [EvaluationModel mj_objectArrayWithKeyValuesArray:responseObject];
                     NSInteger count = 0;
                     
                     for (EvaluationModel * eval in self.zanarr) {
                         if ([eval.is_read isEqualToString:@"0"]) {
                             
                             
                             count = count + 1;
                             NSString * str = [NSString stringWithFormat:@"%ld",(long)count];
                             
                             if (![str isEqualToString:@"0"]) {
                                 [tabBarController.tabBar showBadgeOnItemIndex:3];
                                 
                             }
                             
                         }
                     }
                     
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     //             [self.hud setHidden:YES];
                     NSLog(@"请求失败,%@",error);
                 }];
            
            
            NSDictionary *parameters = @{@"to":userID};
            NSString *url2 =[NSString stringWithFormat:@"%@/commentme",BASE_API];
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
            [manager GET:url2 parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"请求返回,%@",responseObject);
                     
                     self.pinglunarr = [EvaluationModel mj_objectArrayWithKeyValuesArray:responseObject];
                     NSInteger count = 0;
                     
                     for (EvaluationModel * eval in self.pinglunarr) {
                         if ([eval.is_read isEqualToString:@"0"]) {
                             
                             
                             count = count + 1;
                             NSString * str = [NSString stringWithFormat:@"%ld",(long)count];
                             
                             if (![str isEqualToString:@"0"]) {
                                 [tabBarController.tabBar showBadgeOnItemIndex:3];
                                 
                                 
                             }
                             
                         }
                     }
                     
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     //             [self.hud setHidden:YES];
                     NSLog(@"请求失败,%@",error);
                 }];
            
            
            
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
            NSString *url3 = [NSString stringWithFormat:@"%@/thanked/%@/recommend",BASE_API,userID];
            [manager GET:url3 parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"请求返回,%@",responseObject);
                     
                     self.ganxiearr = [EvaluationModel mj_objectArrayWithKeyValuesArray:responseObject];
                     
                     NSInteger count = 0;
                     
                     for (EvaluationModel * eval in self.ganxiearr) {
                         if ([eval.is_read isEqualToString:@"0"]) {
                             
                             
                             count = count + 1;
                             NSString * str = [NSString stringWithFormat:@"%ld",(long)count];
                             
                             if (![str isEqualToString:@"0"]) {
                                 [tabBarController.tabBar showBadgeOnItemIndex:3];
                                 
                             }
                             
                         }
                     }
                     
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     //             [self.hud setHidden:YES];
                     NSLog(@"请求失败,%@",error);
                 }];

            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.hud hide:YES afterDelay:2];
        self.hud.labelText = @"登录失败...";//显示提示
        [self.hud show:YES];
        [self.hud hide:YES afterDelay:2];
    }];
    
}
@end

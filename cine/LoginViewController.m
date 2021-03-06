//
//  LoginViewController.m
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDK/ShareSDK.h>
#import "RestAPI.h"
#import "UITabBar+badge.h"
#import "EvaluationModel.h"
#import "MJExtension.h"
@interface LoginViewController ()

@property MBProgressHUD *hud;

/**
 *  用户列表
 */
@property (nonatomic, strong) NSMutableArray *users;
@property NSMutableArray *zanarr;
@property NSMutableArray *pinglunarr;
@property NSMutableArray *ganxiearr;
@end

@implementation LoginViewController

- (void)modifyUITextField: (UITextField *) textField {
    CGRect rect = textField.frame;
    rect.size.height = 50;
    textField.frame = rect;
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)modifyUIButton: (UIButton *) button {
    button.backgroundColor = [UIColor grayColor];
    CGRect rect = button.frame;
    rect.size.height = 50;
    button.frame = rect;
    button.layer.cornerRadius = 6.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self modifyUITextField: self.username];
    [self modifyUITextField: self.password];
    [self modifyUIButton:self.loginBtn];
//    NSLog(@"123",nil);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"登录中...";//显示提示
    // hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    self.username.delegate = self;
    self.password.delegate = self;
    self.zanarr = [[NSMutableArray alloc]init];
    self.pinglunarr = [[NSMutableArray alloc]init];
    self.ganxiearr = [[NSMutableArray alloc]init];
   
}

- (void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef valueForKey:@"token"];
    if (token != nil) {
        [self start];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //DetailViewController *detail = [segue destinationViewController];
    NSLog(@"username: %@",self.username.text,nil);
    NSLog(@"password: %@",self.password.text,nil);
}

- (IBAction)login:(id)sender {
    NSLog(@"username: %@",self.username.text,nil);
    NSLog(@"password: %@",self.password.text,nil);
    [self.view endEditing:YES];
    self.hud.labelText = @"登录中...";//显示提示
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
    //phone password nickname 昵称 avatarURL 投降骑牛图片地址 gender: 0男 1女 city: 城市
//    NSDictionary *parameters = @{@"phone":@"13810104780",@"password":@"19880226",@"nickname":@"nobitagu",@"avatarURL":@"http://www.baidu.com/",@"gender":@"0",@"city":@"Beijing"};
    NSDictionary *parameters = @{@"phone":self.username.text,@"password":self.password.text};
    //你的接口地址
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASE_API,@"auth/signin"];
    //发送请求
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject[@"error"]);
        if ([[responseObject allKeys] containsObject:@"error"]) {
            [self.hud hide:YES afterDelay:2];

            
            if ([responseObject[@"error"]isEqualToString:@"帐号已经被冻结了"]) {
                self.hud.labelText = @"账户被冻结...";//显示提示
                [self.hud show:YES];
                [self.hud hide:YES afterDelay:2];
            }else if ([self.username.text isEqualToString:@""]||[self.password.text isEqualToString:@""]){
                self.hud.labelText = @"请输入帐号密码...";//显示提示
                [self.hud show:YES];
                [self.hud hide:YES afterDelay:2];
            
            }else if ([responseObject[@"error"]isEqualToString:@"没有找到手机号"]){
                self.hud.labelText = @"请输入正确帐号...";//显示提示
                [self.hud show:YES];
                [self.hud hide:YES afterDelay:2];
                
            }
            
            
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
         
        [self start];
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
         [self.hud hide:YES afterDelay:2];
        self.hud.labelText = @"密码错误...";//显示提示
        [self.hud show:YES];
         [self.hud hide:YES afterDelay:2];
    }];
}

- (IBAction)resetPassword:(id)sender {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush]; //淡入淡出kCATransitionFade
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordNavigationScene"];
    self.view.window.rootViewController = tabBarController;
}

- (IBAction)registAccount:(id)sender {
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    //    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
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
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush]; //淡入淡出kCATransitionFade
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterNavigationScene"];
    self.view.window.rootViewController = tabBarController;
}

- (void)loginWithThirdParty:(NSString *)thirdPartyPlatform
{
    SSDKPlatformType platform;
    if ([thirdPartyPlatform isEqualToString:@"weibo"]) {
        platform = SSDKPlatformTypeSinaWeibo;
    }else if ([thirdPartyPlatform isEqualToString:@"weixin"]) {
        platform = SSDKPlatformTypeWechat;
    }else
        platform = SSDKPlatformTypeQQ;
    
    //保存platform
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:thirdPartyPlatform forKey:@"platform"];
    
    [SSEThirdPartyLoginHelper loginByPlatform:platform
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        self.hud.labelText = @"登录成功";
                                        [self.hud show:YES];
                                        self.users = [NSMutableArray array];
                                        //将已授权用户加入列表
                                        [[SSEThirdPartyLoginHelper users] enumerateKeysAndObjectsUsingBlock:^(id key, SSEBaseUser *obj, BOOL *stop) {
                                            [self.users addObject:obj];
                                        }];
                                        NSLog([NSString stringWithFormat: @"%ld", self.users.count], nil);
                                        [self.hud hide:YES];
                                        CATransition *animation = [CATransition animation];
                                        [animation setDuration:0.5];
                                        [animation setType:kCATransitionPush]; //淡入淡出kCATransitionFade
                                        [animation setSubtype:kCATransitionFromRight];
                                        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
                                        [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
                                        UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdPartyScene"];
                                        self.view.window.rootViewController = tabBarController;
                                    }
                                    
                                }];
}

- (IBAction)loginWithAlipay:(id)sender {
    [self loginWithThirdParty:@"weibo"];
}

- (IBAction)loginWithWechat:(id)sender {
    [self loginWithThirdParty:@"weixin"];
}

- (IBAction)loginWithQQ:(id)sender {
    [self loginWithThirdParty:@"qq"];
}

-(void)start {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
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
    //        UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarScene"];
    
    //把tabs都加入
    //        UIStoryboard *cineStoryboard = [UIStoryboard storyboardWithName:@"Cine" bundle:nil];
    //        UINavigationController *cineNavigationController = [cineStoryboard instantiateViewControllerWithIdentifier:@"CineScene"];
    //        [tabBarController addChildViewController:cineNavigationController];
    //
    //        self.view.window.rootViewController = tabBarController;
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
    
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSString *url1 =[NSString stringWithFormat:@"%@/%@/votes",BASE_API,userId];
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
    
   
    NSDictionary *parameters = @{@"to":userId};
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
    NSString *url3 = [NSString stringWithFormat:@"%@/thanked/%@/recommend",BASE_API,userId];
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
//

       
}
@end

//
//  StartViewController.m
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "StartViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface StartViewController ()
@property MBProgressHUD *hud;
@end

@implementation StartViewController

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
    [self modifyUIButton:self.nextBtn];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"登录中...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    //    [self.hud show:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)start:(id)sender {
    //注册用户
    [self.hud show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:120];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    //传入的参数
    //phone password nickname 昵称 avatarURL 投降骑牛图片地址 gender: 0男 1女 city: 城市
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [accountDefaults objectForKey:@"mobile"];
    NSString *password = [accountDefaults objectForKey:@"password"];
    NSString *nickname = [accountDefaults objectForKey:@"nickname"];
    NSString *gender = [accountDefaults objectForKey:@"gender"];
    NSString *avatarURL = @"http://www.google.com";
    NSString *city = @"Beijing";
    NSDictionary *parameters = @{@"phone":mobile,@"password":password,@"nickname":nickname,@"avatarURL":avatarURL,@"gender":gender,@"city":city};
    //NSDictionary *parameters = @{@"phone":self.username.text,@"password":self.password.text};
    //接口地址
    NSString *url = @"http://fl.limijiaoyin.com:1337/auth/register";
    //发送请求
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        CATransition *animation = [CATransition animation];
        [animation setDuration:1.0];
        [animation setType:kCATransitionFade]; //淡入淡出kCATransitionFade
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
        UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarScene"];
        self.view.window.rootViewController = tabBarController;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.hud hide:YES];
        self.hud.labelText = @"服务器错误...";//显示提示
        [self.hud show:YES];
        [self.hud hide:YES];
        
    }];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

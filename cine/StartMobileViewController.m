//
//  StartViewController.m
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "StartMobileViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface StartMobileViewController ()
@property MBProgressHUD *hud;
@end

@implementation StartMobileViewController

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
    [self modifyUITextField: self.mobile];
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
    self.hud.labelText = @"发送验证码...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样

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


- (IBAction)backToLogin:(id)sender {
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScene"];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush]; //淡入淡出kCATransitionFade
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    self.view.window.rootViewController = loginVC;
}

- (IBAction)sendCaptcha:(id)sender {
    [self.view endEditing:YES];
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
    //你的接口地址
    NSString *url = @"http://fl.limijiaoyin.com:1337/invite";
    //发送请求
    //服务器真实数据
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *msg = responseObject;
        NSLog(@"%@",msg[@"invite"],nil);
        //发送验证码
        //传入的参数
        NSDictionary *parameters = @{@"phone":self.mobile.text, @"invite":msg[@"invite"]};
        NSString *codeUrl = @"http://fl.limijiaoyin.com:1337/auth/sendSMSCode";
        [manager POST:codeUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            //NSDictionary *msg = responseObject;
            //NSLog(@"%@",msg[@"invite"],nil);
            //发送验证码
            [self.hud hide:YES];
            //保存手机号
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            [accountDefaults setObject:self.mobile.text forKey:@"mobile"];
            //下一步
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"StartCaptchaScene"];
            [self.navigationController pushViewController:vc animated:YES];
     
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self.hud hide:YES];
            self.hud.labelText = @"验证码发送失败...";//显示提示
            [self.hud show:YES];
            [self.hud hide:YES];
            
        }];
        
        [self.hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.hud hide:YES];
        self.hud.labelText = @"服务器有问题啦...";//显示提示
        [self.hud show:YES];
        [self.hud hide:YES];
        
    }];
    
    
//    //本地测试
//    [self.hud hide:YES];
//    //保存手机号
//    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
//    [accountDefaults setObject:self.mobile.text forKey:@"mobile"];
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"StartCaptchaScene"];
//    [self.navigationController pushViewController:vc animated:YES];
}


@end

//
//  StartViewController.m
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "StartCaptchaViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface StartCaptchaViewController ()
@property MBProgressHUD *hud;
@end

@implementation StartCaptchaViewController

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
    [self modifyUITextField:self.captcha];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [accountDefaults objectForKey:@"mobile"];
    self.mobileInfo.text = [NSString stringWithFormat:@"%@%@",self.mobileInfo.text, mobile];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"验证验证码...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)verifyCaptcha:(id)sender {
    //本地测试
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
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [accountDefaults objectForKey:@"mobile"];
    
    NSDictionary *parameters = @{@"phone":mobile, @"code":self.captcha.text};
    //你的接口地址
    NSString *url = @"http://fl.limijiaoyin.com:1337/auth/verifySmsCode";
    //发送请求
    //服务器真实数据
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"StartPasswordScene"];
        [self.navigationController pushViewController:vc animated:YES];
        [self.hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.hud hide:YES];
        self.hud.labelText = @"验证码输入错误...";//显示提示
        [self.hud show:YES];
        [self.hud hide:YES];
        
    }];
}

@end

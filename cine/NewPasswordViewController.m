//
//  NewPasswordViewController.m
//  cine
//
//  Created by Deluan on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "RestAPI.h"

@interface NewPasswordViewController ()

@property MBProgressHUD *hud;

@end

@implementation NewPasswordViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self modifyUITextField: self.password];
    [self modifyUIButton:self.nextBtn];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goButton:(id)sender {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"] ;
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"修改密码...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
    [manager.requestSerializer setTimeoutInterval:120] ;
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASE_API,@"auth/changePassword"];
    NSDictionary *parameters = @{@"phone":self.phoneNumber,@"newPassword":self.password.text} ;
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"修改密码 -- %@",responseObject) ;
        if ([responseObject[@"message"] isEqualToString:@"密码修改失败"]) {
            [self.hud hide:YES];
            self.hud.labelText = @"密码修改失败...";//显示提示
            [self.hud show:YES];
            [self.hud hide:YES];
        }else {
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败 -- %@",error) ;
    }];
}

- (IBAction)backButton:(id)sender {
}
@end

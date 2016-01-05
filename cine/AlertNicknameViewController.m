//
//  AlertNicknameViewController.m
//  cine
//
//  Created by wang on 16/1/5.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "AlertNicknameViewController.h"
#import "RestAPI.h"
@interface AlertNicknameViewController ()

@end

@implementation AlertNicknameViewController


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
    [self modifyUITextField:self.nickname];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//     self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveNickname:(id)sender {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
     NSString *userId = [userDef stringForKey:@"userID"];
    NSDictionary *parameters = @{@"nickname":self.nickname.text};
    NSString *url = [NSString stringWithFormat:@"%@/%@",USER_AUTH_API,userId];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager PUT:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"请求成功");
            [self.navigationController popToRootViewControllerAnimated:YES];
                     
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
  
             NSLog(@"请求失败,%@",error);
         }];

   
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

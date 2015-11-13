//
//  VerificationViewController.m
//  cine
//
//  Created by Deluan on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "VerificationViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NewPasswordViewController.h"

@interface VerificationViewController ()

@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
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

- (IBAction)backButton:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"] ;
    [manager.requestSerializer setTimeoutInterval:120] ;
    
    NSDictionary *parameters = @{@"phone":self.phoneNumber , @"code":self.messageTextFiled.text} ;
    NSString *urlString = @"http://fl.limijiaoyin.com:1337/auth/sendSMSCode" ;
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NewPasswordViewController *newPassword = [[NewPasswordViewController alloc]init] ;
        newPassword.phoneNumber = self.phoneNumber ;
        [self.navigationController pushViewController:newPassword animated:YES] ;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败") ;
    }];

}

- (IBAction)goButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}
@end

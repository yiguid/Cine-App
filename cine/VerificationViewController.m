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
#import "RestAPI.h"

@interface VerificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation VerificationViewController

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
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.phoneNumberLabel.text, self.phoneNumber];

//    self.view.backgroundColor = [UIColor redColor] ;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self modifyUITextField: self.messageTextFiled];
    [self modifyUIButton:self.nextBtn];
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
    
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)goButton:(id)sender {
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"] ;
    [manager.requestSerializer setTimeoutInterval:120] ;
    
    NSDictionary *parameters = @{@"phone":self.phoneNumber , @"code":self.messageTextFiled.text} ;
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",BASE_API,@"auth/verifySmsCode"];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NewPasswordViewController *newPassword = [self.storyboard instantiateViewControllerWithIdentifier:@"newPasswordViewController"] ;
        newPassword.phoneNumber = self.phoneNumber ;
        [self.navigationController pushViewController:newPassword animated:YES] ;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败--%@",error) ;
    }];

}
@end

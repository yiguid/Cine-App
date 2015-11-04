//
//  LoginViewController.h
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
- (IBAction)login:(id)sender;
- (IBAction)resetPassword:(id)sender;
- (IBAction)registAccount:(id)sender;
- (IBAction)loginWithAlipay:(id)sender;
- (IBAction)loginWithWechat:(id)sender;
- (IBAction)loginWithQQ:(id)sender;

@end

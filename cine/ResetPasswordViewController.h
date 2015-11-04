//
//  ResetPasswordViewController.h
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController
- (IBAction)resetPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *captcha;
@property (weak, nonatomic) IBOutlet UIButton *validateBtn;
- (IBAction)backToLogin:(id)sender;
- (IBAction)goBack:(id)sender;

@end

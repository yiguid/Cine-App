//
//  VerificationViewController.h
//  cine
//
//  Created by Deluan on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationViewController : UIViewController


// 手机号码
@property(nonatomic,strong)NSString *phoneNumber ;
@property (weak, nonatomic) IBOutlet UITextField *messageTextFiled;
@property (weak, nonatomic) IBOutlet UIButton * yanzhengBtn;
- (IBAction)backButton:(id)sender;
- (IBAction)goButton:(id)sender;

@end

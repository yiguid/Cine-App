//
//  ResetPasswordViewController.h
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController <UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

// 验证码
@property(nonatomic,strong)NSString *invite ;
// 手机号码
@property(nonatomic,strong)NSString *phoneNumber ;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
- (IBAction)goButton:(id)sender;

- (IBAction)backButton:(id)sender;



@end

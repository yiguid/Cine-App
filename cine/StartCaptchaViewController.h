//
//  StartViewController.h
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartCaptchaViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *captcha;
@property (weak, nonatomic) IBOutlet UILabel *mobileInfo;
- (IBAction)goBack:(id)sender;
- (IBAction)verifyCaptcha:(id)sender;

@end

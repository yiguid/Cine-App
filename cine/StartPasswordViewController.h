//
//  StartViewController.h
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)goBack:(id)sender;
- (IBAction)savePassword:(id)sender;

@end

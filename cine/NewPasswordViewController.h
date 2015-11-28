//
//  NewPasswordViewController.h
//  cine
//
//  Created by Deluan on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


- (IBAction)goButton:(id)sender;
- (IBAction)backButton:(id)sender;

@property(nonatomic,strong)NSString *phoneNumber ;

@end

//
//  StartViewController.h
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartNicknameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)saveNickname:(id)sender;

- (IBAction)goBack:(id)sender;
@end

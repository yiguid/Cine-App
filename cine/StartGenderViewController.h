//
//  StartViewController.h
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartGenderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gender;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)goBack:(id)sender;
- (IBAction)saveGender:(id)sender;
- (IBAction)chooseGender:(id)sender;

@end

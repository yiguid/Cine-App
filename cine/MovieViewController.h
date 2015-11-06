//
//  SecondViewController.h
//  cine
//
//  Created by Guyi on 15/10/27.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "Person.h"
#import "ChoosePersonView.h"

@interface MovieViewController : UIViewController <MDCSwipeToChooseDelegate>
- (IBAction)logout:(id)sender;
- (IBAction)shareEvent:(id)sender;
- (IBAction)wechatShare:(id)sender;
- (IBAction)QQShare:(id)sender;

@property (nonatomic, strong) Person *currentPerson;
@property (nonatomic, strong) ChoosePersonView *frontCardView;
@property (nonatomic, strong) ChoosePersonView *backCardView;

@end


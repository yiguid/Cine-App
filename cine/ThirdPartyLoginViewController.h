//
//  ThirdPartyLoginViewController.h
//  cine
//
//  Created by Guyi on 15/11/2.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdPartyLoginViewController : UIViewController
- (IBAction)goBack:(id)sender;
- (IBAction)start:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (strong, nonatomic) NSString *nicknameParam;
@property (strong, nonatomic) NSString *platformId;
@property (strong, nonatomic) NSString *platformType;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) NSString *gender;


@end

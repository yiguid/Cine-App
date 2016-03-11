//
//  AlertNicknameViewController.h
//  cine
//
//  Created by wang on 16/1/5.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertNicknameViewController : UIViewController{

      IBOutlet UILabel *namelabel;
    
}


@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)saveNickname:(id)sender;
@property(nonatomic,strong)NSString * userID;


@end

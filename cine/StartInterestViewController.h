//
//  StartViewController.h
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartInterestViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *interestCollect;
- (IBAction)saveInterest:(id)sender;

@end

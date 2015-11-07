//
//  AddPersonViewController.h
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "Person.h"
#import "ChoosePersonView.h"
@interface AddPersonViewController : UITableViewController<MDCSwipeToChooseDelegate,UITableViewDataSource>

@property (nonatomic, strong) Person *currentPerson;
@property (nonatomic, strong) ChoosePersonView *frontCardView;
@property (nonatomic, strong) ChoosePersonView *backCardView;

@end

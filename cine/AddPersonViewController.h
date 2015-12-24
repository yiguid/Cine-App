//
//  AddPersonViewController.h
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "ChoosePersonView.h"
#import "SDRefresh.h"
@interface AddPersonViewController : UIViewController<MDCSwipeToChooseDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ChoosePersonView *frontCardView;
@property (nonatomic, strong) ChoosePersonView *backCardView;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

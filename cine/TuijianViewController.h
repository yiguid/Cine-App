//
//  TuijianViewController.h
//  cine
//
//  Created by wang on 16/1/27.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "ChoosePersonView.h"
@interface TuijianViewController : UIViewController<MDCSwipeToChooseDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ChoosePersonView *frontCardView;
@property (nonatomic, strong) ChoosePersonView *backCardView;
@property (nonatomic, strong) NSArray * personarr;

@end

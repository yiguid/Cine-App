//
//  FollowTableViewController.h
//  cine
//
//  Created by wang on 16/1/18.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface FollowTableViewController : UITableViewController
- (IBAction)follow:(id)sender;
- (IBAction)publish:(id)sender;
- (IBAction)addPerson:(UIButton *)sender;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;


@property (nonatomic, strong)UIView * followview;

@end

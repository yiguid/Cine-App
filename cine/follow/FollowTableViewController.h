//
//  FollowTableViewController.h
//  cine
//
//  Created by Guyi on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface FollowTableViewController : UITableViewController
- (IBAction)follow:(id)sender;
- (IBAction)publish:(id)sender;
- (IBAction)addPerson:(UIButton *)sender;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

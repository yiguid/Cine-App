//
//  DinggeTotalTableViewController.h
//  cine
//
//  Created by wang on 16/1/4.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface DinggeTotalTableViewController : UITableViewController

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@property (nonatomic, strong)NSString * movieID;

@end

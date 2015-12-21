//
//  TaTableViewController.h
//  cine
//
//  Created by Mac on 15/11/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface TaTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *revtableview;
@property(nonatomic, strong) UITableView *dinggetableview;
@property(nonatomic, strong) UITableView *rectableview;

@end

//
//  TadeTableViewController.h
//  cine
//
//  Created by wang on 15/12/22.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TadeTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>


@property(nonatomic, strong) UITableView *revtableview;
@property(nonatomic, strong) UITableView *dinggetableview;
@property(nonatomic, strong) UITableView *rectableview;

@property(nonatomic, strong)NSString * ID;


@end

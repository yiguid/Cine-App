//
//  TaViewController.h
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
#import "UserModel.h"
@interface TaViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>



@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) UITableView *revtableview;
@property(nonatomic, strong) UITableView *dinggetableview;
@property(nonatomic, strong) UITableView *rectableview;

@property(nonatomic, strong)UserModel * model;


@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;


@end

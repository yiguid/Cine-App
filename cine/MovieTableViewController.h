//
//  MovieTableViewController.h
//  cine
//
//  Created by Mac on 15/11/19.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface MovieTableViewController : UITableViewController<UITableViewDataSource, UITabBarDelegate>




@property(strong,nonatomic) NSMutableArray *starrings;
@property(strong,nonatomic) NSMutableArray *genres;

@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *name;


@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

#import <UIKit/UIKit.h>

@interface RRPSectionFootView : UIView
@property (nonatomic, weak) UITableView *tableView;
@end
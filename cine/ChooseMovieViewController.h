//
//  ChooseMovieViewController.h
//  cine
//
//  Created by Guyi on 15/12/8.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
#import "MovieModel.h"
@interface ChooseMovieViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) NSArray *filterData;
@property MBProgressHUD *hud;
@property UISearchDisplayController *searchDisplayController;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@property(nonatomic,strong)MovieModel *movie;

@property (nonatomic,strong) NSString * judge;



@end

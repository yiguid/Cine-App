//
//  MovieSecondViewController.h
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface MovieSecondViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITabBarDelegate>

@property(nonatomic,strong) UITableView * tableview;

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

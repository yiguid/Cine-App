//
//  ShuoxiTwoViewController.h
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
#import "MOvieModel.h"
@interface ShuoxiTwoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) UITableView * tableView;

@property (nonatomic, weak) SDRefreshFooterView *shuoxirefreshFooter;

@property(nonatomic,strong)MovieModel *movie;
@property(nonatomic,strong)NSString *activityId;
@property(nonatomic,strong)NSString *activityimage;

@end

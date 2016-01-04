//
//  CineViewController.h
//  cine
//
//  Created by Guyi on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
#import "MOvieModel.h"

@interface ShuoXiSecondViewController : UITableViewController

@property (nonatomic, weak) SDRefreshFooterView *shuoxirefreshFooter;

@property(nonatomic,strong)MovieModel *movie;
@property(nonatomic,strong)NSString *activityId;
@property(nonatomic,strong)NSString *activityimage;


@end

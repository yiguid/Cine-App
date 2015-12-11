//
//  ShuoxiTableViewController.h
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface ShuoxiTableViewController : UITableViewController<UITableViewDataSource, UITabBarDelegate>


@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;


@property(nonatomic,strong)NSString * moviepicture;

@property (nonatomic,strong)NSString * ShuoID;

@end

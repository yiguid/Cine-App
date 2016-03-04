//
//  HaopingTotalViewController.h
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface HaopingTotalViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) UITableView * tableView;


@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@property (nonatomic, strong)NSString * movieID;

@property (nonatomic, strong)UIButton * zhedangBtn;
@property (nonatomic, strong)UIImageView *noDataImageView;

@end

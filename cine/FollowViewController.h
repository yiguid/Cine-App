//
//  FollowViewController.h
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface FollowViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) UITableView * tableView;

- (IBAction)follow:(id)sender;
- (IBAction)publish:(id)sender;
- (IBAction)addPerson:(UIButton *)sender;

@property (nonatomic, strong)UIButton * zhedangBtn;
@property (nonatomic, strong)UIButton * zheBtn;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@property (nonatomic, strong)UIImageView *noDataImageView;
@property (nonatomic, strong)UILabel * noDataLabel;

@property (nonatomic, strong)UIView * followview;
@end

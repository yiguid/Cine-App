//
//  MyLookViewController.h
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface MyLookViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) UITableView * tableView;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@property (nonatomic, strong)UIButton * zhedangBtn;
@property (nonatomic, strong)UIImageView *noDataImageView;
@property (nonatomic, strong)UILabel * noDataLabel;

@end

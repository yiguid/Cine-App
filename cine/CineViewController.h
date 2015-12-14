//
//  CineViewController.h
//  cine
//
//  Created by Guyi on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface CineViewController : UIViewController <UITableViewDataSource, UITabBarDelegate>

@property (nonatomic, weak) SDRefreshFooterView *DinggerefreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *DinggerefreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *ShuoxirefreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *ShuoxirefreshHeader;

@property (nonatomic, strong)UIView * dinggeView;
@property (nonatomic, strong)UIButton * dinggeBtn;




@end

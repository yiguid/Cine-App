//
//  CineViewController.h
//  cine
//
//  Created by Guyi on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface CineViewController : UIViewController <UITableViewDataSource, UITabBarDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) SDRefreshFooterView *dinggerefreshFooter;
@property (nonatomic, weak) SDRefreshFooterView *shuoxirefreshFooter;



@property (nonatomic, strong)UIView * dinggeView;
@property (nonatomic, strong)UIButton * dinggeBtn;




@end

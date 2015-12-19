//
//  TAViewController.h
//  cine
//
//  Created by wang on 15/12/19.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TAViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>



@property(nonatomic, strong) UITableView *revtableview;
@property(nonatomic, strong) UITableView *dinggetableview;
@property(nonatomic, strong) UITableView *rectableview;

@end

//
//  RecommendSecondViewController.h
//  cine
//
//  Created by wang on 15/12/15.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface RecommendSecondViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>


@property(nonatomic, strong) UIView *textView;
@property(nonatomic, strong) UITextField *textFiled;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UIButton *textButton;
@property(nonatomic, strong) UIImageView *image;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;


@property(nonatomic,strong) NSString * recimage;
@property(nonatomic,strong) NSString * recID;


@end
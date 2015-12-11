//
//  ShuoxiViewController.h
//  cine
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface ShuoxiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>


@property(nonatomic,strong) UIView * textView;
@property(nonatomic,strong) UITextField * textFiled;
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,strong) UIButton * textButton;
@property(nonatomic,strong) UIImageView * imageview;

@property (nonatomic,strong)NSMutableArray * textArray;

@property(nonatomic,strong) NSString * movieID;


@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@property (nonatomic,strong)NSString * ShuoID;

@end

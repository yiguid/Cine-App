//
//  ShuoxiViewController.h
//  cine
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
#import "MOvieModel.h"
@interface ShuoxiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate>


@property(nonatomic,strong) UIView * textView;
@property(nonatomic,strong) UITextView * textFiled;
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,strong) UIButton * textButton;
@property(nonatomic,strong) UIImageView * imageview;


@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property(nonatomic,strong)MovieModel *movie;

@property (nonatomic,strong)NSString * ShuoID;
@property (nonatomic,strong)NSString * shuoimage;
@property(nonatomic,strong)NSString *commentID;

@end

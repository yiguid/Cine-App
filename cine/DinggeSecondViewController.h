//
//  DinggeSecondViewController.h
//  cine
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
#import "YXLTagEditorImageView.h"


@interface DinggeSecondViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate>

@property(nonatomic, strong) UIView *textView;
@property(nonatomic, strong) UITextView *textFiled;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UIButton *textButton;
@property(nonatomic, strong) UIImageView *image;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;


@property(nonatomic,strong) NSString * dingimage;
@property(nonatomic,strong) NSString * DingID;

@property(nonatomic,strong) YXLTagEditorImageView *tagEditorImageView;
@property(nonatomic,strong) NSMutableArray *tagsArray;
@property(nonatomic,strong) NSMutableArray *coordinateArray;

@end

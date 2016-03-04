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

@property (nonatomic, strong)UIImageView *noDataImageView;
@property (nonatomic, strong)UIImageView *noActivityDataImageView;

@property (nonatomic, strong)UIButton * zhedangBtn;


@property (nonatomic, strong)UIView * dinggeView;
@property (nonatomic, strong)UIView * tuijianView;
@property (nonatomic, strong)UIView * biaoqianView;
@property (nonatomic, strong)UIButton * dinggeBtn;


@property (nonatomic, strong)UIButton * TuijianBtn;
@property (nonatomic, strong)UIButton * RebiaoqianBtn;
@property (nonatomic, strong)UIButton * ReBtn;
@property (nonatomic, strong)UIButton * TuibiaoqianBtn;


@property (strong, nonatomic) NSString *nicknameParam;
@property (strong, nonatomic) NSString *platformId;
@property (strong, nonatomic) NSString *platformType;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *Titlestring;
@property (nonatomic,strong)NSString * tagId;

@end

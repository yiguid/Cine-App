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


@property (nonatomic, strong)UIButton * zhedangBtn;


@property (nonatomic, strong)UIView * dinggeView;
@property (nonatomic, strong)UIView * tuijianView;
@property (nonatomic, strong)UIView * biaoqianView;
@property (nonatomic, strong)UIButton * dinggeBtn;



@property (strong, nonatomic) NSString *nicknameParam;
@property (strong, nonatomic) NSString *platformId;
@property (strong, nonatomic) NSString *platformType;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *Titlestring;
@property (nonatomic,strong)NSString * tagId;

@end

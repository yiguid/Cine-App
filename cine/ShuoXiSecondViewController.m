//
//  CineViewController.m
//  cine
//
//  Created by Guyi on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ShuoXiSecondViewController.h"
#import "ShuoXiModel.h"
#import "ShuoXiModelFrame.h"
#import "MyShuoXiTableViewCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MovieModel.h"
#import "RestAPI.h"
#import "TadeTableViewController.h"
#import "ShuoxiViewController.h"
#import "PublishViewController.h"

@interface ShuoXiSecondViewController (){
    
        NSMutableArray * ShuoXiArr;

    
}
@property(nonatomic,strong)UITableView *shuoxi;
@property(nonatomic, strong)NSArray *statusFramesShuoXi;
@property (nonatomic, strong) NSDictionary *dic;
@property MBProgressHUD *hud;

@end

@implementation ShuoXiSecondViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add two table views
    //设置导航栏
    [self setNav];
    
    self.title = [NSString stringWithFormat:@"%@",self.movie.title];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
    [self loadShuoXiData];
    
    [ShuoXiModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    ShuoXiArr = [NSMutableArray array];
    
    [self setupshuoxiHeader];
    [self setupshuoxiFooter];

}

- (void)loadShuoXiData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:SHUOXI_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.statusFramesShuoXi = [ShuoXiModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
        
             [self.hud setHidden:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
}

/**
 * 设置导航栏
 */
- (void)setNav{
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
}

- (void)publish{
    // 创建发布页面导航控制器
    //调用的定格，影评，推荐电影相同的view，需要加判断
    PublishViewController *publishview = [[PublishViewController alloc]init];
    publishview.movie = self.movie;
    publishview.publishType = @"shuoxi";
    [self.navigationController pushViewController:publishview animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.statusFramesShuoXi.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       NSString *ID = [NSString stringWithFormat:@"ShuoXi"];
        MyShuoXiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
       
       if (cell == nil) {
           cell = [[MyShuoXiTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
       }
    
    
    
     ShuoXiModel *model = self.statusFramesShuoXi[indexPath.row];
    
     [cell setup:model];
    
   
    
    if (model.viewCount == nil) {
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
    }

    
    [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
    [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.zambiaBtn];
    
        return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 350;
}

-(void)userbtn:(id)sender{
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    [self.navigationController pushViewController:taviewcontroller animated:YES];

}

-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyShuoXiTableViewCell * cell = (MyShuoXiTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
    
    ShuoXiModel *model = self.statusFramesShuoXi[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/votecount",@"http://fl.limijiaoyin.com:1337/story/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"点赞成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        ShuoxiViewController * shuoxi = [[ShuoxiViewController alloc]init];
    
        shuoxi.hidesBottomBarWhenPushed = YES;
    
        ShuoXiModel *model = self.statusFramesShuoXi[indexPath.row];
        shuoxi.shuoimage = model.image;
        shuoxi.ShuoID = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/story/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    

    
    
    
        [self.navigationController pushViewController:shuoxi animated:YES];

}

- (void)setupshuoxiHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         
            [self.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    
}

- (void)setupshuoxiFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];

    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(shuoxifooterRefresh)];
    _shuoxirefreshFooter = refreshFooter;
}


- (void)shuoxifooterRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.shuoxirefreshFooter endRefreshing];
    });
}

@end

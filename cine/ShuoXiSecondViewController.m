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
#import "TaTableViewController.h"
#import "ShuoxiViewController.h"

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
    
    self.title = [NSString stringWithFormat:@"%@的说戏",self.movie.title];
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
             
             ShuoXiArr = [ShuoXiModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (ShuoXiModel *model in ShuoXiArr) {
                
                 //创建模型
                 ShuoXiModel *status = [[ShuoXiModel alloc]init];
                 status.picture = [NSString stringWithFormat:@"avatar@2x.png"];
                 status.icon = [NSString stringWithFormat:@"avatar@2x.png"];
                 status.answerCount = @"50";
                 status.name = model.user.nickname;
                 status.time = [NSString stringWithFormat:@"1小时前"];
                 status.vip = YES;
                 status.text = model.title;
                 //status.picture = [NSString stringWithFormat:@"shuoxiImg.png"];
                 status.daRenTitle = @"达人";
                 status.mark = @"(著名编剧 导演 )";
                 //创建MianDingGeModelFrame模型
                 ShuoXiModelFrame *statusFrame = [[ShuoXiModelFrame alloc]init];
                 statusFrame.model = status;
                 [statusFrame setModel:status];
                 [statusFrames addObject:statusFrame];
             }
             
             self.statusFramesShuoXi = statusFrames;
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
       //创建模型
       ShuoXiModel *model = ShuoXiArr[indexPath.row];
       ShuoXiModel *status = [[ShuoXiModel alloc]init];
       status.icon = [NSString stringWithFormat:@"avatar@2x.png"];
       status.answerCount = @"50";
       status.name = model.user.nickname;
       status.time = [NSString stringWithFormat:@"1小时前"];
       status.vip = YES;
       status.text = model.title;
       //status.picture = [NSString stringWithFormat:@"shuoxiImg.png"];
       status.daRenTitle = @"达人";
       status.mark = @"(著名编剧 导演 )";
       [cell setup:status];
       [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
        return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    ShuoXiModelFrame *statusFrame = self.statusFramesShuoXi[indexPath.row];
    return statusFrame.cellHeight;
}

-(void)userbtn:(id)sender{
    
    TaTableViewController * taviewcontroller = [[TaTableViewController alloc]init];
    [self.navigationController pushViewController:taviewcontroller animated:YES];

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        ShuoxiViewController * shuoxi = [[ShuoxiViewController alloc]init];
        shuoxi.hidesBottomBarWhenPushed = YES;
        
        ShuoXiModel *model = ShuoXiArr[indexPath.row];
        shuoxi.shuoimage = model.image;
        shuoxi.ShuoID = model.ID;
        
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

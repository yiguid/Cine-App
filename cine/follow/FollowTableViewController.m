//
//  FollowTableViewController.m
//  cine
//
//  Created by Guyi on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "FollowTableViewController.h"
#import "AddPersonViewController.h"
#import "DingGeModel.h"
#import "MyDingGeTableViewCell.h"
#import "MyShuoXiTableViewCell.h"
#import "PublishViewController.h"
#import "ChooseMovieViewController.h"
#import "DingGeModelFrame.h"
#import "RecMovieTableViewCell.h"
#import "RecModel.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "TaTableViewController.h"

@interface FollowTableViewController (){
    
    NSMutableArray * DingGeArr;
}
@property(nonatomic, strong)NSArray *statusFrames;
@property(strong,nonatomic) NSMutableArray *DingArr;
@property(nonatomic,strong)NSMutableArray *dataload;
@property(nonatomic, strong)NSArray *statusFramesDingGe;
@property MBProgressHUD *hud;

@end

@implementation FollowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setNav];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
    [self loadDingGeData];
    self.dataload = [[NSMutableArray alloc]init];
    
    [self Refresh];
    
 }


-(NSArray *)statusFrames{
    if (_statusFrames == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (int i = 0; i < 10; i++ ) {
            
            //创建MLStatus模型
            DingGeModel *status = [[DingGeModel alloc]init];
            status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
            status.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
            status.nikeName = [NSString stringWithFormat:@"霍比特人"];
            status.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
            status.time = @"1小时前";
            status.seeCount = @"600";
            status.zambiaCount = @"600";
            status.answerCount = @"50";
            
            //创建MLStatusFrame模型
            DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
            statusFrame.model = status;
            [statusFrame setModel:status];
            [statusFrames addObject:statusFrame];
            
        }
        _statusFrames = statusFrames;
    }
    return _statusFrames;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:DINGGE_API parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             self.DingArr = DingGeArr;
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 //创建模型
                 DingGeModel *status = [[DingGeModel alloc]init];
                 //status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
                 
                 status.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 status.seeCount = model.watchedcount;
                 status.zambiaCount = model.votecount;
                 status.answerCount = @"50";
                 //               NSLog(@"model.movie == %@",model.movie.title,nil);
                 status.movieName = model.movie.title;
                 status.nikeName = model.user.nickname;
                 status.time = [NSString stringWithFormat:@"1小时前"];
                 //创建MianDingGeModelFrame模型
                 DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
                 statusFrame.model = status;
                 [statusFrame setModel:status];
                 [statusFrames addObject:statusFrame];
             }
             
             
             self.statusFramesDingGe = statusFrames;
             [self.tableView reloadData];
             
             [self.hud setHidden:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置cell
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        DingGeModel *model = self.DingArr[indexPath.row];
        
        NSString * string = model.image;
        
        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        
        [imageView setImage:cell.movieImg.image];
        
        [cell.contentView addSubview:imageView];
        
        
        
        cell.message.text = model.content;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextControloler:)];
//        
//        [cell.contentView addGestureRecognizer:tap];
//        UIView *tapView = [tap view];
//        tapView.tag = 2;
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
        [cell.userImg addGestureRecognizer:tapGesture];
        

        
        
        
        return cell;
    }
    else if(indexPath.section == 1){
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        
        //设置高度
        cell.modelFrame = self.statusFrames[indexPath.row];
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
        [cell.userImg addGestureRecognizer:tapGesture];
        

        
        
        return cell;
    }
    else{
        NSString *ID = @"recMovie";
        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[RecMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:ID];
        }
        for (int i = 0; i < 3; i++) {
            RecModel *model = [[RecModel alloc]init];
            model.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
            model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
            model.nikeName = @"哈哈";
            model.appCount = @"1000人 感谢";
            model.time = @"1小时前";
            model.text = @"哈哈哈和哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈和";
            model.title = @"视觉好";
            model.movieName = @"<<泰囧>>";
            [self.dataload addObject:model];
        }
        [cell setup:self.dataload[indexPath.row]];
        
        return cell;
    }
    return nil;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 270;
    }
    else{
        DingGeModelFrame *statusFrame = self.statusFrames[indexPath.row];
        return statusFrame.cellHeight;
  }
}

-(void)userbtn:(id)sender{
    
    
    TaTableViewController * taviewcontroller = [[TaTableViewController alloc]init];
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
    
    
}




- (IBAction)follow:(id)sender {
 //   NSLog(@"open follow scene",nil);
}

- (IBAction)publish:(id)sender {
    // 创建发布页面导航控制器
//    PublishViewController *publishview = [[PublishViewController alloc]init];
//    [self.navigationController pushViewController:publishview animated:YES];
    ChooseMovieViewController *view = [[ChooseMovieViewController alloc]init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
    
    
}

- (IBAction)addPerson:(UIButton *)sender {
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    AddPersonViewController *addPer = [[AddPersonViewController alloc]init];
    addPer.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addPer animated:YES];
}

#pragma mark - 试图将要进入执行的方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)Refresh
{
    self.refreshHeader.isEffectedByNavigationController = NO;
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.tableView];
    [refreshHeader addTarget:self refreshAction:@selector(headRefresh)];
    self.refreshHeader=refreshHeader;
    [refreshHeader autoRefreshWhenViewDidAppear];
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footRefresh)];
    self.refreshFooter=refreshFooter;
    
    
}
-(void)headRefresh
{
    [self.refreshHeader endRefreshing];
}
-(void)footRefresh
{
    [self.refreshFooter endRefreshing];
}



@end

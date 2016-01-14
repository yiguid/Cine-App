//
//  MyGuanZhuTableViewController.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MyGuanZhuTableViewController.h"
#import "GuanZhuTableViewCell.h"
#import "GuanZhuModel.h"
#import "TadeTableViewController.h"
#import "UserModel.h"
#import "MJExtension.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"

@interface MyGuanZhuTableViewController ()
@property NSMutableArray *dataSource;
@property MBProgressHUD *hud;
@end

@implementation MyGuanZhuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"我关注的人";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
    
    
    self.dataSource = [[NSMutableArray alloc]init];
    [self loadData];
    [self setupHeader];
    [self setupFooter];
}


//[manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
//NSString *url = [NSString stringWithFormat:@"%@/%@",USER_AUTH_API,userId];

- (void)loadData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/following",USER_AUTH_API,userId];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             NSArray *arrModel = [UserModel mj_objectArrayWithKeyValuesArray:responseObject];
             self.dataSource = [arrModel mutableCopy];
             [self.tableView reloadData];
             [self.hud setHidden:YES];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSString *ID = [NSString stringWithFormat:@"GuanZhu"];
    GuanZhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[GuanZhuTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    UserModel *user = self.dataSource[indexPath.row];
    cell.model.userId = user.userId;
    //cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    cell.nickname.text = user.nickname;
    cell.content.text = user.city;
    
    //头像
    [cell.avatarImg sd_setImageWithURL:[NSURL URLWithString:user.avatarURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.avatarImg setImage:cell.avatarImg.image];
        //头像圆形
        cell.avatarImg.layer.masksToBounds = YES;
        cell.avatarImg.layer.cornerRadius = cell.avatarImg.frame.size.width/2;
        //头像边框
        cell.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.avatarImg.layer.borderWidth = 1.5;
    }];


    cell.rightBtn.image = [UIImage imageNamed:@"followed-mark.png"];
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TadeTableViewController * ta = [[TadeTableViewController alloc]init];
    
    UserModel *user = self.dataSource[indexPath.row];
    
    
    ta.nickname = user.nickname;
    ta.userimage = user.avatarURL;
    ta.vip = user.catalog;
    
    [self.navigationController pushViewController:ta animated:YES];
    
    
}



- (void)setupHeader
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

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
    });
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

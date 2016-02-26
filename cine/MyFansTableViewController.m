//
//  MyFansTableViewController.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MyFansTableViewController.h"
#import "TaViewController.h"
#import "GuanZhuTableViewCell.h"
#import "GuanZhuModel.h"
#import "UserModel.h"
#import "MJExtension.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
@interface MyFansTableViewController (){

    NSMutableArray * guanzhuArr;
    NSMutableArray * fensiArr;




}
@property NSMutableArray *dataGuanzhu;
@property NSMutableArray *dataFensi;
@property MBProgressHUD *hud;
@end

@implementation MyFansTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的粉丝";
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    guanzhuArr = [[NSMutableArray alloc]init];
    fensiArr = [[NSMutableArray alloc]init];
    
    self.dataGuanzhu = [[NSMutableArray alloc]init];
    self.dataFensi = [[NSMutableArray alloc]init];
    [self loadData];
    [self setupHeader];
    [self setupFooter];
    [self loadguanzhu];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/followed",USER_AUTH_API,userId];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             
             fensiArr = [UserModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             for (UserModel *model in fensiArr) {
                 if([model.userId isEqual:userId]){
                     
                     [fensiArr removeObject:model];
                     
                     break;
                     
                 }
             }
              self.dataFensi = [fensiArr mutableCopy];
             [self.tableView reloadData];
              [self.hud setHidden:YES];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];

}


- (void)loadguanzhu {
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
            
             
             guanzhuArr = [UserModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             for (UserModel *model in guanzhuArr) {
                 if([model.userId isEqual:userId]){
                     
                     [guanzhuArr removeObject:model];
                     
                     break;
                     
                 }
             }
             
             self.dataGuanzhu = [guanzhuArr mutableCopy];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataFensi count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    // Configure the cell...
    
    
    NSString *ID = [NSString stringWithFormat:@"Fans"];
    GuanZhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[GuanZhuTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
  //  return cell;

    UserModel *user = self.dataFensi[indexPath.row];
    cell.model.userId = user.userId;
    //cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    cell.nickname.text = user.nickname;
    cell.content.text = user.city;
    
    [cell.avatarImg sd_setImageWithURL:[NSURL URLWithString:user.avatarURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.avatarImg setImage:cell.avatarImg.image];
           }];
    

    [cell.rightBtn setImage:[UIImage imageNamed:@"follow-mark.png"] forState:UIControlStateNormal];
    [cell.rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.rightBtn];
    
    
    
    for (UserModel * model in self.dataGuanzhu) {
        if ([user.userId isEqual:model.userId]) {
              [cell.rightBtn setImage:[UIImage imageNamed:@"followed-mark.png"] forState:UIControlStateNormal];
            [cell.rightBtn setTitle:@" 已关注" forState:UIControlStateNormal];
        }
    }


    
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaViewController * ta = [[TaViewController alloc]init];
    
   UserModel *user = self.dataFensi[indexPath.row];
    
    
    ta.model = user;
    
    [self.navigationController pushViewController:ta animated:YES];
    
    
}

- (void) rightBtn :(UIButton *)sender{
    
    UIButton *btn = (UIButton *)sender;
    GuanZhuTableViewCell *cell = (GuanZhuTableViewCell *)btn.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    UserModel *model = [self.dataFensi objectAtIndex:indexPath.row];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    // Set custom view mode
    self.hud.mode = MBProgressHUDModeCustomView;
    
    self.hud.labelText = @"已关注";//显示提示
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    NSString *url;
    if ([cell.rightBtn.titleLabel.text isEqualToString:@" 已关注"]) {
        url = [NSString stringWithFormat:@"%@/%@/unfollow/%@", BASE_API, userId,model.userId];
    }else{
        url = [NSString stringWithFormat:@"%@/%@/follow/%@", BASE_API, userId,model.userId];
    }
    
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([cell.rightBtn.titleLabel.text isEqualToString:@" 已关注"]) {
                  
                  [cell.rightBtn setImage:[UIImage imageNamed:@"follow-mark@2x.png"] forState:UIControlStateNormal];
                  [cell.rightBtn setTitle:@" 关注" forState:UIControlStateNormal];
                  self.hud.labelText = @"取消关注";
                  [self.hud show:YES];
                  [self.hud hide:YES afterDelay:1];
                  NSLog(@"取消关注成功,%@",responseObject);
              }else{
                  //修改按钮
                  [cell.rightBtn setImage:[UIImage imageNamed:@"followed-mark.png"] forState:UIControlStateNormal];
                  [cell.rightBtn setTitle:@" 已关注" forState:UIControlStateNormal];
                  self.hud.labelText = @"已关注";//显示提示
                  [self.hud show:YES];
                  [self.hud hide:YES afterDelay:1];
                  NSLog(@"关注成功,%@",responseObject);
                  
              }
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //             [self.hud setHidden:YES];
              NSLog(@"请求失败,%@",error);
          }];
    
    
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

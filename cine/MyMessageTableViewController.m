//
//  MyMessageTableViewController.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MyMessageTableViewController.h"
#import "MessageFirstTableViewCell.h"
#import "MessageSecendTableViewCell.h"
#import "MessageEvaluaTableViewController.h"
#import "ZambiaTableViewController.h"
#import "AppreciateTableViewController.h"
#import "SecondModel.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "EvaluationModel.h"
@interface MyMessageTableViewController (){

    
    NSInteger count1;
    NSInteger count2;
    NSInteger count3;
}
@property NSMutableArray *dataSource;
@property NSMutableArray *zanarr;
@property NSMutableArray *ganxiearr;
@property NSMutableArray *pinglunarr;

@end

@implementation MyMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的消息";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.dataSource = [[NSMutableArray alloc]init];
    self.zanarr = [[NSMutableArray alloc]init];
    self.ganxiearr = [[NSMutableArray alloc]init];
    self.pinglunarr = [[NSMutableArray alloc]init];
    [self loadData];
    
    [self loadzan];
    [self loadganxie];
    [self loadpinglun];
    
    
    [self setupHeader];
    [self setupFooter];
}

- (void)loadData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSDictionary *parameters = @{@"target":userId};
    NSString *url = [NSString stringWithFormat:@"%@/message",BASE_API];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             
             self.dataSource = [SecondModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             
             [self.tableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];

    
    
    }


- (void)loadzan {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSString *url =[NSString stringWithFormat:@"%@/%@/votes",BASE_API,userId];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             
             self.zanarr = [EvaluationModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             count1 = 0;
             
             for (EvaluationModel * eval in self.zanarr) {
                 if ([eval.is_read isEqualToString:@"0"]) {
                     
                     
                     count1 = count1 + 1;
                     
                     
                 }
             }

             
             
             
            [self.tableView reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
    
}



- (void)loadganxie {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSDictionary *parameters = @{@"to":userId,@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/thank",BASE_API];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             
             self.ganxiearr = [EvaluationModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             count3 = 0;
             
             for (EvaluationModel * eval in self.ganxiearr) {
                 if ([eval.is_read isEqualToString:@"0"]) {
                     
                     
                     count3 = count3 + 1;
                     
                     
                 }
             }

             
             [self.tableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
}


- (void)loadpinglun {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSDictionary *parameters = @{@"to":userId,@"sort": @"createdAt DESC"};
    NSString *url =[NSString stringWithFormat:@"%@/commentme",BASE_API];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             
             self.pinglunarr = [EvaluationModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             count2 = 0;
             
             for (EvaluationModel * eval in self.pinglunarr) {
                 if ([eval.is_read isEqualToString:@"0"]) {
                     
                     
                     count2 = count2 + 1;
                     
                     
                 }
             }

             
             [self.tableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
    
}





//- (void)loadCommentData {
//    
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    
//    NSString *token = [userDef stringForKey:@"token"];
//    NSString *userId = [userDef stringForKey:@"userID"];
//    NSDictionary *parameters = @{@"to":userId};
//    NSString *url =[NSString stringWithFormat:@"%@/commentme",BASE_API];
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
//    [manager GET:url parameters:parameters
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(@"请求返回,%@",responseObject);
//             
//             self.dataSource = [EvaluationModel mj_objectArrayWithKeyValuesArray:responseObject];
//             
//             
//             [self.tableView reloadData];
//         }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             //             [self.hud setHidden:YES];
//             NSLog(@"请求失败,%@",error);
//         }];
//    
//}

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    if(section == 0 )
        return 4;
    else
        return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        NSString *ID = [NSString stringWithFormat:@"firstCell"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"消息@2x.png"];
            cell.textLabel.text = @"评论我的";
            cell.textLabel.font = XiaoxiFont;
             NSString * str = [NSString stringWithFormat:@"%ld",(long)count2];
            if (![str isEqualToString:@"0"]) {
               cell.detailTextLabel.text = str;
               cell.detailTextLabel.font = TextFont;
               cell.detailTextLabel.textColor = [UIColor redColor];
            }

            
            
           
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //cell.detailTextLabel.textColor = [UIColor whiteColor];
//            cell.detailTextLabel.backgroundColor = [UIColor redColor];
//            cell.detailTextLabel.layer.cornerRadius = 4;
//            cell.detailTextLabel.layer.masksToBounds = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
            [cell.contentView addGestureRecognizer:tap];
            UIView *tagView =[tap view];
            tagView.tag = 0;
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, wScreen-10, 1)];
            
            headView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
            [cell.contentView addSubview:headView];

        }
        else if(indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"喜欢-black@2x.png"];
            cell.textLabel.text = @"赞我的";
            cell.textLabel.font = XiaoxiFont;
            NSString * str = [NSString stringWithFormat:@"%ld",(long)count1];
            if (![str isEqualToString:@"0"]) {
                cell.detailTextLabel.text = str;
                cell.detailTextLabel.font = TextFont;
                cell.detailTextLabel.textColor = [UIColor redColor];
            }

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
            [cell.contentView addGestureRecognizer:tap];
            UIView *tagView =[tap view];
            tagView.tag = 1;
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, wScreen-10, 1)];
            
            headView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
            [cell.contentView addSubview:headView];
        }
        else if(indexPath.row == 2){
            cell.imageView.image = [UIImage imageNamed:@"关注@2x.png"];
            cell.textLabel.text = @"感谢我的";
            cell.textLabel.font = XiaoxiFont;
            
            NSString * str = [NSString stringWithFormat:@"%ld",(long)count3];
            if (![str isEqualToString:@"0"]) {
                cell.detailTextLabel.text = str;
                cell.detailTextLabel.font = TextFont;
                cell.detailTextLabel.textColor = [UIColor redColor];
            }

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
            [cell.contentView addGestureRecognizer:tap];
            UIView *tagView =[tap view];
            tagView.tag = 2;
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, wScreen-10, 1)];
            
            headView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
            [cell.contentView addSubview:headView];

        }
        else{

            
        }

        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    else{
        NSString *ID = [NSString stringWithFormat:@"secondCell"];
        MessageSecendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[MessageSecendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            
        }
        [cell setup:self.dataSource[indexPath.row]];

        
        return cell;
    }
    
    return nil;
}

/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 30;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        
        UIView * view = [[UIView alloc]init];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        label.text = @"系统消息";
        label.font = TextFont;
        label.textColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1.0];
        [view addSubview:label];
        
        
        return view;
    }
    
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        //为最高的那个headerView的高度
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 80;
    }
    return 44;
}

- (void) nextController:(id)sender{
    
    //定义下一界面返回按钮
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    long tag = [tap view].tag;
    
    if (tag == 0) {
        MessageEvaluaTableViewController *meEva = [[MessageEvaluaTableViewController alloc]init];
        [self.navigationController pushViewController:meEva animated:YES];
    }
    else if(tag == 1)
    {
        ZambiaTableViewController *appreciate = [[ZambiaTableViewController alloc]init];
        [self.navigationController pushViewController:appreciate animated:YES];
    }
    else{
        AppreciateTableViewController *zambia = [[AppreciateTableViewController alloc]init];
        [self.navigationController pushViewController:zambia animated:YES];
    }
}


- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self loadzan];
            [self loadganxie];
            [self loadpinglun];
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

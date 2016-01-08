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

@interface MyMessageTableViewController ()
@property NSMutableArray *dataSource;

@end

@implementation MyMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的消息";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.dataSource = [[NSMutableArray alloc]init];
    [self loadData];
    [self setupHeader];
    [self setupFooter];
}

- (void)loadData {
    for (int i = 0; i < 10; i++) {
        SecondModel *model = [[SecondModel alloc] init];
        model.img = @"shareImg.png";
        model.message = [NSString stringWithFormat:@"%@%d",@"哈哈哈",i];
        [self.dataSource addObject:model];
    }
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
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    if(section == 0 )
        return 3;
    else
        return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        NSString *ID = [NSString stringWithFormat:@"firstCell"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"消息@2x.png"];
            cell.textLabel.text = @"评论我的";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
            [cell.contentView addGestureRecognizer:tap];
            UIView *tagView =[tap view];
            tagView.tag = 0;

        }
        else if(indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"喜欢-black@2x.png"];
            cell.textLabel.text = @"赞我的";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
            [cell.contentView addGestureRecognizer:tap];
            UIView *tagView =[tap view];
            tagView.tag = 1;
        }
        else{
            cell.imageView.image = [UIImage imageNamed:@"关注@2x.png"];
            cell.textLabel.text = @"感谢我的";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
            [cell.contentView addGestureRecognizer:tap];
            UIView *tagView =[tap view];
            tagView.tag = 2;

        }
        
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

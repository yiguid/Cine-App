//
//  MyTableViewController.m
//  cine
//
//  Created by Guyi on 15/11/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyTableViewCell.h"
#import "MyStaticTableViewCell.h"
#import "MyGuanZhuTableViewController.h"
#import "MyFansTableViewController.h"
#import "MyMessageTableViewController.h"
#import "MyDingGeTableViewController.h"
#import "MyRecommendedTableViewController.h"
#import "MySettingTableViewController.h"
#import "MyRecMovieTableViewController.h"
#import "MyEvaluationTableViewController.h"
#import "MyLookTableViewController.h"
#import "CollectionViewController.h"


@interface MyTableViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //取消分割线
   // self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.sectionHeaderHeight = 2;
   // [self.tableView.style  UITableViewStyleGrouped];
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       
       NSForegroundColorAttributeName:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        self.tableView.sectionHeaderHeight = 0;
        self.tableView.sectionFooterHeight = 0;

        return 1;
    }
    else if (section == 1)
    {
        self.tableView.sectionHeaderHeight = 2;

        return 3;
    }
    else if (section == 2)
    {
        self.tableView.sectionHeaderHeight = 2;

        return 5;
    }
    else{
        self.tableView.sectionHeaderHeight = 2;

        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.section == 0) {
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];
        // Configure the cell...
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        cell.nickname.text = @"修远";
        [cell.nickname setTextColor:[UIColor whiteColor]];
        cell.content.text = @"这是我看过最好看的电影";
        cell.backImg.image = [UIImage imageNamed:@"backImg.png"];
        cell.avatarImg.image = [UIImage imageNamed:@"avatar.png"];
        cell.avatarImg.frame = CGRectMake(10, 200, 70, 70);
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else{
        
        MyStaticTableViewCell *cellStatic = [tableView dequeueReusableCellWithIdentifier:@"StaticCell"];
        cellStatic.lineView.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:211.0/255 alpha:1.0];
       
        
        [cellStatic.title setTextColor:[UIColor colorWithRed:117.0/255 green:117.0/255 blue:109.0/255 alpha:1.0]];
        cellStatic.contentView.frame = CGRectMake(5, 0, self.view.bounds.size.width - 10, 54);
        if(indexPath.section == 1)
        {
       
            if (indexPath.row == 0) {
                cellStatic.title.text = @"关注";
                cellStatic.titleImg.image = [UIImage imageNamed:@"follows.png"];
                cellStatic.counts.text = @"1000";
                cellStatic.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                [cellStatic.contentView addGestureRecognizer:tap];
                UIView *tagView =[tap view];
                tagView.tag = 1;


            }
            else if(indexPath.row == 1){
                cellStatic.title.text = @"粉丝";
                cellStatic.titleImg.image = [UIImage imageNamed:@"fans.png"];
                cellStatic.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];

                cellStatic.counts.text = @"33";
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                [cellStatic.contentView addGestureRecognizer:tap];
                UIView *tagView =[tap view];
                tagView.tag = 2;

            }
            else if(indexPath.row == 2){
                cellStatic.title.text = @"消息";
                cellStatic.titleImg.image = [UIImage imageNamed:@"message.png"];
                cellStatic.counts.text = @"7777";
                cellStatic.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];

            
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                [cellStatic.contentView addGestureRecognizer:tap];
                UIView *tagView =[tap view];
                tagView.tag = 3;
            }}
            else if(indexPath.section == 2){
                if (indexPath.row == 0) {
                    cellStatic.title.text = @"定格";
                    cellStatic.titleImg.image = [UIImage imageNamed:@"snap.png"];
                    cellStatic.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];


                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                    [cellStatic.contentView addGestureRecognizer:tap];
                    UIView *tagView =[tap view];
                    tagView.tag = 4;
                }

            
                else if(indexPath.row == 1){
                    cellStatic.title.text = @"看过";
                    cellStatic.titleImg.image = [UIImage imageNamed:@"watched.png"];
                    cellStatic.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];

                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                    [cellStatic.contentView addGestureRecognizer:tap];
                    UIView *tagView =[tap view];
                    tagView.tag = 5;


            
                }else if(indexPath.row == 2){
                    cellStatic.title.text = @"收藏";
                    cellStatic.titleImg.image = [UIImage imageNamed:@"favourite.png"];
                    cellStatic.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                    [cellStatic.contentView addGestureRecognizer:tap];
                    UIView *tagView =[tap view];
                    tagView.tag = 6;

            
                }else if(indexPath.row == 3){
                    cellStatic.title.text = @"推荐电影";
                    cellStatic.titleImg.image = [UIImage imageNamed:@"recmovie.png"];
                    cellStatic.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];

                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                    [cellStatic.contentView addGestureRecognizer:tap];
                    UIView *tagView =[tap view];
                    tagView.tag = 7;


                }else if(indexPath.row == 4){
                    cellStatic.title.text = @"影品";
                    cellStatic.titleImg.image = [UIImage imageNamed:@"movies.png"];
                    cellStatic.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];


                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                    [cellStatic.contentView addGestureRecognizer:tap];
                    UIView *tagView =[tap view];
                    tagView.tag = 8;

                }
        }
        else {
            cellStatic.title.text = @"设置";
            cellStatic.titleImg.image = [UIImage imageNamed:@"setting.png"];
            cellStatic.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
            [cellStatic.contentView addGestureRecognizer:tap];
            UIView *tagView =[tap view];
            tagView.tag = 9;

            
            
        }
        return cellStatic;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 230;
    }
    else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    else{
        return 10;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


// 跳转界面
- (void)nextController :(id)sender{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    int tag  = [tap view].tag;

    if (tag == 1) {
        
        MyGuanZhuTableViewController *myGuanZhu = [[MyGuanZhuTableViewController alloc]init];
        [self.navigationController pushViewController:myGuanZhu animated:YES];

    }
    else if (tag == 2) {
        
        MyFansTableViewController *myFans = [[MyFansTableViewController alloc]init];
        [self.navigationController pushViewController:myFans animated:YES];
        
    }
    else if (tag == 3) {
        
        MyMessageTableViewController *myMessage = [[MyMessageTableViewController alloc]init];
        [self.navigationController pushViewController:myMessage animated:YES];
        
    }
    else if (tag == 4) {
        
        MyDingGeTableViewController *myDingGe = [[MyDingGeTableViewController alloc]init];
        [self.navigationController pushViewController:myDingGe animated:YES];
        
    }
    else if (tag ==5 ) {
        
        MyLookTableViewController *myLook = [[MyLookTableViewController alloc]init];
        [self.navigationController pushViewController:myLook animated:YES];
        
    }
    else if (tag == 6) {
        
        CollectionViewController *myCollection = [[CollectionViewController alloc]init];
        [self.navigationController pushViewController:myCollection animated:YES];
        
    }
    else if (tag == 7) {
        
        MyRecMovieTableViewController *myRecMovie = [[MyRecMovieTableViewController alloc]init];
        [self.navigationController pushViewController:myRecMovie animated:YES];
        
    }
    else if (tag == 8) {
        
        MyEvaluationTableViewController *myEva = [[MyEvaluationTableViewController alloc]init];
        [self.navigationController pushViewController:myEva animated:YES];
        
    }
    else if (tag == 9) {
        
        MySettingTableViewController *mySetting = [[MySettingTableViewController alloc]init];
        [self.navigationController pushViewController:mySetting animated:YES];
        
    }
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

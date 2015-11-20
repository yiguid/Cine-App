//
//  MyTableViewController.m
//  cine
//
//  Created by Guyi on 15/11/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MyTableViewController.h"
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
#import "HeadView.h"
#import "headViewModel.h"


@interface MyTableViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    //取消分割线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //设置导航栏
    [self setNav];
    //设置tabview顶部视图
    [self setHeaderView];
}

/**
 * 设置tabview顶部视图
 */
- (void)setHeaderView{
    headViewModel *model = [[headViewModel alloc]init];
    model.backPicture = [NSString stringWithFormat:@"backImg.png"];
    model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
    model.name = [NSString stringWithFormat:@"哈哈哈"];
    model.mark = [NSString stringWithFormat:@"哈哈哈好好好好好"];
    HeadView *headView = [[HeadView alloc]init];
    headView.frame = CGRectMake(0, 0, wScreen, 180);
    [headView setup:model];
    self.tableView.tableHeaderView = headView;

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section == 0){
        self.tableView.sectionHeaderHeight = 2;
        
        return 3;
    }   else if (section == 1)
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
    
        MyStaticTableViewCell *cellStatic = [tableView dequeueReusableCellWithIdentifier:@"StaticCell"];
        cellStatic.lineView.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:211.0/255 alpha:1.0];
       
        
        [cellStatic.title setTextColor:[UIColor colorWithRed:117.0/255 green:117.0/255 blue:109.0/255 alpha:1.0]];
        cellStatic.contentView.frame = CGRectMake(5, 0, self.view.bounds.size.width - 10, 54);
        if(indexPath.section == 0)
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
            else if(indexPath.section == 1){
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


// 跳转界面
- (void)nextController :(id)sender{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    long tag  = [tap view].tag;

    if (tag == 1) {
        
        MyGuanZhuTableViewController *myGuanZhu = [[MyGuanZhuTableViewController alloc]init];
        myGuanZhu.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myGuanZhu animated:YES];

    }
    else if (tag == 2) {
        
        MyFansTableViewController *myFans = [[MyFansTableViewController alloc]init];
        myFans.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myFans animated:YES];
        
    }
    else if (tag == 3) {
        
        MyMessageTableViewController *myMessage = [[MyMessageTableViewController alloc]init];
        myMessage.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myMessage animated:YES];
        
    }
    else if (tag == 4) {
        
        MyDingGeTableViewController *myDingGe = [[MyDingGeTableViewController alloc]init];
        myDingGe.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myDingGe animated:YES];
        
    }
    else if (tag ==5 ) {
        
        MyLookTableViewController *myLook = [[MyLookTableViewController alloc]init];
        myLook.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myLook animated:YES];
        
    }
    else if (tag == 6) {
        
        CollectionViewController *myCollection = [[CollectionViewController alloc]init];
        myCollection.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myCollection animated:YES];
        
    }
    else if (tag == 7) {
        
        MyRecMovieTableViewController *myRecMovie = [[MyRecMovieTableViewController alloc]init];
        myRecMovie.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myRecMovie animated:YES];
        
    }
    else if (tag == 8) {
        
        MyEvaluationTableViewController *myEva = [[MyEvaluationTableViewController alloc]init];
        myEva.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myEva animated:YES];
        
    }
    else if (tag == 9) {
        
        MySettingTableViewController *mySetting = [[MySettingTableViewController alloc]init];
        mySetting.hidesBottomBarWhenPushed = YES;

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

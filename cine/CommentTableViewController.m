//
//  CommentTableViewController.m
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CommentTableViewController.h"
#import "ShuoXiImgTableViewCell.h"
#import "ShuoXiImgModel.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"

@interface CommentTableViewController ()
@property NSMutableArray *dataSource;

@end

@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.title = @"说戏#霍比特人#详情";
    self.dataSource = [[NSMutableArray alloc]init];
    
//        UIView *footView  = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
//        footView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:footView];
//        self.tableView.tableFooterView = footView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSString *ID = [NSString stringWithFormat:@"ShuoxiImg"];
        
        ShuoXiImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[ShuoXiImgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        ShuoXiImgModel *modelImg = [[ShuoXiImgModel alloc]init];
        modelImg.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
        modelImg.movieName = [NSString stringWithFormat:@"霍比特人"];
        modelImg.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地)"];
        modelImg.title = [NSString stringWithFormat:@"评论列表"];
        [self.dataSource addObject:modelImg];
        
        [cell setup:self.dataSource[indexPath.row]];
        
        // Configure the cell...
        
        return cell;
    }
    else{
        NSString *ID = [NSString stringWithFormat:@"ShuoxiContent"];
        
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        CommentModel *model = [[CommentModel alloc]init];
        model.nickName = [NSString stringWithFormat:@"霍比特人"];
        model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
        model.comment = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
        model.time = [NSString stringWithFormat:@"1小时前"];
        model.zambiaImg = [NSString stringWithFormat:@"follow.png"];
        model.zambiaCounts = @"600";
        
        [self.dataSource addObject:model];
        
        
        [cell setup:self.dataSource[indexPath.row]];
        
        return  cell;
        
        
    }
    return nil;
    
}
//- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footView  = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60)];
//    footView.backgroundColor = [UIColor redColor];
//    
//    self.tableView.tableHeaderView = footView;
//    return self.tableView;
//}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 190;
    }
    else{
        return 150;
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

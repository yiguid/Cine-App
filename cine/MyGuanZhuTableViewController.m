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


@interface MyGuanZhuTableViewController ()
@property NSMutableArray *dataSource;
@end

@implementation MyGuanZhuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"我关注的人";
    self.dataSource = [[NSMutableArray alloc]init];
    [self loadData];
}

- (void)loadData {
    for (int i = 0; i < 10; i++) {
        GuanZhuModel *model = [[GuanZhuModel alloc] init];
        model.avatarImg = @"avatar@2x.png";
        model.nickname = [NSString stringWithFormat:@"%@%d",@"哈哈哈",i];
        model.content = @"内容内容内容内容内容内容";
        model.rightBtn = @"cine@2x.png";
        [self.dataSource addObject:model];
    }
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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 //   NSString *ID = [NSString stringWithFormat:@"GuanZhuFirst"];
//    GuanZhuFirstTableViewCell *cell = [[GuanZhuFirstTableViewCell alloc]init];
 //   if (indexPath.row >= 0 && indexPath.row < 4)
        
//        NSString *ID = [NSString stringWithFormat:@"cell"];
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//
//            
//            cell.textLabel.text = @"哈哈哈";
//            cell.detailTextLabel.text = @"好好好好好好";
//            cell.imageView.image = [UIImage imageNamed:@"shareImg.png"];
//       }
    
    
    NSString *ID = [NSString stringWithFormat:@"GuanZhu"];
    GuanZhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[GuanZhuTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    [cell setup:self.dataSource[indexPath.row]];
    return cell;
    
    
    
    
    
 //   return nil;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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

//
//  ShuoxiTableViewController.m
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ShuoxiTableViewController.h"
#import "ShuoXiImgTableViewCell.h"
#import "ShuoXiImgModel.h"
#import "ShuoXiContentTableViewCell.h"
#import "ShuoXiContentModel.h"
#import "CommentTableViewController.h"
#import "MLStatusFrame.h"


@interface ShuoxiTableViewController ()
@property NSMutableArray *dataSource;
//@property(nonatomic, strong)NSArray *statusFrames;

@end

@implementation ShuoxiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"说戏详情";
 //   self.statusFrames = [[NSMutableArray alloc]init];

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       
       NSForegroundColorAttributeName:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]}];
    
    self.dataSource = [[NSMutableArray alloc]init];
 //   [self loadData];
}

- (void)loadData{
  //  for (int i = 0; i < 10; i++ ) {
        ShuoXiImgModel *modelImg = [[ShuoXiImgModel alloc]init];
        modelImg.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
        modelImg.movieName = [NSString stringWithFormat:@"霍比特人"];
        modelImg.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地)"];
        modelImg.title = [NSString stringWithFormat:@"匠人说戏(%d)",8];
        [self.dataSource addObject:modelImg];
        
        
        ShuoXiContentModel *model = [[ShuoXiContentModel alloc]init];
        model.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
        model.nickName = [NSString stringWithFormat:@"霍比特人"];
        model.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地)"];
        model.daRen = [NSString stringWithFormat:@"crown.png"];
        model.daRen = @"达人";
        model.mark = [NSString stringWithFormat:@"(著名导演,编剧)"];
        model.time = [NSString stringWithFormat:@"1小时前"];
        //     model.seeCount = @"1000";
        model.zambiaImg = [NSString stringWithFormat:@"follow.png"];
        model.zambiaCount = @"600";
        model.answerImg = [NSString stringWithFormat:@"follow.png"];
        model.answerCount = @"50";
        model.screenImg = [NSString stringWithFormat:@"follow.png"];
        
        [self.dataSource addObject:model];

  //  }
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
#warning Incomplete implementation, return the number of rows
//    if (section == 0) {
//        return 1;
//    }
    return 10;
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
        modelImg.title = [NSString stringWithFormat:@"匠人说戏(%d)",8];
        [self.dataSource addObject:modelImg];
        
        [cell setup:self.dataSource[indexPath.row]];
    
        // Configure the cell...
    
        return cell;
    }
    else{
        NSString *ID = [NSString stringWithFormat:@"ShuoxiContent"];
        
        ShuoXiContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[ShuoXiContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        ShuoXiContentModel *model = [[ShuoXiContentModel alloc]init];
        model.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
        model.nickName = [NSString stringWithFormat:@"霍比特人"];
        model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
        model.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
        model.daRenImg = [NSString stringWithFormat:@"crown.png"];
        model.daRen = @"达人";
        model.mark = [NSString stringWithFormat:@"(著名导演,编剧)"];
        model.time = [NSString stringWithFormat:@"1小时前"];
        //     model.seeCount = @"1000";
        model.zambiaImg = [NSString stringWithFormat:@"follow.png"];
        model.zambiaCount = @"600";
        model.answerImg = [NSString stringWithFormat:@"follow.png"];
        model.answerCount = @"50";
        model.screenImg = [NSString stringWithFormat:@"follow.png"];
        
        [self.dataSource addObject:model];
        

        [cell setup:self.dataSource[indexPath.row]];
        
    //     cell.statusFrame = self.statusFrames[indexPath.row];

        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentController)];
        [cell.contentView addGestureRecognizer:tap];
        
        return  cell;


    }
    return nil;
    
   }
//说戏三级详情界面
- (void) contentController{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;

    
    CommentTableViewController *comment = [[CommentTableViewController alloc]init];
    [self.navigationController pushViewController:comment animated:YES];
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
         return 190;
    }
    else{
//        MLStatusFrame *statusFrame = self.statusFrames[indexPath.row];
//        return statusFrame.cellHeight;
        return 400;
    }
   
}
//#pragma mark - 实现代理方法
////自定义没个cell的高度
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    // 取出这行对应的frame模型
//    
//}

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

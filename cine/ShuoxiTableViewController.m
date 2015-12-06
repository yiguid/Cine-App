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
//#import "CommentTableViewController.h"
#import "ShuoxiViewController.h"
#import "ShuoXiModel.h"
#import "ShuoXiCell.h"
#import "ShuoXiModelFrame.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "CommentTableViewCell.h"
@interface ShuoxiTableViewController ()
@property(nonatomic, strong)NSArray *statusFrames;
@property NSMutableArray *dataSource;

@end

@implementation ShuoxiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"说戏详情";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    self.dataSource = [[NSMutableArray alloc]init];
}

//-(NSArray *)statusFrames{
//    if (_statusFrames == nil) {
//        //将dictArray里面的所有字典转成模型,放到新的数组里
//        NSMutableArray *statusFrames = [NSMutableArray array];
//        for (int i = 0; i < 10; i++ ) {
//            
//            //创建MLStatus模型
//            MLStatus *status = [[MLStatus alloc]init];
//            status.text = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
//            status.icon = [NSString stringWithFormat:@"avatar@2x.png"];
//            status.name = [NSString stringWithFormat:@"霍比特人"];
//            status.picture = [NSString stringWithFormat:@"shuoxiImg.png"];
//            status.daRenTitle = @"达人";
//            status.mark = [NSString stringWithFormat:@"(著名导演,编剧)"];
//            status.time = [NSString stringWithFormat:@"1小时前"];
//            status.zambiaCount = @"600";
//            status.answerCount = @"50";
//
//            //创建MLStatusFrame模型
//            MLStatusFrame *statusFrame = [[MLStatusFrame alloc]init];
//            statusFrame.status = status;
//            [statusFrame setStatus:status];
//            [statusFrames addObject:statusFrame];
//            
//        }
//        _statusFrames = statusFrames;
//    }
//    return _statusFrames;
//}

-(NSArray *)statusFrames{
    if (_statusFrames == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (int i = 0; i < 10; i++ ) {
            
            //创建MLStatus模型
            CommentModel *model = [[CommentModel alloc]init];
            model.comment= [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
            model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
            model.nickName = [NSString stringWithFormat:@"霍比特人"];
            model.time = [NSString stringWithFormat:@"1小时前"];
            model.zambiaCounts = @"600";
            
            //创建MLStatusFrame模型
            CommentModelFrame *modelFrame = [[CommentModelFrame alloc]init];
            modelFrame.model = model;
            [modelFrame setModel:model];
            [statusFrames addObject:modelFrame];
            
        }
        _statusFrames = statusFrames;
    }
    return _statusFrames;
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

    return self.statusFrames.count;
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
        
        return cell;
    }
    else{
        
//        //创建cell
//        MLStatusCell *cell = [MLStatusCell cellWithTableView:tableView];
//        //设置高度
//        cell.statusFrame = self.statusFrames[indexPath.row];
        
        //创建cell
        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
        //设置高度
        cell.modelFrame = self.statusFrames[indexPath.row];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentController)];
        [cell.contentView addGestureRecognizer:tap];
        //返回cell
        return  cell;

    }
    return nil;
    
   }
//说戏三级详情界面
- (void) contentController{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;

    
    ShuoxiViewController *shuoxi = [[ShuoxiViewController alloc]init];
    shuoxi.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shuoxi animated:YES];
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
         return 190;
    }
    else{
        CommentModelFrame *modelFrame = self.statusFrames[indexPath.row];
        return modelFrame.cellHeight;
    }
   
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
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

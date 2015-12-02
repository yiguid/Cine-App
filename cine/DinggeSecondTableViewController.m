//
//  DinggeSecondTableViewController.m
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "DinggeSecondTableViewController.h"
#import "DingGeSecondTableViewCell.h"
#import "DingGeSecondModel.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"


@interface DinggeSecondTableViewController (){

    DingGeSecondModel * DingGe;
 


}
@property NSMutableArray *dataSource;
@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic, strong)NSMutableArray * DingArr;
@end

@implementation DinggeSecondTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.title = @"定格详情界面";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataSource = [[NSMutableArray alloc]init];
  
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
    NSString *url = @"http://fl.limijiaoyin.com:1337/post";
     
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
         NSLog(@"111111---------%@",responseObject);
    
        
        [self.tableView reloadData];
        
       
        
        
        
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];


    
    
    

}


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

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
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
        
        NSString *ID = [NSString stringWithFormat:@"Dingge"];

        DingGeSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
         if (cell == nil) {
            cell = [[DingGeSecondTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }

        DingGeSecondModel *model = [[DingGeSecondModel alloc]init];
        model.nikeName = @"修远";
        model.comment = @"这是我看过最好看的电影";
        model.movieImg = [NSString stringWithFormat:@"backImg.png"];
        
        model.userImg = [NSString stringWithFormat:@"avatar.png"];
        model.time = @"1小时";
        model.title = @"评论列表";
        [self.dataSource addObject:model];
        [cell setup:self.dataSource[indexPath.row]];
        
        return cell;

    }
    
    else{
        //创建cell
        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
        //设置高度
        cell.modelFrame = self.statusFrames[indexPath.row];
        
        return  cell;

        
    }

    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 300;
    }
    else{
        CommentModelFrame *modelFrame = self.statusFrames[indexPath.row];
        return modelFrame.cellHeight;
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

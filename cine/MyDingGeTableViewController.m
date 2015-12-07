//
//  MyDingGeTableViewController.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MyDingGeTableViewController.h"
#import "DingGeModel.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModelFrame.h"
#import "MJExtension.h"
@interface MyDingGeTableViewController ()
@property(nonatomic, strong)NSArray *statusFrames;

@end

@implementation MyDingGeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.title = @"我的定格";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    

}

-(NSArray *)statusFrames{
    if (_statusFrames == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *statusFrames = [NSMutableArray array];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = @"http://fl.limijiaoyin.com:1337/post";
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        
        [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success---------");
            NSLog(@"%@",responseObject);
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            
            
        }];
        for (int i = 0; i < 10; i++ ) {
            
            //创建MLStatus模型
            DingGeModel *status = [[DingGeModel alloc]init];
            status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
            status.userImg = [NSString stringWithFormat:@"avatar.png"];
            status.nikeName = [NSString stringWithFormat:@"霍比特人"];
            status.movieImg = [NSString stringWithFormat:@"backImg.png"];
            status.seeCount = @"600";
            status.zambiaCount = @"600";
            status.answerCount = @"50";
            status.movieName = @"<<泰囧>>";
            status.time = [NSString stringWithFormat:@"1小时前"];

            //创建MLStatusFrame模型
            DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
            statusFrame.model = status;
            [statusFrame setModel:status];
            [statusFrames addObject:statusFrame];
            
        }
        _statusFrames = statusFrames;
    }
    return _statusFrames;
}

- (void)viewWillAppear:(BOOL)animated{
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
    
    //创建cell
    MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
    //设置高度
    cell.modelFrame = self.statusFrames[indexPath.row];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentController)];
//    [cell.contentView addGestureRecognizer:tap];
    //返回cell
    return  cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DingGeModelFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;

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

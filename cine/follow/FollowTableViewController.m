//
//  FollowTableViewController.m
//  cine
//
//  Created by Guyi on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "FollowTableViewController.h"
#import "AddPersonViewController.h"
//#import "HMSegmentedControl.h"
#import "DingGeModel.h"
#import "MyDingGeTableViewCell.h"
#import "PublishViewController.h"
#import "DingGeModelFrame.h"
#import "RecMovieTableViewCell.h"
#import "RecModel.h"

@interface FollowTableViewController ()
@property(nonatomic, strong)NSMutableArray *statusFrames;
@end

@implementation FollowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setNav];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
  //  self.statusFrames = [[NSMutableArray alloc]init];
    
 }
-(NSArray *)statusFrames{
    if (_statusFrames == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (int i = 0; i < 10; i++ ) {
            
            //创建MLStatus模型
            DingGeModel *status = [[DingGeModel alloc]init];
            status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
            status.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
            status.nikeName = [NSString stringWithFormat:@"霍比特人"];
            status.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
            status.time = @"1小时前";
            status.seeCount = @"600";
            status.zambiaCount = @"600";
            status.answerCount = @"50";
            
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row >= 0 && indexPath.row < 5) {
//        NSString *ID = @"recMovie";
//        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//        if (cell == nil) {
//            cell = [[RecMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:ID];
//            RecModel *model = [[RecModel alloc]init];
//            model.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
//            model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
//            model.nikeName = @"哈哈";
//            model.appCount = @"1000人 感谢";
//            model.time = @"1小时前";
//            model.text = @"哈哈哈和哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈和";
//            model.title = @"视觉好";
//            model.movieName = @"<<泰囧>>";
//            [self.statusFrames addObject:model];
//            cell.model = self.statusFrames[indexPath.row];
//            return cell;
//        }
//    }
 //   else{
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        
        //创建MLStatus模型
//        DingGeModel *status = [[DingGeModel alloc]init];
//        status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
//        status.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
//        status.nikeName = [NSString stringWithFormat:@"霍比特人"];
//        status.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
//        status.seeCount = @"600";
//        status.zambiaCount = @"600";
//        status.answerCount = @"50";
//        
//        //创建MLStatusFrame模型
//        DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
//        statusFrame.model = status;
//        [statusFrame setModel:status];
//        [self.statusFrames addObject:statusFrame];

        //设置高度
        cell.modelFrame = self.statusFrames[indexPath.row];
        return cell;
//    }
//    return nil;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row >= 0 && indexPath.row < 5) {
//        return 300;
//    }
//    else{
        DingGeModelFrame *statusFrame = self.statusFrames[indexPath.row];
        return statusFrame.cellHeight;
  //  }
}


- (IBAction)follow:(id)sender {
 //   NSLog(@"open follow scene",nil);
}

- (IBAction)publish:(id)sender {
 //   NSLog(@"open publish scene",nil);
    
    PublishViewController *publishview = [[PublishViewController alloc]init] ;
    // 创建发布页面导航控制器
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:publishview] ;
 //   navigation.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishview animated:YES] ;
    
    
}

- (IBAction)addPerson:(UIButton *)sender {
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    AddPersonViewController *addPer = [[AddPersonViewController alloc]init];
    addPer.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addPer animated:YES];
}
@end

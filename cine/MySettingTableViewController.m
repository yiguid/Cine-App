//
//  MySettingTableViewController.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MySettingTableViewController.h"
#import "AboutCineViewController.h"
#import "CineFeedBackViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
@interface MySettingTableViewController ()

@end

@implementation MySettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的设置";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIButton *signOut = [[UIButton alloc]initWithFrame:CGRectMake(20, 260, self.view.frame.size.width - 40, 30)];
    [signOut setTitle:@"退出" forState:UIControlStateNormal];
    [self modifyUIButton:signOut];
    [signOut addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signOut];
}

- (void)modifyUIButton: (UIButton *) button {
    button.backgroundColor = [UIColor grayColor];
    CGRect rect = button.frame;
    rect.size.height = 50;
    button.frame = rect;
    button.layer.cornerRadius = 6.0;
}

- (void)loginOut{
    //清空user defaults
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys])
    {
        NSLog(@"%@",key);
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    [animation setType:kCATransitionFade]; //淡入淡出kCATransitionFade
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginScene"];
    self.view.window.rootViewController = loginVC;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = YES;
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 计算缓存大小
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        self.tableView.sectionHeaderHeight = 2;
        
        return 3;
    }
    else{
        self.tableView.sectionHeaderHeight = 2;
        
        return 1;
    
    
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = [NSString stringWithFormat:@"cell"];
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"清理缓存";
            cell.textLabel.font = TextFont;
            cell.textLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0];
            cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
            
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, wScreen, 1)];
            
            headView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];

            
            [cell.contentView addSubview:headView];
            
            
            
            SDImageCache * Cache = [[SDImageCache alloc]init];
            
            NSUInteger size = [Cache getSize];
          
            
            

           cell.detailTextLabel.text = [NSString stringWithFormat:@"%luM",size];

            cell.detailTextLabel.font = TextFont;
            
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"关于cine";
            cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
            cell.textLabel.font = TextFont;
            cell.textLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0];
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, wScreen, 1)];
            
            headView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
            
             [cell.contentView addSubview:headView];
            
           
            
        }
        else
        {
            cell.textLabel.text = @"意见反馈";
            cell.textLabel.font = TextFont;
            cell.textLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0];
            cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        }

    }else{
    
        cell.textLabel.text = @"给我评分";
        cell.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];
        cell.textLabel.font = TextFont;
        cell.textLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0];
       cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    
    }

    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //隐藏顶部的分割线
    UIView *headView = [[UIView alloc]init];
    
    headView.backgroundColor = [UIColor whiteColor];
    
    
    return headView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 20;
    }else{
    
        return 10;
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        self.navigationItem.backBarButtonItem = back;
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            
            UIAlertView *alert;
            alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定清理缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            
            
        }else if (indexPath.row==1) {
            AboutCineViewController *aboutCine = [[AboutCineViewController alloc] init];
            [self.navigationController pushViewController:aboutCine animated:YES];
        }else if (indexPath.row==2){
            
            CineFeedBackViewController * feedback = [[CineFeedBackViewController alloc]init];
            [self.navigationController pushViewController:feedback animated:YES];
            
        }

    }
    
    


}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
        if(buttonIndex == 1){
    
        [[SDImageCache sharedImageCache] clearDisk];
            
        [[SDImageCache sharedImageCache] clearMemory];//可有可无
            
     
            
            
            [self.tableView reloadData];
            
            
            NSLog(@"内存清理成功");
            
            [self.tableView reloadData];
        
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

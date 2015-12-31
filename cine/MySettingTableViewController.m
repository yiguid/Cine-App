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
@interface MySettingTableViewController (){

    float size_m;

}
@end

@implementation MySettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的设置";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIButton *signOut = [[UIButton alloc]initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 30)];
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
 - (NSString *)getCacheSize
 {
    //定义变量存储总的缓存大小
     long long sumSize = 0;
 
        //01.获取当前图片缓存路径
         NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
         //02.创建文件管理对象
         NSFileManager *filemanager = [NSFileManager defaultManager];
    
             //获取当前缓存路径下的所有子路径
         NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    
         //遍历所有子文件
         for (NSString *subPath in subPaths) {
                     //1）.拼接完整路径
                 NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
                     //2）.计算文件的大小
                 long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
                     //3）.加载到文件的大小
                 sumSize += fileSize;
             }
         size_m = sumSize/(1000*1000);
     
     
         return [NSString stringWithFormat:@"%.2fM",size_m];
     
  
    
     }





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = [NSString stringWithFormat:@"cell"];
    
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"清理缓存";
        
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",size_m];
        
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"关于cine";
        cell.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];

    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"意见反馈";
    }
    else
    {
        cell.textLabel.text = @"给我评分";
        cell.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];

    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        self.navigationItem.backBarButtonItem = back;
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
        if(buttonIndex == 1){
    
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
            [fileManager removeItemAtPath:cacheFilePath error:nil];
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

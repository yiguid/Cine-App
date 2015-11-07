//
//  MySettingTableViewController.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MySettingTableViewController.h"
#import "AboutCineViewController.h"


@interface MySettingTableViewController ()

@end

@implementation MySettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的设置";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIButton *signOut = [[UIButton alloc]initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 30)];
    [signOut setTitle:@"退出" forState:UIControlStateNormal];
//    signOut.layer.masksToBounds = YES;
//    signOut.layer.cornerRadius = 8.0;
//    [signOut setBackgroundColor:[UIColor redColor]];
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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = [NSString stringWithFormat:@"cell"];
    
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"清理缓存";
        cell.detailTextLabel.text = @"21M";
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"关于cine";
        cell.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
        [cell.contentView addGestureRecognizer:tap];
        UIView *tagView = [tap view];
        tagView.tag = 1;
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

- (void)nextController :(id)sender{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    int tag  = [tap view].tag;
    
    if (tag == 1) {
        AboutCineViewController *aboutCine = [[AboutCineViewController alloc] init];
        [self.navigationController pushViewController:aboutCine animated:YES];
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

//
//  MovieTableViewController.m
//  cine
//
//  Created by Mac on 15/11/19.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MovieTableViewController.h"
#import "MovieModel.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "ShuoXiImgTableViewCell.h"
#import "ShuoXiImgModel.h"
#import "MovieViewController.h"
#import "MJExtension.h"
#import "AFNetworking.h"


#define tablewH self.view.frame.size.height-230

@interface MovieTableViewController () <ChooseMovieViewDelegate>
@property(nonatomic, strong)NSArray *statusFrames;
@property NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray * moviearr;

@end

@implementation MovieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"说戏#%@#详情",self.ID);
    self.title = self.name;
    
   
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = [[NSMutableArray alloc]init];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    //获取服务器数据
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",@"http://fl.limijiaoyin.com:1337/movie/",self.ID];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        //NSLog(@"%@",responseObject);
        
        
        
        
        MovieModel * movie = [MovieModel mj_objectWithKeyValues:responseObject];
        
        
        self.moviearr = ((AFHTTPRequestOperation *)operation).responseObject;
        
        NSLog(@"-------121212%@",self.moviearr);
        
        [self.mytableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
  
    
}

#pragma 定义tableview
- (void) settabController{
    self.mytableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 220, wScreen,tablewH)];
    
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mytableView.dataSource = self;

    self.mytableView.delegate = self;
    
    [self.tableView addSubview:self.mytableView];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(NSArray *)statusFrames{
//    if (_statusFrames == nil) {
//        //将dictArray里面的所有字典转成模型,放到新的数组里
//        NSMutableArray *statusFrames = [NSMutableArray array];
//        for (int i = 0; i < 10; i++ ) {
//            
//            //创建MLStatus模型
//            
//            
//        }
//        _statusFrames = statusFrames;
//    }
//    return _statusFrames;
//}
//

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.statusFrames.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0) {
//        
//        
//        NSString *ID = [NSString stringWithFormat:@"ShuoxiImg"];
//        
//        ShuoXiImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//        if (cell == nil) {
//            cell = [[ShuoXiImgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//        }
//        
//
//        
//                ShuoXiImgModel *modelImg = [[ShuoXiImgModel alloc]init];
//                modelImg.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
//                modelImg.movieName = [NSString stringWithFormat:@"霍比特人"];
//                modelImg.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地)"];
//                modelImg.title = [NSString stringWithFormat:@"评论列表"];
//      
//        
//        
//                
//        
//                [self.dataSource addObject:modelImg];
//        
//                [cell setup:self.dataSource[indexPath.row]];
//        
//
//        
//        
//        
//        // Configure the cell...
//        
//        return cell;
//    }
//    else{
//        //创建cell
//        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
//        //设置高度
//        cell.modelFrame = self.statusFrames[indexPath.row];
//        
//        return  cell;
//        
//        
//    }
//    return nil;

//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        static NSString * CellIndentifier = @"CellTableIdentifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
      
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 40, 35)];
    nameLabel.tag = 11;
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorWithRed:255 green:105.0f/255.0f blue:0.0f alpha:1.0f];
    
    [cell.contentView addSubview:nameLabel];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
  }


    ((UILabel *)[cell.contentView viewWithTag:11]).text = ((MovieModel *)self.moviearr[indexPath.row]).title;




    return cell;

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


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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

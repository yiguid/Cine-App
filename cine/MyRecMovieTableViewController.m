//
//  MyRecMovieTableViewController.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MyRecMovieTableViewController.h"
#import "RecModel.h"
#import "RecMovieTableViewCell.h"
#import "RestAPI.h"
#import "RecommendSecondViewController.h"
#import "TadeTableViewController.h"
#import "MovieTableViewController.h"
@interface MyRecMovieTableViewController ()
@property NSMutableArray *dataSource;

@end

@implementation MyRecMovieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"我的推荐";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataSource = [[NSMutableArray alloc]init];
    [self loadData];
    [self setupHeader];
    [self setupFooter];
}

-(void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user"] = userId;
    param[@"sort"] = @"createdAt DESC";
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.dataSource = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSString *ID = [NSString stringWithFormat:@"Rec"];
    RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[RecMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    [cell setup:self.dataSource[indexPath.row]];
    
     RecModel *model = self.dataSource[indexPath.row];
    
    
    cell.userImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
    
    [cell.userImg addGestureRecognizer:tapGesture];
    
    
    UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moviebtn:)];
    
    [cell.movieName addGestureRecognizer:movieGesture];
    
    
//    [cell.screenBtn addTarget:self action:@selector(screenbtn:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.contentView addSubview:cell.screenBtn];
    
    if (model.thankCount == nil) {
        [cell.appBtn setTitle:[NSString stringWithFormat:@"0人 感谢"] forState:UIControlStateNormal];
    }
    [cell.appBtn setTitle:[NSString stringWithFormat:@"%@人 感谢",model.thankCount] forState:UIControlStateNormal];
    [cell.appBtn addTarget:self action:@selector(thankBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.appBtn];

    
    
    cell.layer.borderWidth = 10;
    cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
    //        cell.separatorColor = [UIColor redColor];//设置行间隔边框
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    if (self.dataSource.count==0) {
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3@2x.png"]];
        [tableView setBackgroundView:backgroundView];
    }
    

    
    
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//        RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
//    
//        
//        RecModel *model = self.dataSource[indexPath.row];
//        
//        rec.recimage = model.image;
//        rec.recID  = model.recId;
//    
//             
//        
//        [self.navigationController pushViewController:rec animated:YES];
//    
//    
//}


-(void)thankBtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.dataSource[indexPath.row];
    
    
    
    NSInteger thank = [model.thankCount integerValue];
    thank = thank+1;
    model.thankCount = [NSString stringWithFormat:@"%ld",thank];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/thank/recommend/%@",BASE_API,userId,model.recId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"感谢成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
}




-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.dataSource[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.dataSource[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
}

//-(void)screenbtn:(UIButton *)sender{
//    
//    UIButton * btn = (UIButton *)sender;
//    
//    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
//    
//    //获得点击了哪一行
//    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
//    
//    
//    
//    RecModel *model = self.dataSource[indexPath.row];
//    
//    
//    RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
//    
//    rec.hidesBottomBarWhenPushed = YES;
//    
//    
//    
//    rec.recimage = model.image;
//    rec.recID  = model.recId;
//    
//    
//    NSInteger see = [model.viewCount integerValue];
//    see = see+1;
//    model.viewCount = [NSString stringWithFormat:@"%ld",see];
//    
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    
//    NSString *token = [userDef stringForKey:@"token"];
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",REC_API,model.recId];
//    
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
//    [manager POST:url parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              
//              NSLog(@"成功,%@",responseObject);
//              [self.tableView reloadData];
//              
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              
//              NSLog(@"请求失败,%@",error);
//          }];
//    
//    
//    
//    
//    
//    [self.navigationController pushViewController:rec animated:YES];
//    
//    
//}





- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
    });
}



@end

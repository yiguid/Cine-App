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
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "TaTableViewController.h"
#import "DinggeSecondViewController.h"
@interface MyDingGeTableViewController (){
    
    NSMutableArray * DingGeArr;
}

@property(strong,nonatomic) NSMutableArray *DingArr;
@property(nonatomic, strong)NSArray *statusFramesDingGe;

@end

@implementation MyDingGeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.title = @"我的定格";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadDingGeData];
    [self Refresh];
    

}

- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user"] = userId;
   // NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"user":@"userId"};
    [manager GET:DINGGE_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             self.DingArr = DingGeArr;
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 //创建模型
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.seeCount = model.viewCount;
                 model.zambiaCount = model.voteCount;
                 model.answerCount = @"50";
                 //               NSLog(@"model.movie == %@",model.movie.title,nil);
                 model.movieName = model.movie.title;
                 model.nikeName = model.user.nickname;
                 model.time = [NSString stringWithFormat:@"1小时前"];
                 model.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
                 model.movieImg = [NSString stringWithFormat:@"backImg.png"];
                 //创建MianDingGeModelFrame模型
                 DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
                 statusFrame.model = model;
                 [statusFrame setModel:model];
                 [statusFrames addObject:statusFrame];
             }
             
             
             self.statusFramesDingGe = statusFrames;
             [self.tableView reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
         }];
}

//
//-(NSArray *)statusFrames{
//    if (_statusFrames == nil) {
//        //将dictArray里面的所有字典转成模型,放到新的数组里
//        NSMutableArray *statusFrames = [NSMutableArray array];
//        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSString *url = @"http://fl.limijiaoyin.com:1337/post";
//        
//        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//        
//        NSString *token = [userDef stringForKey:@"token"];
//        
//        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
//        
//        [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"success---------");
//            NSLog(@"%@",responseObject);
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%@",error);
//            
//            
//        }];
//        for (int i = 0; i < 10; i++ ) {
//            
//            //创建MLStatus模型
//            DingGeModel *status = [[DingGeModel alloc]init];
//            status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
//            status.userImg = [NSString stringWithFormat:@"avatar.png"];
//            status.nikeName = [NSString stringWithFormat:@"霍比特人"];
//            status.movieImg = [NSString stringWithFormat:@"backImg.png"];
//            status.seeCount = @"600";
//            status.zambiaCount = @"600";
//            status.answerCount = @"50";
//            status.movieName = @"<<泰囧>>";
//            status.time = [NSString stringWithFormat:@"1小时前"];
//
//            //创建MLStatusFrame模型
//            DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
//            statusFrame.model = status;
//            [statusFrame setModel:status];
//            [statusFrames addObject:statusFrame];
//            
//        }
//        _statusFrames = statusFrames;
//    }
//    return _statusFrames;
//}

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.statusFramesDingGe count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
    //设置cell
    cell.modelFrame = self.statusFramesDingGe[indexPath.row];
    
    
    UIImageView * imageView = [[UIImageView alloc]init];
    
    DingGeModel *model = self.DingArr[indexPath.row];
    
    NSString * string = model.image;
    
    [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
    
    
    [imageView setImage:cell.movieImg.image];
    
    [cell.contentView addSubview:imageView];
    
    cell.message.text = model.content;
    [cell.contentView addSubview:cell.message];
    
    //点击头像事件
    cell.userImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
    [cell.userImg addGestureRecognizer:tapGesture];
    
    
    //点赞
    [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
    [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.zambiaBtn];
    
    
    
    cell.message.text = model.content;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DingGeModelFrame *statusFrame = self.statusFramesDingGe[indexPath.row];
    return statusFrame.cellHeight;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
        
        dingge.hidesBottomBarWhenPushed = YES;
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        dingge.dingimage = model.image;
    
        dingge.DingID  = model.ID;
    
        
        
        [self.navigationController pushViewController:dingge animated:YES];
    
}




-(void)userbtn:(id)sender{
    
    
    TaTableViewController * taviewcontroller = [[TaTableViewController alloc]init];
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
    
    
}

-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[btn superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
    DingGeModel * model = [DingGeArr objectAtIndex:indexPath.row];
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",zan];
    
    [self.tableView reloadData];

}

-(void)Refresh
{
    self.refreshHeader.isEffectedByNavigationController = NO;
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.tableView];
    [refreshHeader addTarget:self refreshAction:@selector(headRefresh)];
    self.refreshHeader=refreshHeader;
    [refreshHeader autoRefreshWhenViewDidAppear];
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footRefresh)];
    self.refreshFooter=refreshFooter;
    
    
}
-(void)headRefresh
{
    [self.refreshHeader endRefreshing];
}

-(void)footRefresh
{
    [self.refreshFooter endRefreshing];
}


@end

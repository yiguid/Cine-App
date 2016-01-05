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
#import "TadeTableViewController.h"
#import "DinggeSecondViewController.h"
#import "MovieTableViewController.h"
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
    [self setupHeader];
    [self setupFooter];

    

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
                 NSInteger comments = model.comments.count;
                 NSString * com = [NSString stringWithFormat:@"%ld",comments];
                 model.answerCount = com;
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = YES;
    
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
    
    cell.userImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
    
    [cell.userImg addGestureRecognizer:tapGesture];
    
    
    UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moviebtn:)];
    
    [cell.movieName addGestureRecognizer:movieGesture];
    
    
    [cell.screenBtn addTarget:self action:@selector(screenbtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.screenBtn];
    
    
    [cell.answerBtn addTarget:self action:@selector(answerbtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.answerBtn];
    
    UITapGestureRecognizer * detailGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailBtn:)];
    
    [cell.tagEditorImageView.imagePreviews addGestureRecognizer:detailGesture];
    
    
    if (model.viewCount == nil) {
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
    }
    [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",model.viewCount] forState:UIControlStateNormal];
    [cell.seeBtn addTarget:self action:@selector(seebtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.seeBtn];
    
    
    [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
    [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.zambiaBtn];
    
    
    
    
    cell.tagEditorImageView.viewC = self;
    
    UIView *tempView = [[UIView alloc] init];
    [cell setBackgroundView:tempView];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.layer.borderWidth = 10;
    cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
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




-(void)screenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
 
    [self.navigationController pushViewController:dingge animated:YES];
    
    
}

-(void)seebtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    [self.navigationController pushViewController:dingge animated:YES];
    
    
}


-(void)answerbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    [self.navigationController pushViewController:dingge animated:YES];
    
    
}



-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    taviewcontroller.userimage = model.user.avatarURL ;
    taviewcontroller.nickname = model.user.nickname;
    

    
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
  
    
}



- (void)detailBtn:(UITapGestureRecognizer *)sender{
    
    
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    [self.navigationController pushViewController:dingge animated:YES];
}


-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/votecount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"点赞成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
}

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

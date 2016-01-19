//
//  HaopingTotalViewController.m
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "HaopingTotalViewController.h"
#import "ReviewTableViewCell.h"
#import "ReviewModel.h"
#import "ReviewSecondViewController.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MovieModel.h"
#import "RestAPI.h"
@interface HaopingTotalViewController (){
    
    
    UIView * shareview;
    UIView * sharetwoview;
    
}

@property NSMutableArray *dataSource;


@end

@implementation HaopingTotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"影片评价";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen-60) style:UITableViewStylePlain];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];

    [self loadData];
    [self setupHeader];
    [self setupFooter];
    [self shareData];
    [self sharetwoData];
}



-(void)shareData{
    
    shareview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen/2, wScreen, hScreen/3+50)];
    shareview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shareview];
    
    UILabel * sharlabel = [[UILabel alloc]initWithFrame:CGRectMake(wScreen/3,10, wScreen/3, 20)];
    sharlabel.text = @"分享至";
    sharlabel.textAlignment =NSTextAlignmentCenter;
    sharlabel.textColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.0];
    [shareview addSubview:sharlabel];
    
    
    CGFloat imgW = (wScreen-30)/4;
    
    UIButton * sharweixin = [[UIButton alloc]initWithFrame:CGRectMake(20,40, 40, 40)];
    [sharweixin setImage:[UIImage imageNamed:@"shareweixin@2x.png"] forState:UIControlStateNormal];
    
    [shareview addSubview:sharweixin];
    
    UILabel * sharweixinlabel = [[UILabel alloc]initWithFrame:CGRectMake(20,80, 40, 40)];
    sharweixinlabel.text = @"微信";
    sharweixinlabel.textAlignment = NSTextAlignmentCenter;
    sharweixinlabel.font = TextFont;
    [shareview addSubview:sharweixinlabel];
    
    
    
    UIButton * sharfriend = [[UIButton alloc]initWithFrame:CGRectMake(imgW+30,40, 40, 40)];
    [sharfriend setImage:[UIImage imageNamed:@"sharepengyou@2x.png"] forState:UIControlStateNormal];
    [shareview addSubview:sharfriend];
    
    
    UILabel * sharfriendlabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW+30,80, 40, 40)];
    sharfriendlabel.text = @"朋友圈";
    sharfriendlabel.textAlignment = NSTextAlignmentCenter;
    sharfriendlabel.font = TextFont;
    [shareview addSubview:sharfriendlabel];
    
    
    UIButton * sharxinlang = [[UIButton alloc]initWithFrame:CGRectMake(imgW*2+40,40, 40, 40)];
    [sharxinlang setImage:[UIImage imageNamed:@"shareweibo@2x.png"] forState:UIControlStateNormal];
    [shareview addSubview:sharxinlang];
    
    UILabel * sharxinlanglabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW*2+30,80,60, 40)];
    sharxinlanglabel.text = @"新浪微博";
    sharxinlanglabel.textAlignment = NSTextAlignmentCenter;
    sharxinlanglabel.font = TextFont;
    [shareview addSubview:sharxinlanglabel];
    
    UIButton * sharqq = [[UIButton alloc]initWithFrame:CGRectMake(imgW*3+50,40, 40, 40)];
    [sharqq setImage:[UIImage imageNamed:@"shareqq@2x.png"] forState:UIControlStateNormal];
    [shareview addSubview:sharqq];
    
    UILabel * sharqqlabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW*3+40,80,60, 40)];
    sharqqlabel.text = @"QQ空间";
    sharqqlabel.textAlignment = NSTextAlignmentCenter;
    sharqqlabel.font = TextFont;
    [shareview addSubview:sharqqlabel];
    
    
    
    UIView * sharfengexian = [[UIView alloc]initWithFrame:CGRectMake(20,120,wScreen-40, 1)];
    sharfengexian.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    [shareview addSubview:sharfengexian];
    
    
    UIButton * jubao = [[UIButton alloc]initWithFrame:CGRectMake(20,130, 40, 40)];
    [jubao setImage:[UIImage imageNamed:@"举报@2x.png"] forState:UIControlStateNormal];
    [shareview addSubview:jubao];
    
    UILabel * jubaolabel = [[UILabel alloc]initWithFrame:CGRectMake(20,170,40, 40)];
    jubaolabel.text = @"举报";
    jubaolabel.textAlignment = NSTextAlignmentCenter;
    jubaolabel.font = TextFont;
    [shareview addSubview:jubaolabel];
    
    UIButton * delete = [[UIButton alloc]initWithFrame:CGRectMake(imgW+30,130, 40, 40)];
    [delete setImage:[UIImage imageNamed:@"删除@2x.png"] forState:UIControlStateNormal];
    [shareview addSubview:delete];
    
    UILabel * deletelabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW+30,170,40, 40)];
    deletelabel.text = @"删除";
    deletelabel.textAlignment = NSTextAlignmentCenter;
    deletelabel.font = TextFont;
    [shareview addSubview:deletelabel];
    
    
    UIButton * cancel = [[UIButton alloc]initWithFrame:CGRectMake(20,210,wScreen-40,40)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = Name2Font;
    [cancel setTitleColor:[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0] forState: UIControlStateNormal];
    
    
    cancel.titleLabel.textColor = [UIColor blackColor];
    
    cancel.titleLabel.textColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    [cancel addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cancel.layer.borderColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0].CGColor;
    cancel.layer.borderWidth = 1;
    
    [shareview addSubview:cancel];
    
    cancel.layer.masksToBounds = YES;
    cancel.layer.cornerRadius = 4.0;
    
    
    shareview.hidden = YES;
    
    
}

-(void)sharetwoData{
    
    sharetwoview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen/2, wScreen, hScreen/3+50)];
    sharetwoview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sharetwoview];
    
    UILabel * sharlabel = [[UILabel alloc]initWithFrame:CGRectMake(wScreen/3,10, wScreen/3, 20)];
    sharlabel.text = @"分享至";
    sharlabel.textAlignment =NSTextAlignmentCenter;
    sharlabel.textColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.0];
    [sharetwoview addSubview:sharlabel];
    
    
    CGFloat imgW = (wScreen-30)/4;
    
    UIButton * sharweixin = [[UIButton alloc]initWithFrame:CGRectMake(20,40, 40, 40)];
    [sharweixin setImage:[UIImage imageNamed:@"shareweixin@2x.png"] forState:UIControlStateNormal];
    
    [sharetwoview addSubview:sharweixin];
    
    UILabel * sharweixinlabel = [[UILabel alloc]initWithFrame:CGRectMake(20,80, 40, 40)];
    sharweixinlabel.text = @"微信";
    sharweixinlabel.textAlignment = NSTextAlignmentCenter;
    sharweixinlabel.font = TextFont;
    [sharetwoview addSubview:sharweixinlabel];
    
    
    
    UIButton * sharfriend = [[UIButton alloc]initWithFrame:CGRectMake(imgW+30,40, 40, 40)];
    [sharfriend setImage:[UIImage imageNamed:@"sharepengyou@2x.png"] forState:UIControlStateNormal];
    [sharetwoview addSubview:sharfriend];
    
    
    UILabel * sharfriendlabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW+30,80, 40, 40)];
    sharfriendlabel.text = @"朋友圈";
    sharfriendlabel.textAlignment = NSTextAlignmentCenter;
    sharfriendlabel.font = TextFont;
    [sharetwoview addSubview:sharfriendlabel];
    
    
    UIButton * sharxinlang = [[UIButton alloc]initWithFrame:CGRectMake(imgW*2+40,40, 40, 40)];
    [sharxinlang setImage:[UIImage imageNamed:@"shareweibo@2x.png"] forState:UIControlStateNormal];
    [sharetwoview addSubview:sharxinlang];
    
    UILabel * sharxinlanglabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW*2+30,80,60, 40)];
    sharxinlanglabel.text = @"新浪微博";
    sharxinlanglabel.textAlignment = NSTextAlignmentCenter;
    sharxinlanglabel.font = TextFont;
    [sharetwoview addSubview:sharxinlanglabel];
    
    UIButton * sharqq = [[UIButton alloc]initWithFrame:CGRectMake(imgW*3+50,40, 40, 40)];
    [sharqq setImage:[UIImage imageNamed:@"shareqq@2x.png"] forState:UIControlStateNormal];
    [sharetwoview addSubview:sharqq];
    
    UILabel * sharqqlabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW*3+40,80,60, 40)];
    sharqqlabel.text = @"QQ空间";
    sharqqlabel.textAlignment = NSTextAlignmentCenter;
    sharqqlabel.font = TextFont;
    [sharetwoview addSubview:sharqqlabel];
    
    
    
    UIView * sharfengexian = [[UIView alloc]initWithFrame:CGRectMake(20,120,wScreen-40, 1)];
    sharfengexian.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    [sharetwoview addSubview:sharfengexian];
    
    
    //    UIButton * jubao = [[UIButton alloc]initWithFrame:CGRectMake(20,130, 40, 40)];
    //    [jubao setImage:[UIImage imageNamed:@"举报@2x.png"] forState:UIControlStateNormal];
    //    [shartwoview addSubview:jubao];
    //
    //    UILabel * jubaolabel = [[UILabel alloc]initWithFrame:CGRectMake(20,170,40, 40)];
    //    jubaolabel.text = @"举报";
    //    jubaolabel.textAlignment = NSTextAlignmentCenter;
    //    jubaolabel.font = TextFont;
    //    [shartwoview addSubview:jubaolabel];
    
    UIButton * delete = [[UIButton alloc]initWithFrame:CGRectMake(20,130, 40, 40)];
    [delete setImage:[UIImage imageNamed:@"删除@2x.png"] forState:UIControlStateNormal];
    [sharetwoview addSubview:delete];
    
    UILabel * deletelabel = [[UILabel alloc]initWithFrame:CGRectMake(20,170,40, 40)];
    deletelabel.text = @"删除";
    deletelabel.textAlignment = NSTextAlignmentCenter;
    deletelabel.font = TextFont;
    [sharetwoview addSubview:deletelabel];
    
    
    UIButton * cancel = [[UIButton alloc]initWithFrame:CGRectMake(20,210,wScreen-40,40)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = Name2Font;
    [cancel setTitleColor:[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0] forState: UIControlStateNormal];
    
    
    cancel.titleLabel.textColor = [UIColor blackColor];
    
    cancel.titleLabel.textColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    [cancel addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cancel.layer.borderColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0].CGColor;
    cancel.layer.borderWidth = 1;
    
    [sharetwoview addSubview:cancel];
    
    cancel.layer.masksToBounds = YES;
    cancel.layer.cornerRadius = 4.0;
    
    
    sharetwoview.hidden = YES;
    
    
}



-(void)cancelBtn:(id)sender{
    
    
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
}



-(void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"movie"] = self.movieID;
    param[@"sort"] = @"createdAt DESC";
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REVIEW_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.dataSource = [ReviewModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
}



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewModel *model = [self.dataSource objectAtIndex:indexPath.row];
    return [model getCellHeight];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //    self.tabBarController.tabBar.hidden = NO;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"REVIEW"];
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ReviewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    [cell setup:self.dataSource[indexPath.row]];
    ReviewModel * model = self.dataSource[indexPath.row];
    
    
    [cell.screenBtn addTarget:self action:@selector(screenbtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.screenBtn];
    
    
    [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
    [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.zambiaBtn];
    cell.layer.borderWidth = 10;
    cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
    //        cell.separatorColor = [UIColor redColor];//设置行间隔边框
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReviewSecondViewController * rev = [[ReviewSecondViewController alloc]init];
    
    
    ReviewModel *model = self.dataSource[indexPath.row];
    
    rev.revimage = model.image;
    rev.revID  = model.reviewId;
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",REVIEW_API,model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    
    
    [self.navigationController pushViewController:rev animated:YES];
    
    
}


-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
    
    ReviewModel *model = self.dataSource[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/votecount",REVIEW_API,model.reviewId];
    
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


-(void)screenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewModel *model = self.dataSource[indexPath.row];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        if (shareview.hidden==YES) {
            shareview.hidden = NO;
        }else{
            
            shareview.hidden = YES;
        }
        
        
        
    }
    else{
        
        if (sharetwoview.hidden==YES) {
            sharetwoview.hidden = NO;
        }else{
            
            sharetwoview.hidden = YES;
        }
        
        
        
    }
    
    
    
}







- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self loadData];
            
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

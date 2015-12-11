//
//  CineViewController.m
//  cine
//
//  Created by Guyi on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CineViewController.h"
#import "HMSegmentedControl.h"
#import "ShuoxiTableViewController.h"
#import "DinggeSecondViewController.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModelFrame.h"
#import "DingGeModel.h"
#import "ShuoXiModel.h"
#import "ShuoXiModelFrame.h"
#import "MyShuoXiTableViewCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MovieModel.h"
#import "RestAPI.h"
#import "TaTableViewController.h"

@interface CineViewController (){
    
    NSMutableArray * DingGeArr;
    NSMutableArray * ShuoXiArr;
   
    
}
@property(nonatomic,retain)IBOutlet UITableView *dingge;
@property(nonatomic,retain)IBOutlet UITableView *shuoxi;
@property(nonatomic, strong)NSArray *statusFramesDingGe;
@property(nonatomic, strong)NSArray *statusFramesShuoXi;
@property (nonatomic, strong) NSDictionary *dic;
@property MBProgressHUD *hud;

@end

@implementation CineViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add two table views
    //设置导航栏
    [self setNav];
    
    if (self.dingge) {
        self.title = @"";
    }else{
        
        self.title = @"";
        
    }
    
    
    self.dingge.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.shuoxi.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
    [self loadShuoXiData];
    [self loadDingGeData];
    [self.dingge setHidden:NO];
    [self.shuoxi setHidden:YES];
    
    
    
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"定格", @"说戏"]];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.frame = CGRectMake(0, 0, 200, 30);
    segmentedControl.selectionIndicatorHeight = 3.0f;
    segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]};
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
    
    [ShuoXiModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    
    
    [DingGeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];

    DingGeArr = [NSMutableArray array];
    ShuoXiArr = [NSMutableArray array];
    
    
    [self Refresh];
    

   
    
}

- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:DINGGE_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
        
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 //创建模型
                 DingGeModel *status = [[DingGeModel alloc]init];
                 //status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
                 status.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 status.seeCount = model.watchedcount;
                 //model.votecount
                //status.zambiaCount = model.votecount;
                 status.answerCount = @"50";
                 status.movieName =[NSString stringWithFormat:@"《%@》",model.movie.title];
                 status.nikeName = model.user.nickname;
                 status.time = [NSString stringWithFormat:@"1小时前"];
                 //创建MianDingGeModelFrame模型
                 DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
                 statusFrame.model = status;
                 [statusFrame setModel:status];
                 [statusFrames addObject:statusFrame];
                 
             }
             
             
             self.statusFramesDingGe = statusFrames;
             [self.dingge reloadData];
             
             
             [self.hud setHidden:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
  }

- (void)loadShuoXiData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:SHUOXI_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             ShuoXiArr = [ShuoXiModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (ShuoXiModel *model in ShuoXiArr) {
                
                 //创建模型
                 ShuoXiModel *status = [[ShuoXiModel alloc]init];
                 status.picture = [NSString stringWithFormat:@"avatar@2x.png"];
                 status.icon = [NSString stringWithFormat:@"avatar@2x.png"];
                 status.answerCount = @"50";
                 status.name = model.user.nickname;
                 status.time = [NSString stringWithFormat:@"1小时前"];
                 status.vip = YES;
                 status.text = model.title;
                 status.picture = [NSString stringWithFormat:@"shuoxiImg.png"];
                 status.daRenTitle = @"达人";
                 status.mark = @"(著名编剧 导演 )";
                 //创建MianDingGeModelFrame模型
                 ShuoXiModelFrame *statusFrame = [[ShuoXiModelFrame alloc]init];
                 statusFrame.model = status;
                 [statusFrame setModel:status];
                 [statusFrames addObject:statusFrame];
             }
             
             self.statusFramesShuoXi = statusFrames;
             [self.shuoxi reloadData];
             [self.hud setHidden:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
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

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
//    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    if (segmentedControl.selectedSegmentIndex == 1) {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        [self.dingge.layer addAnimation:animation forKey:nil];
        [self.shuoxi.layer addAnimation:animation forKey:nil];
        [self.dingge setHidden:YES];
        [self.shuoxi setHidden:NO];
        [self loadShuoXiData];
    }
    else {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        [self.dingge.layer addAnimation:animation forKey:nil];
        [self.shuoxi.layer addAnimation:animation forKey:nil];
        [self.shuoxi setHidden:YES];
        [self.dingge setHidden:NO];
        [self loadDingGeData];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.dingge]) {
        return self.statusFramesDingGe.count;
    }
    else{
        return self.statusFramesShuoXi.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if ([tableView isEqual:self.dingge]) {
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置cell
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        NSString * string = model.image;
        
        //设置图片为圆角的
        CALayer * imagelayer = [cell.movieImg layer];
        [imagelayer setMasksToBounds:YES];
        [imagelayer setCornerRadius:6.0];
        
        
        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        
        [imageView setImage:cell.movieImg.image];
        
        [cell.contentView addSubview:imageView];
         cell.message.text = model.content;
        [cell.contentView addSubview:cell.message];
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
        [cell.userImg addGestureRecognizer:tapGesture];
         //status.seeCount = model.watchedcount;
        
        

        
        
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",model.watchedcount] forState:UIControlStateNormal];
        [cell.seeBtn addTarget:self action:@selector(seebtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.seeBtn];
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.votecount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];
        
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextControloler:)];
//        
//        [cell.contentView addGestureRecognizer:tap];
//        UIView *tapView = [tap view];
//        tapView.tag = 2;
        
        return cell;
    }
   else {
       NSString *ID = [NSString stringWithFormat:@"ShuoXi"];
        MyShuoXiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
       
       if (cell == nil) {
           cell = [[MyShuoXiTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
       }
       //创建模型
       ShuoXiModel *model = ShuoXiArr[indexPath.row];
       ShuoXiModel *status = [[ShuoXiModel alloc]init];
       status.icon = [NSString stringWithFormat:@"avatar@2x.png"];
       status.answerCount = @"50";
       status.name = model.user.nickname;
       status.time = [NSString stringWithFormat:@"1小时前"];
       status.vip = YES;
       status.text = model.title;
       status.picture = [NSString stringWithFormat:@"shuoxiImg.png"];
       status.daRenTitle = @"达人";
       status.mark = @"(著名编剧 导演 )";
       [cell setup:status];
       [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
        return cell;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    if ([tableView isEqual:self.dingge]) {
        DingGeModelFrame *statusFrame = self.statusFramesDingGe[indexPath.row];
        return statusFrame.cellHeight;

    }
    else{
       
        ShuoXiModelFrame *statusFrame = self.statusFramesShuoXi[indexPath.row];
        return statusFrame.cellHeight;

    }
        
}

-(void)zambiabtn:(UIButton *)sender{

    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.dingge indexPathForCell:cell];
    
    
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    
    
    NSInteger zan = [model.votecount integerValue];
    zan = zan+1;
    model.votecount = [NSString stringWithFormat:@"%ld",zan];
        
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/votecount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
              NSLog(@"点赞成功,%@",responseObject);
             [self.dingge reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
             NSLog(@"请求失败,%@",error);
         }];




}

-(void)seebtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.dingge indexPathForCell:cell];
    
    
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    
    
    NSInteger see = [model.watchedcount integerValue];
    see = see+1;
    model.watchedcount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/watchedcount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"点赞成功,%@",responseObject);
              [self.dingge reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    
    
}






-(void)userbtn:(id)sender{
    
    
        TaTableViewController * taviewcontroller = [[TaTableViewController alloc]init];
        [self.navigationController pushViewController:taviewcontroller animated:YES];

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.dingge]) {
        DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
        
        dingge.hidesBottomBarWhenPushed = YES;
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        dingge.movieID = model.image;
        dingge.DingID  = model.ID;
        
        
        
        [self.navigationController pushViewController:dingge animated:YES];
    }
    else{
    
        ShuoxiTableViewController * shuoxi = [[ShuoxiTableViewController alloc]init];
        
        shuoxi.hidesBottomBarWhenPushed = YES;
        
        ShuoXiModel *model = ShuoXiArr[indexPath.row];
        
        shuoxi.moviepicture = model.image;
        shuoxi.ShuoID = model.ID;
        
        
        [self.navigationController pushViewController:shuoxi animated:YES];
    
    
    
    }


}


-(void)Refresh
{
    
   
    self.DinggerefreshHeader.isEffectedByNavigationController = NO;
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.dingge];
    [refreshHeader addTarget:self refreshAction:@selector(headRefresh)];
    self.DinggerefreshHeader=refreshHeader;
    [refreshHeader autoRefreshWhenViewDidAppear];
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.dingge];
    [refreshFooter addTarget:self refreshAction:@selector(footRefresh)];
    self.DinggerefreshFooter=refreshFooter;
    
    
    self.ShuoxirefreshHeader.isEffectedByNavigationController = NO;
    
    SDRefreshHeaderView *shuoxirefreshHeader = [SDRefreshHeaderView refreshView];
    [shuoxirefreshHeader addToScrollView:self.shuoxi];
    [shuoxirefreshHeader addTarget:self refreshAction:@selector(headRefresh)];
    self.ShuoxirefreshHeader=shuoxirefreshHeader;
    [refreshHeader autoRefreshWhenViewDidAppear];
    
    SDRefreshFooterView *shuoxirefreshFooter = [SDRefreshFooterView refreshView];
    [shuoxirefreshFooter addToScrollView:self.shuoxi];
    [shuoxirefreshFooter addTarget:self refreshAction:@selector(footRefresh)];
    self.ShuoxirefreshFooter=shuoxirefreshFooter;
    
   
    
}
-(void)headRefresh
{
    [self.DinggerefreshHeader endRefreshing];
    [self.ShuoxirefreshHeader endRefreshing];
}
-(void)footRefresh
{
    [self.DinggerefreshFooter endRefreshing];
    [self.ShuoxirefreshFooter endRefreshing];
}





//- (void) nextControloler: (id)sender{
//    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
//    back.title = @"";
//    self.navigationItem.backBarButtonItem = back;
//    
//    
//    UITapGestureRecognizer *tap = sender;
//    long tapTag = [tap view].tag;
//    
//    if (tapTag == 1) {
//        ShuoxiTableViewController *shuoxi = [[ShuoxiTableViewController alloc]init];
//        shuoxi.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:shuoxi animated:YES];
//    }
//    else{
//        DinggeSecondViewController *dingge = [[DinggeSecondViewController alloc]init];
//        dingge.hidesBottomBarWhenPushed = YES;
//        
//        [self.navigationController pushViewController:dingge animated:YES];
//    }
//}

@end

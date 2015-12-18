//
//  TaTableViewController.m
//  cine
//
//  Created by Mac on 15/11/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "TaTableViewController.h"
#import "HeadView.h"
#import "headViewModel.h"
#import "HMSegmentedControl.h"
#import "DingGeModel.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModelFrame.h"
#import "RecMovieTableViewCell.h"
#import "RecModel.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "DinggeSecondViewController.h"
#import "ReviewModel.h"
#import "ReviewTableViewCell.h"
#define tablewH self.view.frame.size.height-230


@interface TaTableViewController (){
    
    NSMutableArray * DingGeArr;
}


@property(nonatomic,strong) UITableView *seen;
@property(nonatomic,strong) UITableView *dingge;
@property(nonatomic,strong) UITableView *jianpain;
@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic,strong)NSMutableArray *dataload;
@property(strong,nonatomic) NSMutableArray *DingArr;
@property(nonatomic,strong)NSArray *statusFramesDingGe;
@property(nonatomic,strong)NSArray * RevArr;
@property(nonatomic,strong)NSArray * RecArr;

@end

@implementation TaTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.title = @"他的";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataload = [[NSMutableArray alloc]init];

    
    headViewModel *model = [[headViewModel alloc]init];
    
    model.backPicture = [NSString stringWithFormat:@"myBackImg.png"];
    model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
    model.name = [NSString stringWithFormat:@"小小新"];
    model.mark = [NSString stringWithFormat:@"著名编剧、导演、影视投资人"];
    model.addBtnImg = [NSString stringWithFormat:@"follow-mark.png"];
    HeadView *headView = [[HeadView alloc]init];
    
    
    [headView setup:model];
    
    self.tableView.tableHeaderView = headView;
    
    [self setUIControl];
    
    [self settabController];
    
    [self Refresh];
    [self loadDingGeData];
    [self loadLookData];
    [self loadRecData];
    
}
#pragma 定义tableview
- (void) settabController{
    self.seen = [[UITableView alloc]initWithFrame:CGRectMake(0, 220, wScreen, tablewH )];
    self.dingge = [[UITableView alloc]initWithFrame:CGRectMake(0,220, wScreen, tablewH )];
    self.jianpain = [[UITableView alloc]initWithFrame:CGRectMake(0,220, wScreen,tablewH )];
    self.seen.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dingge.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.jianpain.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.seen.dataSource = self;
    self.seen.delegate = self;
    self.dingge.delegate = self;
    self.dingge.dataSource = self;
    self.jianpain.dataSource = self;
    self.jianpain.delegate = self;
    
    self.dingge.userInteractionEnabled = NO;
    self.seen.userInteractionEnabled = NO;
    self.jianpain.userInteractionEnabled = NO;
    
    
    
//    [self.tableView addSubview:self.seen];
//    [self.tableView addSubview:self.dingge];
//    [self.tableView addSubview:self.jianpain];

}


-(void)loadLookData{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REVIEW_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RevArr = [ReviewModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];




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

-(void)loadRecData{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RecArr = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];

}


- (void)setUIControl{
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"看过", @"定格",@"鉴片"]];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.frame = CGRectMake(0,190, wScreen, 30);
    segmentedControl.selectionIndicatorHeight = 3.0f;
    segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]};
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:segmentedControl];

}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 1;

    [self.seen.layer addAnimation:animation forKey:nil];
    [self.dingge.layer addAnimation:animation forKey:nil];
    [self.jianpain.layer addAnimation:animation forKey:nil];
    
    [self.seen setHidden:NO];
    [self.dingge setHidden:NO];
    [self.jianpain setHidden:NO];

    if(segmentedControl.selectedSegmentIndex == 0){
        [self.seen setHidden:YES];
    }
    else if(segmentedControl.selectedSegmentIndex == 1){
        [self.dingge setHidden:YES];
    }
    else{
        [self.jianpain setHidden:YES];
    }
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
    if ([tableView isEqual:self.dingge]) {
        return [self.statusFramesDingGe count];
    }else if([tableView isEqual:self.seen]){
        
        
        return [self.RevArr count];
        
    }else{
    
        return [self.RecArr count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       if (indexPath.section == 0) {
           
          
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
           
//           //点击头像事件
//           cell.userImg.userInteractionEnabled = YES;
//           
//           UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
//           [cell.userImg addGestureRecognizer:tapGesture];
//           
//           
//           //点赞
//           [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
//           [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
//           [cell.contentView addSubview:cell.zambiaBtn];
           
           cell.userImg.userInteractionEnabled = YES;
           
           
           cell.message.text = model.content;
           
        
           return cell;
    }

  else if ([tableView isEqual:self.dingge]) {
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
      
      //           //点击头像事件
      //           cell.userImg.userInteractionEnabled = YES;
      //
      //           UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
      //           [cell.userImg addGestureRecognizer:tapGesture];
      //
      //
      //           //点赞
      //           [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
      //           [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
      //           [cell.contentView addSubview:cell.zambiaBtn];
      
      cell.userImg.userInteractionEnabled = YES;
      
      
      cell.message.text = model.content;
      
      
      
        return cell;
    }
    else if([tableView isEqual:self.jianpain]){
        
        
        NSString *ID = [NSString stringWithFormat:@"DingGe"];
        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[RecMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RecArr[indexPath.row]];
        return cell;

       

    }else if([tableView isEqual:self.seen]){
    
        NSString *ID = [NSString stringWithFormat:@"REVIEW"];
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ReviewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RevArr[indexPath.row]];
        return cell;
    
    
    }
    return nil;
}



//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
//    
//    dingge.hidesBottomBarWhenPushed = YES;
//    
//    DingGeModel *model = DingGeArr[indexPath.row];
//    
//   // dingge.movieID = model.image;
//    
//    [self.navigationController pushViewController:dingge animated:YES];
//    
//    
//}




- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.dingge]) {
        DingGeModelFrame *statusFrame = self.statusFrames[indexPath.row];
        return statusFrame.cellHeight;
    }else if ([tableView isEqual:self.seen]){
        
        return 300;
    
    
    }else{
    
        return 270;
    }
    
   
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

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
@property(nonatomic, strong)NSArray *statusFramesDingGe;

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
    model.name = [NSString stringWithFormat:@"哈哈哈"];
    model.mark = [NSString stringWithFormat:@"哈哈哈好好好好好"];
    model.addBtnImg = [NSString stringWithFormat:@"follow-mark.png"];
    HeadView *headView = [[HeadView alloc]init];
    
    
    [headView setup:model];
    
    self.tableView.tableHeaderView = headView;
    
    [self setUIControl];
    
    [self settabController];
    
    [self loadDingGeData];
    
    [self Refresh];
    
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
    
    [self.tableView addSubview:self.seen];
    [self.tableView addSubview:self.dingge];
    [self.tableView addSubview:self.jianpain];

}

-(NSArray *)statusFrames{
    if (_statusFrames == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (int i = 0; i < 10; i++ ) {
            
            //创建MLStatus模型
            DingGeModel *status = [[DingGeModel alloc]init];
            status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
            status.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
            status.nikeName = [NSString stringWithFormat:@"霍比特人"];
            status.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
//            status.seeCount = @"600";
//            status.zambiaCount = @"600";
//            status.answerCount = @"50";
            
            //创建MLStatusFrame模型
            DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
            statusFrame.model = status;
            [statusFrame setModel:status];
            [statusFrames addObject:statusFrame];
            
        }
        _statusFrames = statusFrames;
    }
    return _statusFrames;
}

- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:DINGGE_API parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             self.DingArr = DingGeArr;
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 //创建模型
                 DingGeModel *status = [[DingGeModel alloc]init];
                 //status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
                 
                 status.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 status.seeCount = model.watchedcount;
                 status.zambiaCount = model.votecount;
                 status.answerCount = @"50";
                 //               NSLog(@"model.movie == %@",model.movie.title,nil);
                 status.movieName = model.movie.title;
                 status.nikeName = model.user.nickname;
                 status.time = [NSString stringWithFormat:@"1小时前"];
                 //创建MianDingGeModelFrame模型
                 DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
                 statusFrame.model = status;
                 [statusFrame setModel:status];
                 [statusFrames addObject:statusFrame];
             }
             
             
             self.statusFramesDingGe = statusFrames;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
        
    
        
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextControloler:)];
        //
        //        [cell.contentView addGestureRecognizer:tap];
        //        UIView *tapView = [tap view];
        //        tapView.tag = 2;
           
           cell.userImg.userInteractionEnabled = YES;
           
           
   
           
           
        
        return cell;
    }

  else if (![tableView isEqual:self.jianpain]) {
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置高度
        cell.modelFrame = self.statusFrames[indexPath.row];
      
      
      
      cell.userImg.userInteractionEnabled = YES;
      
        
        
        return cell;
    }
    else{
        NSString *ID = @"recMovie";
        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[RecMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:ID];
        }
        for (int i = 0; i < 10 ; i++) {
            
            RecModel *model = [[RecModel alloc]init];
            model.movieImg = [NSString stringWithFormat:@"backImg.png"];
            model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
            model.nikeName = @"哈哈";
            model.appCount = @"1000人 感谢";
            model.time = @"1小时前";
            model.text = @"哈哈哈和哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈和";
            model.title = @"视觉好";
            model.movieName = @"<<泰囧>>";
            [self.dataload addObject:model];
            //   self.statusFrames = arrModel;
        }
        [cell setup:self.dataload[indexPath.row]];
        return cell;

    }
    return nil;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.movieID = model.image;
    
    
    
    [self.navigationController pushViewController:dingge animated:YES];
    
    
}




- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DingGeModelFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
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

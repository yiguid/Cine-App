//
//  TadeTableViewController.m
//  cine
//
//  Created by wang on 15/12/22.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "TadeTableViewController.h"
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
@interface TadeTableViewController (){
    
    NSMutableArray * DingGeArr;
    UIView * cellview;
}

@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic,strong)NSMutableArray *dataload;
@property(strong,nonatomic) NSMutableArray *DingArr;
@property(nonatomic,strong)NSArray *statusFramesDingGe;
@property(nonatomic,strong)NSArray * RevArr;
@property(nonatomic,strong)NSArray * RecArr;

@end

@implementation TadeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"他的";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    cellview = [[UIView alloc]initWithFrame:CGRectMake(0, 190, wScreen, 30)];
    
    
    
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"看过", @"定格",@"鉴片"]];
    segmentedControl.frame = CGRectMake(0,190, wScreen, 30);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.selectionIndicatorHeight = 3.0f;
    segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]};
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];

    [self settabController];
    [self loadRevData];
    [self loadDingGeData];
    [self loadRecData];
    [self.revtableview reloadData];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 定义tableview
- (void) settabController{
    self.rectableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, wScreen,hScreen)];
    self.dinggetableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, wScreen,hScreen)];
    self.revtableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, wScreen,hScreen)];
    self.rectableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dinggetableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.revtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.rectableview.dataSource = self;
    self.rectableview.delegate = self;
    self.dinggetableview.delegate = self;
    self.dinggetableview.dataSource = self;
    self.revtableview.dataSource = self;
    self.revtableview.delegate = self;
    
    [self.tableView addSubview:self.rectableview];
    [self.tableView addSubview:self.dinggetableview];
    [self.tableView addSubview:self.revtableview];
    
    
    HeadView *headView = [[HeadView alloc]init];
    headViewModel *model = [[headViewModel alloc]init];
    model.backPicture = [NSString stringWithFormat:@"myBackImg.png"];
    model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
    model.name = [NSString stringWithFormat:@"小小新"];
    model.mark = [NSString stringWithFormat:@"著名编剧、导演、影视投资人"];
    model.addBtnImg = [NSString stringWithFormat:@"follow-mark.png"];
    [headView setup:model];
    
    
    self.revtableview.tableHeaderView = headView;
    
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"看过", @"定格",@"鉴片"]];
    segmentedControl.frame = CGRectMake(0,190, wScreen, 30);
    segmentedControl.selectionIndicatorHeight = 3.0f;
    segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]};
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.revtableview addSubview:segmentedControl];
    

    
}



- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    //NSString *url = [NSString stringWithFormat:@"%@/%@",DINGGE_API];
    [manager GET:DINGGE_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 //创建模型
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.seeCount = model.viewCount;
                 //status.zambiaCount = model.votecount;
                 model.answerCount = @"50";
                 model.movieName =[NSString stringWithFormat:@"《%@》",model.movie.title];
                 model.nikeName = model.user.nickname;
                 model.time = [NSString stringWithFormat:@"1小时前"];
                 //创建MianDingGeModelFrame模型
                 DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
                 statusFrame.model = model;
                 [statusFrame setModel:model];
                 [statusFrames addObject:statusFrame];
                 
             }
             
             
             self.statusFramesDingGe = statusFrames;
             
             
             [self.dinggetableview reloadData];
             
             
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
             [self.rectableview reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
}


-(void)loadRevData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REVIEW_API parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RevArr = [ReviewModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.revtableview reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
    
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"index %ld ", (long)segmentedControl.selectedSegmentIndex);
    
    
    if(segmentedControl.selectedSegmentIndex == 0){
        
        
        
        
        HeadView *headView = [[HeadView alloc]init];
        headViewModel *model = [[headViewModel alloc]init];
        model.backPicture = [NSString stringWithFormat:@"myBackImg.png"];
        model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
        model.name = [NSString stringWithFormat:@"小小新"];
        model.mark = [NSString stringWithFormat:@"著名编剧、导演、影视投资人"];
        model.addBtnImg = [NSString stringWithFormat:@"follow-mark.png"];
        [headView setup:model];
        

        self.revtableview.tableHeaderView = headView;
        
        
        segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"看过", @"定格",@"鉴片"]];
        segmentedControl.frame = CGRectMake(0,190, wScreen, 30);
        segmentedControl.selectionIndicatorHeight = 3.0f;
        segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
        segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]};
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
        [self.revtableview addSubview:segmentedControl];
        

        
        
        
        
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        
        [self.revtableview.layer addAnimation:animation forKey:nil];
        [self.dinggetableview.layer addAnimation:animation forKey:nil];
        [self.rectableview.layer addAnimation:animation forKey:nil];
        
        
        
        [self.revtableview setHidden:NO];
        [self.dinggetableview setHidden:YES];
        [self.rectableview setHidden:YES];
        [self loadRevData];
    }
    else if(segmentedControl.selectedSegmentIndex == 1){
        
        HeadView *headView = [[HeadView alloc]init];
        headViewModel *model = [[headViewModel alloc]init];
        
        model.backPicture = [NSString stringWithFormat:@"myBackImg.png"];
        model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
        model.name = [NSString stringWithFormat:@"小小新"];
        model.mark = [NSString stringWithFormat:@"著名编剧、导演、影视投资人"];
        model.addBtnImg = [NSString stringWithFormat:@"follow-mark.png"];
        [headView setup:model];
        self.dinggetableview.tableHeaderView = headView;
       
        segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"看过", @"定格",@"鉴片"]];
        segmentedControl.frame = CGRectMake(0,190, wScreen, 30);
        segmentedControl.selectionIndicatorHeight = 3.0f;
        segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
        segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]};
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
        [self.dinggetableview addSubview:segmentedControl];
        
        
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        
        [self.revtableview.layer addAnimation:animation forKey:nil];
        [self.dinggetableview.layer addAnimation:animation forKey:nil];
        [self.rectableview.layer addAnimation:animation forKey:nil];
        
        
        
        [self.revtableview setHidden:YES];
        [self.dinggetableview setHidden:NO];
        [self.rectableview setHidden:YES];
        [self loadDingGeData];
    }
    else{
        
        
        
        HeadView *headView = [[HeadView alloc]init];
        headViewModel *model = [[headViewModel alloc]init];
        
        model.backPicture = [NSString stringWithFormat:@"myBackImg.png"];
        model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
        model.name = [NSString stringWithFormat:@"小小新"];
        model.mark = [NSString stringWithFormat:@"著名编剧、导演、影视投资人"];
        model.addBtnImg = [NSString stringWithFormat:@"follow-mark.png"];
        [headView setup:model];
        self.rectableview.tableHeaderView = headView;
        
        segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"看过", @"定格",@"鉴片"]];
        segmentedControl.frame = CGRectMake(0,190, wScreen, 30);
        segmentedControl.selectionIndicatorHeight = 3.0f;
        segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
        segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]};
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
        [self.rectableview addSubview:segmentedControl];
        
        
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        
        [self.revtableview.layer addAnimation:animation forKey:nil];
        [self.dinggetableview.layer addAnimation:animation forKey:nil];
        [self.rectableview.layer addAnimation:animation forKey:nil];
        
        
        
        [self.revtableview setHidden:YES];
        [self.dinggetableview setHidden:YES];
        [self.rectableview setHidden:NO];
        [self loadRecData];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    
    
        
        if (tableView == self.revtableview) {
            return self.RevArr.count;
        }else if (tableView == self.dinggetableview) {
            
             return self.statusFramesDingGe.count;
        }else{
            
           return self.RecArr.count;
        }
        

    
  
    
  
    
    
  }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==self.revtableview) {
        NSString *ID = [NSString stringWithFormat:@"REVIEW"];
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ReviewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RevArr[indexPath.row]];
        return cell;
    }else if(tableView == self.dinggetableview){
    
    
        
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置cell
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        NSString * string = model.image;
        
        
        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        
        [imageView setImage:cell.movieImg.image];
        
        
        return cell;
    
    }else{
    
        
        NSString *ID = [NSString stringWithFormat:@"Rec"];
        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[RecMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RecArr[indexPath.row]];
        return cell;

    
    }
               return nil;
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    if (tableView==self.rectableview) {
       return 300;
    }else if (tableView==self.dinggetableview) {
        
        DingGeModelFrame *statusFrame = self.statusFramesDingGe[indexPath.row];
        return statusFrame.cellHeight;
    }else{
        return 270;
        
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
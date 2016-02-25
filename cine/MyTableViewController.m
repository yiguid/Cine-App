//
//  MyTableViewController.m
//  cine
//
//  Created by Guyi on 15/11/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyStaticTableViewCell.h"
#import "MyGuanZhuTableViewController.h"
#import "MyFansTableViewController.h"
#import "MyMessageTableViewController.h"
#import "MyDingGeViewController.h"
#import "MyRecommendedTableViewController.h"
#import "MySettingTableViewController.h"
#import "MyRecMovieViewController.h"
#import "MyLookViewController.h"
#import "CollectionViewController.h"
#import "HeadView.h"
#import "headViewModel.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
#import "AlertHeadViewController.h"
#import "AlertNicknameViewController.h"
#import "UserModel.h"
#import "MJExtension.h"
#import "AlertHeadViewController.h"
#import "AlertNicknameViewController.h"
#import "AleartBackgroundViewController.h"
#import "EvaluationModel.h"
#import "UITabBar+badge.h"
@interface MyTableViewController () <UITableViewDelegate,UITableViewDataSource>{


    UserModel * user;
    
    
    NSInteger count1;
    NSInteger count2;
    NSInteger count3;
    
}
@property NSMutableArray *zanarr;
@property NSMutableArray *ganxiearr;
@property NSMutableArray *pinglunarr;
@property NSMutableArray *fensiarr;
@property NSMutableArray *guanzhuarr;

@property NSMutableArray *datazanarr;
@property NSMutableArray *dataganxiearr;
@property NSMutableArray *datapinglunarr;


@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    //取消分割线
   self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.zanarr = [[NSMutableArray alloc]init];
    self.ganxiearr = [[NSMutableArray alloc]init];
    self.pinglunarr = [[NSMutableArray alloc]init];
    
    self.datazanarr = [[NSMutableArray alloc]init];
    self.dataganxiearr = [[NSMutableArray alloc]init];
    self.datapinglunarr = [[NSMutableArray alloc]init];
    
    self.fensiarr = [[NSMutableArray alloc]init];
    self.guanzhuarr = [[NSMutableArray alloc]init];


    
    
    
    [self setupHeader];
   // [self setupFooter];
    
    //设置导航栏
    [self setNav];
    //设置tabview顶部视图
    [self setHeaderView];
    [self tableView];
    
    
    [self loadzan];
    [self loadfensi];
    [self loadganxie];
    [self loadguanzhu];
    [self loadpinglun];
 
    
}



- (void)viewDidAppear:(BOOL)animated
{
    
    //获取数据
     [self setHeaderView];
    
}




/**
 * 设置tabview顶部视图
 */
- (void)setHeaderView{
    headViewModel *model = [[headViewModel alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/%@",USER_AUTH_API,userId];
    [manager GET:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"获取个人信息成功,%@",responseObject);
             
              user= [UserModel mj_objectWithKeyValues:responseObject];
              
              model.name = user.nickname;
              model.mark = user.promoteMessage;
              model.userImg = user.avatarURL;
              model.backPicture = user.backgroundImage;
              model.catalog = user.catalog;
              HeadView *headView = [[HeadView alloc]init];
              headView.frame = CGRectMake(0, 0, wScreen, 200);
              headView.backgroundColor = [UIColor colorWithRed:210/255.0 green:212/255.0 blue:225/255.0 alpha:1.0];
              [headView setup:model];
              self.tableView.tableHeaderView = headView;
              
              
      
              
              
              UIButton * userimage = [[UIButton alloc]initWithFrame:CGRectMake(10,140,40,40)];
              [self.view addSubview:userimage];
              
              
              UIButton * userbackPicture = [[UIButton alloc]initWithFrame:CGRectMake(0,0,wScreen,130)];
              [self.view addSubview:userbackPicture];
              
              
              
              UIButton * username = [[UIButton alloc]initWithFrame:CGRectMake(60, 130,60, 30)];
              [self.view addSubview:username];
              
              [userimage addTarget:self action:@selector(userimageButton)forControlEvents:UIControlEventTouchUpInside];
              
              [username addTarget:self action:@selector(usernameButton)forControlEvents:UIControlEventTouchUpInside];
              
              [userbackPicture addTarget:self action:@selector(userbackButton)forControlEvents:UIControlEventTouchUpInside];
              

              
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //             [self.hud setHidden:YES];
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

- (void)loadzan {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSString *url =[NSString stringWithFormat:@"%@/%@/votes",BASE_API,userId];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             
             self.zanarr = [EvaluationModel mj_objectArrayWithKeyValuesArray:responseObject];
             count1 = 0;
             
             for (EvaluationModel * eval in self.zanarr) {
                 if ([eval.is_read isEqualToString:@"0"]) {
                     
                    
                     count1 = count1 + 1;
                     
                     
                 }
             }
            [self.tableView reloadData];
      
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
      
}



- (void)loadganxie {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/thanked/%@/recommend",BASE_API,userId];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             
             self.ganxiearr = [EvaluationModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             count3 = 0;
             
             for (EvaluationModel * eval in self.ganxiearr) {
                 if ([eval.is_read isEqualToString:@"0"]) {
                     
                     
                     count3 = count3 + 1;
                     
                     
                 }
             }

             
             [self.tableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
}


- (void)loadpinglun {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSDictionary *parameters = @{@"to":userId,@"sort": @"createdAt DESC"};
    NSString *url =[NSString stringWithFormat:@"%@/commentme",BASE_API];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             
             self.pinglunarr = [EvaluationModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             count2 = 0;
             
             for (EvaluationModel * eval in self.pinglunarr) {
                 if ([eval.is_read isEqualToString:@"0"]) {
                     
                     
                     count2 = count2 + 1;
                     
                     
                 }
             }

                         
             [self.tableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
    
}


- (void)loadfensi {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/followed",USER_AUTH_API,userId];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             NSMutableArray * arrModel = [NSMutableArray array];
             
             arrModel = [UserModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             for (UserModel *model in arrModel) {
                 if([model.userId isEqual:userId]){
                     
                     [arrModel removeObject:model];
                     
                     break;
                     
                 }
             }
             self.fensiarr = [arrModel mutableCopy];
             [self.tableView reloadData];
           
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
             NSLog(@"请求失败,%@",error);
         }];
    
}

- (void)loadguanzhu {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/following",USER_AUTH_API,userId];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"请求返回,%@",responseObject);
             NSMutableArray * arrModel = [NSMutableArray array];
             
             arrModel = [UserModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             for (UserModel *model in arrModel) {
                 if([model.userId isEqual:userId]){
                     
                     [arrModel removeObject:model];
                     
                     break;
                     
                 }
             }
             self.guanzhuarr = [arrModel mutableCopy];
             [self.tableView reloadData];
          
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
             NSLog(@"请求失败,%@",error);
         }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        self.tableView.sectionHeaderHeight = 2;
        
        return 3;
    }   else if (section == 1)
        {
            self.tableView.sectionHeaderHeight = 2;
    
            return 4;
        }
        else{
            self.tableView.sectionHeaderHeight = 2;
    
            return 1;
        }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        MyStaticTableViewCell *cellStatic = [tableView dequeueReusableCellWithIdentifier:@"StaticCell"];
        cellStatic.lineView.backgroundColor = [UIColor colorWithRed:200.0/255 green:199.0/255 blue:211.0/255 alpha:1.0];
    
       
        
        [cellStatic.title setTextColor:[UIColor colorWithRed:117.0/255 green:117.0/255 blue:109.0/255 alpha:1.0]];
        cellStatic.contentView.frame = CGRectMake(5, 0, self.view.bounds.size.width - 10, 54);
        if(indexPath.section == 0)
        {
       
            if (indexPath.row == 0) {
                cellStatic.title.text = @"关注";
                cellStatic.title.font = TextFont;
                cellStatic.titleImg.image = [UIImage imageNamed:@"关注@2x.png"];
                
                 NSString * str = [NSString stringWithFormat:@"%ld",self.guanzhuarr.count];
                cellStatic.counts.text = str;
                cellStatic.counts.font = TextFont;
                 cellStatic.counts.textColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
                cellStatic.backgroundColor = [UIColor colorWithRed:210/255.0 green:212/255.0 blue:225/255.0 alpha:1.0];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                [cellStatic.contentView addGestureRecognizer:tap];
                UIView *tagView =[tap view];
                tagView.tag = 1;
           
                UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, wScreen-20, 1)];
                
                headView.backgroundColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
                [cellStatic.contentView addSubview:headView];

            }
            else if(indexPath.row == 1){
                cellStatic.title.text = @"粉丝";
                 cellStatic.title.font = TextFont;
                cellStatic.titleImg.image = [UIImage imageNamed:@"粉丝@2x.png"];
                 cellStatic.backgroundColor = [UIColor colorWithRed:210/255.0 green:212/255.0 blue:225/255.0 alpha:1.0];
                 NSString * str = [NSString stringWithFormat:@"%ld",self.fensiarr.count];
                cellStatic.counts.text = str;
                cellStatic.counts.font = TextFont;
                cellStatic.counts.textColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                [cellStatic.contentView addGestureRecognizer:tap];
                UIView *tagView =[tap view];
                tagView.tag = 2;
                
                UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, wScreen-20, 1)];
                
                 headView.backgroundColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
                [cellStatic.contentView addSubview:headView];
               

            }
            else if(indexPath.row == 2){
                cellStatic.title.text = @"消息";
                 cellStatic.title.font = TextFont;
                cellStatic.titleImg.image = [UIImage imageNamed:@"消息@2x.png"];
                cellStatic.counts.text = [NSString stringWithFormat:@"%ld",self.zanarr.count+self.ganxiearr.count+self.pinglunarr.count];
                cellStatic.counts.font = TextFont;
                cellStatic.counts.textColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
                  cellStatic.backgroundColor = [UIColor colorWithRed:210/255.0 green:212/255.0 blue:225/255.0 alpha:1.0];
                NSString * str = [NSString stringWithFormat:@"%ld",(long)count1+(long)count2+(long)count3];
                
                if (![str isEqualToString:@"0"]) {
                    cellStatic.msg.text = str;
                    cellStatic.msg.font = TimeFont;
                    cellStatic.msg.textColor = [UIColor redColor];
                    
                   
//                    cellStatic.msg.layer.cornerRadius = 12;
//                    cellStatic.msg.layer.masksToBounds = YES;
                }
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                [cellStatic.contentView addGestureRecognizer:tap];
                UIView *tagView =[tap view];
                tagView.tag = 3;
            }}
            else if(indexPath.section == 1){
                if (indexPath.row == 0) {
                    cellStatic.title.text = @"定格";
                     cellStatic.title.font = TextFont;
                    cellStatic.titleImg.image = [UIImage imageNamed:@"定格@2x.png"];
                     cellStatic.backgroundColor = [UIColor colorWithRed:210/255.0 green:212/255.0 blue:225/255.0 alpha:1.0];


                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                    [cellStatic.contentView addGestureRecognizer:tap];
                    UIView *tagView =[tap view];
                    tagView.tag = 4;
                    
                    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, wScreen-20, 1)];
                    
                     headView.backgroundColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
                    [cellStatic.contentView addSubview:headView];
                }

            
                else if(indexPath.row == 1){
                    cellStatic.title.text = @"看过";
                     cellStatic.title.font = TextFont;
                    cellStatic.titleImg.image = [UIImage imageNamed:@"kan@2x.png"];
                     cellStatic.backgroundColor = [UIColor colorWithRed:210/255.0 green:212/255.0 blue:225/255.0 alpha:1.0];

                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                    [cellStatic.contentView addGestureRecognizer:tap];
                    UIView *tagView =[tap view];
                    tagView.tag = 5;
                    
                    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, wScreen-20, 1)];
                    
                    headView.backgroundColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
                    [cellStatic.contentView addSubview:headView];


            
                }else if(indexPath.row == 2){
                    cellStatic.title.text = @"收藏";
                     cellStatic.title.font = TextFont;
                    cellStatic.titleImg.image = [UIImage imageNamed:@"收藏@2x.png"];
                     cellStatic.backgroundColor = [UIColor colorWithRed:210/255.0 green:212/255.0 blue:225/255.0 alpha:1.0];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                    [cellStatic.contentView addGestureRecognizer:tap];
                    UIView *tagView =[tap view];
                    tagView.tag = 6;
                    
                    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, wScreen-20, 1)];
                    
                    headView.backgroundColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
                    [cellStatic.contentView addSubview:headView];

            
                }else if(indexPath.row == 3){
                    cellStatic.title.text = @"推荐电影";
                     cellStatic.title.font = TextFont;
                    cellStatic.titleImg.image = [UIImage imageNamed:@"推荐电影@2x.png"];
                     cellStatic.backgroundColor = [UIColor colorWithRed:210/255.0 green:212/255.0 blue:225/255.0 alpha:1.0];

                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
                    [cellStatic.contentView addGestureRecognizer:tap];
                    UIView *tagView =[tap view];
                    tagView.tag = 7;


                }
        }
        else {
            cellStatic.title.text = @"设置";
             cellStatic.title.font = TextFont;
            cellStatic.titleImg.image = [UIImage imageNamed:@"设置@2x.png"];
             cellStatic.backgroundColor = [UIColor colorWithRed:210/255.0 green:212/255.0 blue:225/255.0 alpha:1.0];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextController:)];
            [cellStatic.contentView addGestureRecognizer:tap];
            UIView *tagView =[tap view];
            tagView.tag = 8;

            
            
        }
    
    
    
        return cellStatic;
 
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //隐藏顶部的分割线
    UIView *headView = [[UIView alloc]init];
    
    headView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    
    return headView;
}



-(void)userimageButton{

    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AlertHead"];
    [self.navigationController pushViewController:vc animated:YES];

    
    

}

-(void)usernameButton{
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AlertNickname"];
    [self.navigationController pushViewController:vc animated:YES];



}

-(void)userbackButton{
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AleartBackground"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}






// 跳转界面
- (void)nextController :(id)sender{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    long tag  = [tap view].tag;

    if (tag == 1) {
        
        MyGuanZhuTableViewController *myGuanZhu = [[MyGuanZhuTableViewController alloc]init];
        myGuanZhu.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myGuanZhu animated:YES];

    }
    else if (tag == 2) {
        
        MyFansTableViewController *myFans = [[MyFansTableViewController alloc]init];
        myFans.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myFans animated:YES];
        
    }
    else if (tag == 3) {
        
        MyMessageTableViewController *myMessage = [[MyMessageTableViewController alloc]init];
        myMessage.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myMessage animated:YES];
        
    }
    else if (tag == 4) {
        
        MyDingGeViewController *myDingGe = [[MyDingGeViewController alloc]init];
        myDingGe.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myDingGe animated:YES];
        
    }
    else if (tag ==5 ) {
        
        MyLookViewController *myLook = [[MyLookViewController alloc]init];
        myLook.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myLook animated:YES];
        
    }
    else if (tag == 6) {
        
        CollectionViewController *myCollection = [[CollectionViewController alloc]init];
        myCollection.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myCollection animated:YES];
        
    }
    else if (tag == 7) {
        
        MyRecMovieViewController *myRecMovie = [[MyRecMovieViewController alloc]init];
        myRecMovie.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myRecMovie animated:YES];
        
    }
    else if (tag == 8) {
        
        MySettingTableViewController *mySetting = [[MySettingTableViewController alloc]init];
        mySetting.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:mySetting animated:YES];
        
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
            
         
            [self setHeaderView];
            
            
            [self loadzan];
            [self loadfensi];
            [self loadganxie];
            [self loadguanzhu];
            [self loadpinglun];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    
}

//- (void)setupFooter
//{
//    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
//    [refreshFooter addToScrollView:self.tableView];
//    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
//    _refreshFooter = refreshFooter;
//}
//
//
//- (void)footerRefresh
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.tableView reloadData];
//        [self.refreshFooter endRefreshing];
//    });
//}

@end

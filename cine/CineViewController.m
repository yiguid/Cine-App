//
//  CineViewController.m
//  cine
//
//  Created by Guyi on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CineViewController.h"
#import "HMSegmentedControl.h"
#import "DinggeSecondViewController.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModelFrame.h"
#import "DingGeModel.h"
#import "ShuoXiSecondViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MovieModel.h"
#import "RestAPI.h"
#import "TadeTableViewController.h"
#import "DinggeTitleViewController.h"
#import "CommentModel.h"
@interface CineViewController (){
    
    NSMutableArray * DingGeArr;
    NSMutableArray * ActivityArr;
    HMSegmentedControl *segmentedControl;
    NSMutableArray * CommentArr;
    NSString * str;
}
@property(nonatomic,retain)IBOutlet UITableView *dingge;
@property(nonatomic,retain)IBOutlet UITableView *activity;
@property(nonatomic, strong)NSMutableArray * statusFramesDingGe;
@property(nonatomic, strong)NSMutableArray * DingGerefresh;
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
    str = [[NSString alloc]init];
    str = @"10";
    
    self.dingge.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.activity.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
    [self loadShuoXiData];
    [self loadDingGeData];
    [self.dingge setHidden:NO];
    [self.activity setHidden:YES];
    
    
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"定格", @"说戏"]];
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

    [DingGeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];

    DingGeArr = [NSMutableArray array];
    ActivityArr = [NSMutableArray array];
    self.statusFramesDingGe = [NSMutableArray array];
    self.DingGerefresh = [NSMutableArray array];
   

    
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dinggebtn:)];
    tapGesture.numberOfTapsRequired = 2;
    [segmentedControl addGestureRecognizer:tapGesture];
    
    
    
    
    
    _dinggeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wScreen, 50)];
    _dinggeView.backgroundColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    [self.view addSubview:_dinggeView];
    UIButton * tuijianBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, wScreen/2-10, 30)];
    tuijianBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    [tuijianBtn setTitle:@"推荐 " forState:UIControlStateNormal];
    [tuijianBtn setImage:[UIImage imageNamed:@"jiantou@2x.png"] forState:UIControlStateNormal];
    tuijianBtn.imageEdgeInsets = UIEdgeInsetsMake(0,wScreen/4-40, 0, -wScreen/4+40);
    [tuijianBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [_dinggeView addSubview:tuijianBtn];
    
    UIButton * titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(wScreen/2, 10, wScreen/2-10, 30)];
    titleBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    [titleBtn setTitle:@"热门标签 " forState:UIControlStateNormal];
    titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0,wScreen/4-5, 0, -wScreen/4+5);
    [titleBtn setImage:[UIImage imageNamed:@"jiantou@2x.png"] forState:UIControlStateNormal];
    
    [titleBtn addTarget:self action:@selector(titileBtn:) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [_dinggeView addSubview:titleBtn];
    
    _dinggeView.hidden = YES;
    

    
    [self setupdinggeHeader];
    [self setupdinggeFooter];
    [self setupshuoxiHeader];
    [self setupshuoxiFooter];

    
   
 
    
}


-(void)dinggebtn:(id)sender{
    
    
    
    
    
           if (segmentedControl.selectedSegmentIndex == 0) {
               
            if ( _dinggeView.hidden ==YES) {
                
                _dinggeView.hidden = NO;
            }
      
        else{
            
            _dinggeView.hidden = YES;
      }

 }
    
}
    
-(void)titileBtn:(id)sender{
    
    DinggeTitleViewController * title = [[DinggeTitleViewController alloc]init];
    
    _dinggeView.hidden=YES;
   
    
    [self.navigationController pushViewController:title animated:YES];




}


- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":str};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:DINGGE_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 
                 if(model.viewCount==nil) {
                     
                     model.viewCount = @"0";
                  
                     
                 }
                 if(model.votecount==nil) {
                     
                     model.votecount = @"0";
                     
                 }
                 
                 //创建模型
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.seeCount = model.viewCount;
                 model.answerCount = model.votecount;
                 model.movieName =[NSString stringWithFormat:@"《%@》",model.movie.title];
                 model.nikeName = model.user.nickname;
                 model.time = model.createdAt;
                 //创建MianDingGeModelFrame模型
                 DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
                 statusFrame.model = model;
                 [statusFrame setModel:model];
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
    [manager GET:ACTIVITY_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             ActivityArr = [ActivityModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.activity reloadData];
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
            [self.activity.layer addAnimation:animation forKey:nil];
            [self.dingge setHidden:YES];
            [self.activity setHidden:NO];
            _dinggeView.hidden = YES;
            [self loadShuoXiData];
      
    }
    else {
        
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        [self.dingge.layer addAnimation:animation forKey:nil];
        [self.activity.layer addAnimation:animation forKey:nil];
        [self.activity setHidden:YES];
        [self.dingge setHidden:NO];
        [self loadDingGeData];
       
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
        if ([tableView isEqual:self.dingge]) {
            return DingGeArr.count;
        }
        else{
            return ActivityArr.count;
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
        
      
    
        if (model.viewCount == nil) {
            [cell.seeBtn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        }
        
        
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",model.viewCount] forState:UIControlStateNormal];
        [cell.seeBtn addTarget:self action:@selector(seebtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.seeBtn];
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];
        
       
        

        
        return cell;
    }
   else {
       NSString *ID = [NSString stringWithFormat:@"ShuoXi"];
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
       
       if (cell == nil) {
           cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
       }
       [cell setup:ActivityArr[indexPath.row]];
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
       
        return 280;

    }
        
}

-(void)zambiabtn:(UIButton *)sender{

    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.dingge indexPathForCell:cell];
    
    
    
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
    
    
    
    DingGeModel * model = DingGeArr[indexPath.row];
    
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
              [self.dingge reloadData];
              
            }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
}






-(void)userbtn:(id)sender{
    
        _dinggeView.hidden=YES;
    
    
        TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
        [self.navigationController pushViewController:taviewcontroller animated:YES];

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.dingge]) {
        DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
        
        dingge.hidesBottomBarWhenPushed = YES;
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        dingge.dingimage = model.image;
        dingge.DingID  = model.ID;
 
     
        
        _dinggeView.hidden=YES;

        
        [self.navigationController pushViewController:dingge animated:YES];
    }
    else{
    
        ShuoXiSecondViewController * shuoxi = [[ShuoXiSecondViewController alloc]init];
        
        shuoxi.hidesBottomBarWhenPushed = YES;
        
//        ActivityModel *model = ActivityArr[indexPath.row];
        
        _dinggeView.hidden=YES;
        ActivityModel *model = ActivityArr[indexPath.row];
        shuoxi.movie = model.movie;
        [self.navigationController pushViewController:shuoxi animated:YES];
    
    
    
    }


}

- (void)setupdinggeHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.dingge];
   
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
           
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            
            NSString *token = [userDef stringForKey:@"token"];
            NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":str};
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
            [manager GET:DINGGE_API parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                     DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
                     
                     
                     
                     //将dictArray里面的所有字典转成模型,放到新的数组里
                     NSMutableArray *statusFrames = [NSMutableArray array];
                     
                     for (DingGeModel *model in DingGeArr) {
                         NSLog(@"DingGeArr------%@",model.content);
                         
                         if(model.viewCount==nil) {
                             
                             model.viewCount = @"0";
                             
                             
                         }
                         if(model.votecount==nil) {
                             
                             model.votecount = @"0";
                             
                             
                         }
                         
                         //创建模型
                         model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                         model.seeCount = model.viewCount;
                         model.answerCount = @"0";
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
                    
                     [self.dingge reloadData];
                     [self.hud setHidden:YES];
                     
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [self.hud setHidden:YES];
                     NSLog(@"请求失败,%@",error);
                 }];
            
            
            [weakRefreshHeader endRefreshing];
        });
    };
    
  
}

- (void)setupshuoxiHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.activity];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         
            [self.activity reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    
}


- (void)setupdinggeFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.dingge];
    [refreshFooter addTarget:self refreshAction:@selector(dinggefooterRefresh)];
    _dinggerefreshFooter = refreshFooter;
}
- (void)setupshuoxiFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];

    [refreshFooter addToScrollView:self.activity];
    [refreshFooter addTarget:self refreshAction:@selector(shuoxifooterRefresh)];
    _shuoxirefreshFooter = refreshFooter;
}


- (void)dinggefooterRefresh
{

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSInteger a = [str intValue];
        a = a + 1;
        str = [NSString stringWithFormat:@"%ld",a];
      
        
    
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            
            NSString *token = [userDef stringForKey:@"token"];
            NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":str};
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
            [manager GET:DINGGE_API parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                     DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
                     //将dictArray里面的所有字典转成模型,放到新的数组里
                     NSMutableArray *statusFrames = [NSMutableArray array];
                     
                     for (DingGeModel *model in DingGeArr) {
                         NSLog(@"DingGeArr------%@",model.content);
                         
                         if(model.viewCount==nil) {
                             
                             model.viewCount = @"0";
                             
                             
                         }
                         if(model.votecount==nil) {
                             
                             model.votecount = @"0";
                             
                             
                         }
                         
                         //创建模型
                         model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                         model.seeCount = model.viewCount;
                         model.answerCount = @"0";
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
                     
                     [self.dingge reloadData];
                    
                     
                     [self.hud setHidden:YES];
                     
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [self.hud setHidden:YES];
                     NSLog(@"请求失败,%@",error);
                 }];
            
        [self.dinggerefreshFooter endRefreshing];
        
        
       
    });
}
- (void)shuoxifooterRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.activity reloadData];
        
        [self.shuoxirefreshFooter endRefreshing];
    });
}





@end

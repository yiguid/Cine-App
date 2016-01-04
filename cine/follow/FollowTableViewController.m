//
//  FollowTableViewController.m
//  cine
//
//  Created by Guyi on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "FollowTableViewController.h"
#import "AddPersonViewController.h"
#import "DingGeModel.h"
#import "MyDingGeTableViewCell.h"
#import "MyShuoXiTableViewCell.h"
#import "PublishViewController.h"
#import "ChooseMovieViewController.h"
#import "DingGeModelFrame.h"
#import "RecMovieTableViewCell.h"
#import "RecModel.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "TadeTableViewController.h"
#import "DinggeSecondViewController.h"
#import "ReviewModel.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "ReviewTableViewCell.h"
#import "CommentTableViewCell.h"
#import "RecommendSecondViewController.h"
#import "ReviewSecondViewController.h"
#import "ShuoXiModelFrame.h"
#import "ShuoXiModel.h"
#import "ShuoxiViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "ShuoXiSecondViewController.h"
#import "MovieTableViewController.h"
@interface FollowTableViewController (){
    
    NSMutableArray * DingGeArr;
}
@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic, strong)NSMutableArray *dataload;
@property(nonatomic, strong)NSArray *statusFramesDingGe;
@property(nonatomic, strong)NSArray *statusFramesComment;
@property(nonatomic, strong)NSArray *ActivityArr;
@property(nonatomic,strong)NSArray * RecArr;
@property(nonatomic,strong)NSArray * RevArr;
@property(nonatomic,strong)NSArray * CommentArr;


@property MBProgressHUD *hud;

@end

@implementation FollowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    //设置导航栏
    [self setNav];

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
    
    [self loadDingGeData];
    [self loadRecData];
    [self loadRevData];
    [self loadCommentData];
    [self loadShuoXiData];
    
    
    
    
    self.dataload = [[NSMutableArray alloc]init];
    
    [self setupHeader];
    [self setupFooter];

    
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

// NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3"};

- (void)loadShuoXiData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:ACTIVITY_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.ActivityArr = [ActivityModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             [self.hud setHidden:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
}



- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:DINGGE_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
            
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.seeCount = model.viewCount;
                 model.zambiaCount = model.voteCount;
                 NSInteger comments = model.comments.count;
                 NSString * com = [NSString stringWithFormat:@"%ld",comments];
                 model.answerCount = com;
                 //               NSLog(@"model.movie == %@",model.movie.title,nil);
                 model.movieName = model.movie.title;
                 model.nikeName = model.user.nickname;
                 model.time = [NSString stringWithFormat:@"1小时前"];
                 //创建MianDingGeModelFrame模型
                 DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
                 statusFrame.model = model;
                 [statusFrame setModel:model];
                 [statusFrames addObject:statusFrame];
             }
             
             
             self.statusFramesDingGe = statusFrames;
             [self.tableView reloadData];
             
             [self.hud setHidden:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
}
-(void)loadRecData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3"};
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


-(void)loadRevData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3"};
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

- (void)loadCommentData{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *url = @"http://fl.limijiaoyin.com:1337/comment";
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"评论内容-----%@",responseObject);
             self.CommentArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject];
             //将里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (CommentModel * model in self.CommentArr) {
                 //  CommentModel * status = [[CommentModel alloc]init];
                 model.comment= model.content;
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.nickName = [NSString stringWithFormat:@"霍比特人"];
                 model.time = [NSString stringWithFormat:@"1小时前"];
                 model.zambiaCounts = @"600";
                 
                 //创建MLStatusFrame模型
                 CommentModelFrame *modelFrame = [[CommentModelFrame alloc]init];
                 modelFrame.model = model;
                 [modelFrame setModel:model];
                 [statusFrames addObject:modelFrame];
             }
             
             self.statusFramesComment = statusFrames;
             
             
             
             
             [self.tableView reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
         }];
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        
        return self.ActivityArr.count;
    
    }else if(section==1){
        
        return [DingGeArr count];
        
    }else if(section==2){
        
        return [self.RecArr count];
        
    }else{
        
        return [self.RevArr count];
    }
//    else{
//        return self.statusFramesComment.count;
//    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        
        NSString *ID = [NSString stringWithFormat:@"ShuoXi"];
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        [cell setup:self.ActivityArr[indexPath.row]];
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shuoxiuserbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        


        
        return cell;

    
    
    }else if(indexPath.section == 1) {
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置cell
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        NSString * string = model.image;
        
        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        
        [imageView setImage:cell.movieImg.image];
        
        [cell.contentView addSubview:imageView];
        
        
        
        cell.message.text = model.content;
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];
        
        
        
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
        
        
        cell.tagEditorImageView.viewC = self;
        
        
        if (model.viewCount == nil) {
            [cell.seeBtn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        }
        
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",model.viewCount] forState:UIControlStateNormal];
        [cell.seeBtn addTarget:self action:@selector(seebtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.seeBtn];
        
        

        
       
        
        
        return cell;
    }else if (indexPath.section==2){
        
        
        
        NSString *ID = [NSString stringWithFormat:@"rec"];
        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[RecMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RecArr[indexPath.row]];
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recuserbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recmoviebtn:)];
        
        [cell.movieName addGestureRecognizer:movieGesture];
        
        
        [cell.screenBtn addTarget:self action:@selector(recscreenbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.screenBtn];
        
        
        return cell;

        
        
    
    
    }else{
        
        NSString *ID = [NSString stringWithFormat:@"REVIEW"];
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ReviewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RevArr[indexPath.row]];
        
        ReviewModel * model = self.RevArr[indexPath.row];
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zamrevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userrevbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        //        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moviebtn:)];
        //
        //        [cell.movieName addGestureRecognizer:movieGesture];
        
        
        [cell.screenBtn addTarget:self action:@selector(screenrevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.screenBtn];
        
        
        [cell.answerBtn addTarget:self action:@selector(answerrevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.answerBtn];
        
        
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",model.viewCount] forState:UIControlStateNormal];
        [cell.seeBtn addTarget:self action:@selector(seerevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.seeBtn];

        
        return cell;

    
    
    }
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0){
    
          return 280;
    
    
    }else if (indexPath.section==1)
    {
        
        DingGeModelFrame *statusFrame = self.statusFramesDingGe[indexPath.row];
        return statusFrame.cellHeight;
    }else if (indexPath.section==2){
    
        return 300;
    
    
    }else{
        
        return 270;
    
    }
  
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

-(void)shuoxiuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ActivityModel *model = self.ActivityArr[indexPath.row];
    
    taviewcontroller.userimage = model.user.avatarURL ;
    taviewcontroller.nickname = model.user.nickname;
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}



-(void)zamrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/votecount",@"http://fl.limijiaoyin.com:1337/review/",model.reviewId];
    
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
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
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
    
    
    
    
    
    [self.navigationController pushViewController:dinggesecond animated:YES];
    
    
}

-(void)seebtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
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
    
    
    
    [self.navigationController pushViewController:dinggesecond animated:YES];
    
    
}


-(void)answerbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
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
    
    
    [self.navigationController pushViewController:dinggesecond animated:YES];
    
    
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
    
    
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
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
    
    
}

-(void)screenrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/review/",model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    
    
    [self.navigationController pushViewController:revsecond animated:YES];
    
    
}

-(void)seerevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/review/",model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    [self.navigationController pushViewController:revsecond animated:YES];
    
    
}


-(void)answerrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/review/",model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    [self.navigationController pushViewController:revsecond animated:YES];
    
    
}



-(void)userrevbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    taviewcontroller.userimage = model.user.avatarURL ;
    taviewcontroller.nickname = model.user.nickname;
    
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)movierevbtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
}

-(void)recuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.RecArr[indexPath.row];
    
    taviewcontroller.userimage = model.user.avatarURL ;
    taviewcontroller.nickname = model.user.nickname;
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)recmoviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.RecArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
}

-(void)recscreenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
    
    RecModel *model = self.RecArr[indexPath.row];
    
    
    RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
    
    rec.hidesBottomBarWhenPushed = YES;
    
    
    
    rec.recimage = model.image;
    rec.recID  = model.recId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/recommend/",model.recId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    
    
    [self.navigationController pushViewController:rec animated:YES];
    
    
}








-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section==0){
        
        ShuoXiSecondViewController * shuoxi =[[ShuoXiSecondViewController alloc]init];
        shuoxi.hidesBottomBarWhenPushed = YES;
        
        ActivityModel *model = self.ActivityArr[indexPath.row];
        shuoxi.movie = model.movie;
        
        [self.navigationController pushViewController:shuoxi animated:YES];
    
    
    }else if (indexPath.section==1)
    
    {
        
        DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
        
        dingge.hidesBottomBarWhenPushed = YES;
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        dingge.dingimage = model.image;
        
        dingge.DingID  = model.ID;
        
        
        
        [self.navigationController pushViewController:dingge animated:YES];
        

    }else if (indexPath.section==2){
        
        RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
        
         rec.hidesBottomBarWhenPushed = YES;
        
        RecModel * model = self.RecArr[indexPath.row];
        
        rec.recimage = model.image;
        
        rec.recID = model.recId;
        

        
        [self.navigationController pushViewController:rec animated:YES];
        
    }else{
        
        ReviewSecondViewController * rev = [[ReviewSecondViewController alloc]init];
        
        rev.hidesBottomBarWhenPushed = YES;
        
        ReviewModel * model = self.RevArr[indexPath.row];
        
        rev.revimage = model.image;
        
        rev.revID = model.reviewId;
        

        
        [self.navigationController pushViewController:rev animated:YES];
        
        
    }
    
}

- (IBAction)follow:(id)sender {
 //   NSLog(@"open follow scene",nil);
}

- (IBAction)publish:(id)sender {
    // 创建发布页面导航控制器
//    PublishViewController *publishview = [[PublishViewController alloc]init];
//    [self.navigationController pushViewController:publishview animated:YES];
    ChooseMovieViewController *view = [[ChooseMovieViewController alloc]init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
    
    
}

- (IBAction)addPerson:(UIButton *)sender {
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    AddPersonViewController *addPer = [[AddPersonViewController alloc]init];
    addPer.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addPer animated:YES];
}

#pragma mark - 试图将要进入执行的方法
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = NO;

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

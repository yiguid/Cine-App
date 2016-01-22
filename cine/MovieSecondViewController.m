//
//  MovieSecondViewController.m
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "MovieSecondViewController.h"
#import "MovieModel.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "ShuoXiImgTableViewCell.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModel.h"
#import "DingGeModelFrame.h"
#import "DinggeSecondViewController.h"
#import "ShuoXiModel.h"
#import "ShuoxiViewController.h"
#import "MovieViewController.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "RecModel.h"
#import "RecMovieTableViewCell.h"
#import "ReviewModel.h"
#import "ReviewTableViewCell.h"
#import "RecommendSecondViewController.h"
#import "ReviewSecondViewController.h"
#import "ShuoxiTwoViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "cine.pch"
#import "CineViewController.h"
#import "MyRecMovieViewController.h"
#import "MyLookViewController.h"
#import "ShuoxiTotalViewController.h"
#import "DinggeTotalViewController.h"
#import "TuijianTotalViewController.h"
#import "HaopingTotalViewController.h"
#import "TaViewController.h"
#import "AddPersonViewController.h"
#define tablewH self.view.frame.size.height-230
@interface MovieSecondViewController () <ChooseMovieViewDelegate>{
    
    MovieModel * movie;
    DingGeModel * dingge;
    NSMutableArray * ShuoXiArr;
    NSMutableArray * DingGeArr;
    
    NSString * fav;
    
    UIView * shareview;
    UIView * sharetwoview;
    
    NSString * sharestring;
    
    
    NSArray * jiangrenuser;
    
    
}
@property NSMutableArray *dataSource;

@property(nonatomic,strong)NSArray * ActivityArr;
@property(nonatomic,strong)NSArray * statusFramesDingGe;
@property(nonatomic, strong)NSMutableDictionary *cellHeightDic;
@property(nonatomic, strong)NSArray *statusFramesComment;
@property(nonatomic,strong)NSArray * RecArr;
@property(nonatomic,strong)NSArray * RevArr;
@property(nonatomic,strong)NSArray * CommentArr;
@property MBProgressHUD *hud;

@property(nonatomic,strong)NSArray * movieshuoxiarr;
@property(nonatomic,strong)NSArray * moviedinggearr;
@property(nonatomic,strong)NSArray * movietuijianarr;
@property(nonatomic,strong)NSArray * moviehaopingarr;
@property(nonatomic,strong)NSArray * Mymoviearr;
@property(nonatomic,strong)NSArray * tuijianarr;

@property(nonatomic,strong)DingGeModel * sharedingge;
@property(nonatomic,strong)RecModel * sharerec;
@property(nonatomic,strong)ReviewModel * sharerev;


@end

@implementation MovieSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"说戏#%@#详情",self.ID);
    
    
    self.title = self.name;
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title =@"";
    self.navigationItem.backBarButtonItem = backIetm;
    
    [DingGeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{@"ID" : @"id"};
    }];
    
    ShuoXiArr = [NSMutableArray array];
    DingGeArr = [NSMutableArray array];
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen-64) style:UITableViewStylePlain];
    
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableview];

    
    
    
    
    _starrings = [[NSMutableArray alloc]init];
    _genres = [[NSMutableArray alloc]init];
    
    
    
    [self setupHeader];
    [self setupFooter];
    
    
    [self loadmovie];
    [self loadDingGe];
    [self loadRecData];
    [self loadRevData];
    [self loadShuoXiData];
    
    [self loadmovieshuoxi];
    [self loadmoviedingge];
    [self loadmovietuijian];
    [self loadmoviehaoping];
    
    [self loadMymovie];
    
    [self shareData];
    [self sharetwoData];
    
    [self loadtuijianData];
    
    
    self.cellHeightDic = [[NSMutableDictionary alloc] init];
    
    
    
}



-(void)shareData{
    
    shareview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen, wScreen, hScreen/3+44)];
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
    [jubao addTarget:self action:@selector(jubaobtn:) forControlEvents:UIControlEventTouchUpInside];
    [jubao setImage:[UIImage imageNamed:@"举报@2x.png"] forState:UIControlStateNormal];
    [shareview addSubview:jubao];
    
    UILabel * jubaolabel = [[UILabel alloc]initWithFrame:CGRectMake(20,170,40, 40)];
    jubaolabel.text = @"举报";
    jubaolabel.textAlignment = NSTextAlignmentCenter;
    jubaolabel.font = TextFont;
    [shareview addSubview:jubaolabel];
    
    UIButton * delete = [[UIButton alloc]initWithFrame:CGRectMake(imgW+30,130, 40, 40)];
    [delete addTarget:self action:@selector(deletebtn:) forControlEvents:UIControlEventTouchUpInside];
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
    
    sharetwoview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen, wScreen, hScreen/3+44)];
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
    
    
    UIButton * jubao = [[UIButton alloc]initWithFrame:CGRectMake(20,130, 40, 40)];
    [jubao addTarget:self action:@selector(jubaobtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [jubao setImage:[UIImage imageNamed:@"举报@2x.png"] forState:UIControlStateNormal];
    [sharetwoview addSubview:jubao];
    
    UILabel * jubaolabel = [[UILabel alloc]initWithFrame:CGRectMake(20,170,40, 40)];
    jubaolabel.text = @"举报";
    jubaolabel.textAlignment = NSTextAlignmentCenter;
    jubaolabel.font = TextFont;
    [sharetwoview addSubview:jubaolabel];
    
    
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
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
}


-(void)jubaobtn:(id)sender{
    
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    // Set custom view mode
    self.hud.mode = MBProgressHUDModeCustomView;
    
    self.hud.labelText = @"已举报";//显示提示
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
    
    
    
    if ([sharestring isEqualToString:@"定格"]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        NSUserDefaults * CommentDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [CommentDefaults objectForKey:@"userID"];
        NSDictionary * param = @{@"user":userID,@"content":self.sharedingge.content,@"targetType":@"0",@"target":self.sharedingge.ID};
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:Jubao_API parameters:param
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  [self.hud show:YES];
                  [self.hud hide:YES afterDelay:1];
                  
                  NSLog(@"举报成功,%@",responseObject);
                  
                  shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                  sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                  shareview.hidden = YES;
                  sharetwoview.hidden = YES;
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
    }else if ([sharestring isEqualToString:@"好评"]){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        NSUserDefaults * CommentDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [CommentDefaults objectForKey:@"userID"];
        NSDictionary * param = @{@"user":userID,@"content":self.sharerev.content,@"targetType":@"5",@"target":self.sharerev.reviewId};
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:Jubao_API parameters:param
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  [self.hud show:YES];
                  [self.hud hide:YES afterDelay:1];
                  
                  NSLog(@"举报成功,%@",responseObject);
                  
                  shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                  sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                  shareview.hidden = YES;
                  sharetwoview.hidden = YES;
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
    }else if ([sharestring isEqualToString:@"推荐"]){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        NSUserDefaults * CommentDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [CommentDefaults objectForKey:@"userID"];
        NSDictionary * param = @{@"user":userID,@"content":self.sharerec.content,@"targetType":@"4",@"target":self.sharerec.recId};
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:Jubao_API parameters:param
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  [self.hud show:YES];
                  [self.hud hide:YES afterDelay:1];
                  
                  NSLog(@"举报成功,%@",responseObject);
                  
                  shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                  sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                  shareview.hidden = YES;
                  sharetwoview.hidden = YES;
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        
    }
    
    
    
}

-(void)deletebtn:(id)sender{
    
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    // Set custom view mode
    self.hud.mode = MBProgressHUDModeCustomView;
    
    self.hud.labelText = @"已删除";//显示提示
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
   
    
    
    if ([sharestring isEqualToString:@"定格"]) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        NSString *url = [NSString stringWithFormat:@"%@/%@",DINGGE_API,self.sharedingge.ID];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager DELETE:url parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [self.hud show:YES];
                    [self.hud hide:YES afterDelay:1];
                    
                    NSLog(@"删除成功");
                    [self loadDingGe];
                    
                    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                    shareview.hidden = YES;
                    sharetwoview.hidden = YES;
                    
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"请求失败,%@",error);
                }];
        
    }else if ([sharestring isEqualToString:@"好评"]){
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        NSString *url = [NSString stringWithFormat:@"%@/%@",REVIEW_API,self.sharerev.reviewId];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager DELETE:url parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [self.hud show:YES];
                    [self.hud hide:YES afterDelay:1];
                    
                    NSLog(@"删除成功");
                    [self loadRevData];
                    
                    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                    shareview.hidden = YES;
                    sharetwoview.hidden = YES;
                    
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"请求失败,%@",error);
                }];
        
    }else if ([sharestring isEqualToString:@"推荐"]){
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        NSString *url = [NSString stringWithFormat:@"%@/%@",REC_API,self.sharerec.recId];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager DELETE:url parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [self.hud show:YES];
                    [self.hud hide:YES afterDelay:1];
                    
                    NSLog(@"删除成功");
                    [self loadRecData];
                    
                    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                    shareview.hidden = YES;
                    sharetwoview.hidden = YES;
                    
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"请求失败,%@",error);
                }];
        
        
    }
    
    
    
}

-(void)loadMymovie{
    NSLog(@"loadMovieData",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    ///auth/:authId/favroiteMovies
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/favoriteMovies",USER_AUTH_API, userId];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        self.Mymoviearr = [MovieModel mj_objectArrayWithKeyValuesArray:responseObject];
   
        [self.tableview reloadData];
        
        
        NSLog(@"%@",self.Mymoviearr);
  
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
}


-(void)loadtuijianData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"movie":self.ID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.tuijianarr = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             

             

             
            
             
             [self.tableview reloadData];
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
             
         }];
    
}






-(void)loadmovie{
    
    //获取服务器数据
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/%@",MOVIE_API,self.ID];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        movie = [MovieModel mj_objectWithKeyValues:responseObject];
        
        
        _starrings = movie.starring;
        _genres = movie.genre;
        
        
        
        
        //NSLog(@"---------%@",movie.cover);
        NSLog(@"----23%@",responseObject);
        
        
        [self.tableview reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
        
    }];
    
    
}

- (void)loadShuoXiData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3",@"movie":self.ID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:ACTIVITY_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.ActivityArr = [ActivityModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableview reloadData];
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
         }];
}





- (void)loadDingGe{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3",@"movie":self.ID};
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
                 NSInteger comments = model.comments.count;
                 NSString * com = [NSString stringWithFormat:@"%ld",(long)comments];
                 model.answerCount = com;
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
             
             
             [self.tableview reloadData];
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
             
         }];
}

-(void)loadRecData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3",@"movie":self.ID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RecArr = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableview reloadData];
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
             
         }];
    
}


-(void)loadRevData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3",@"movie":self.ID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REVIEW_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RevArr = [ReviewModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableview reloadData];
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
             
         }];
    
}

- (void)loadCommentData{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *url = COMMENT_API;
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
             
             
             
             
             [self.tableview reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
         }];
    
    
}


- (void)loadmovieshuoxi{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"movie"] = self.ID;
    param[@"sort"] = @"createdAt DESC";
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:ACTIVITY_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.movieshuoxiarr = [ActivityModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableview reloadData];
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
         }];
}



- (void)loadmoviedingge{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"movie"] = self.ID;
    param[@"sort"] = @"createdAt DESC";
    [manager GET:DINGGE_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.moviedinggearr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             
             [self.tableview reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
         }];
}


-(void)loadmovietuijian{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"movie"] = self.ID;
    param[@"sort"] = @"createdAt DESC";
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.movietuijianarr = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableview reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
}

-(void)loadmoviehaoping{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"movie"] = self.ID;
    param[@"sort"] = @"createdAt DESC";
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REVIEW_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.moviehaopingarr = [ReviewModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableview reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
}



- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //    self.tabBarController.tabBar.hidden = YES;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    //分组数
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    //设置每个分组下tableview的行数
    
    if (section==0) {
        return 1;
    }
    else if(section==1){
        return 1;
    }
    else if (section==2){
        
        
        return self.ActivityArr.count;
    }
    else if(section==3){
        
        return 1;
        
    }
    else if(section==4){
        
        return self.statusFramesDingGe.count;
        
    }
    else if(section==5){
        
        return 1;
        
    }
    
    else if(section ==6){
        
        return [self.RecArr count];
        
    }
    else if(section ==7){
        
        return 1;
        
    }
    
    else if(section ==8){
        
        return [self.RevArr count];
        
        
    }else{
        
        return 1;
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        
        static NSString * CellIndentifier = @"CellTableIdentifier";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        UIView *movieView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,170)];
        movieView.backgroundColor = [UIColor colorWithRed:28.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
        
        [self.tableview addSubview:movieView];
        [movieView addSubview:cell.contentView];
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, wScreen/4, 140)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:movie.cover] placeholderImage:nil];
        
        [imageView setImage:imageView.image];
        
        [cell.contentView addSubview:imageView];
        
        
        UILabel *dirnameLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 20, 50, 14)];
        dirnameLabel.text=@"导演:";
        dirnameLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:dirnameLabel];
        UILabel * director = [[UILabel alloc]initWithFrame:CGRectMake(200, 20, wScreen/3, 14)];
        director.backgroundColor = [UIColor clearColor];
        director.textColor = [UIColor whiteColor];
        director.text = movie.director;
        [cell.contentView addSubview:director];
        
        UILabel *yearLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 45, 50, 14)];
        yearLabel.text=@"年份:";
        yearLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:yearLabel];
        UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(200, 45, wScreen/3, 14)];
        year.backgroundColor = [UIColor clearColor];
        year.textColor = [UIColor whiteColor];
        year.text = movie.year;
        [cell.contentView addSubview:year];
        
        
        UILabel *initLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 72, 50, 14)];
        initLabel.text=@"地区:";
        initLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:initLabel];
        UILabel * initial = [[UILabel alloc]initWithFrame:CGRectMake(200, 72, wScreen/2, 14)];
        initial.backgroundColor = [UIColor clearColor];
        initial.textColor = [UIColor whiteColor];
        initial.text = movie.initialReleaseDate ;
        [cell.contentView addSubview:initial];
        
        UILabel *genreLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 98, 50, 14)];
        genreLabel.text=@"类型:";
        genreLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:genreLabel];
        UILabel * genre = [[UILabel alloc]initWithFrame:CGRectMake(200, 98, wScreen/2, 14)];
        genre.backgroundColor = [UIColor clearColor];
        NSString * genreString = [_genres componentsJoinedByString:@","];
        genre.textColor = [UIColor whiteColor];
        genre.text = genreString;
        [cell.contentView addSubview:genre];
        
        
        
        UILabel * ratingLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 130,50, 14)];
        ratingLabel.text=@"收藏:";
        ratingLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:ratingLabel];
        
        UIButton * ratingbtn = [[UIButton alloc]initWithFrame:CGRectMake(130, 130, 60, 14)];
        
        [cell.contentView addSubview:ratingbtn];
        [ratingbtn addTarget:self action:@selector(ratingbtn:) forControlEvents:UIControlEventTouchUpInside];

        
        
        for (MovieModel * model in self.Mymoviearr) {
            
        if ([movie.ID isEqual:model.ID]) {
            
            ratingLabel.text = @"已收藏:";
            ratingLabel.frame = CGRectMake(130, 130, 60, 14);
            ratingbtn.frame = CGRectMake(0, 0, 0, 0);
           
                
        }else{
            
            
             }
        }
        
        
        
        NSInteger favor = movie.favoriteby.count;
        fav = [NSString stringWithFormat:@"%ld",favor];
        
        UILabel * rating = [[UILabel alloc]initWithFrame:CGRectMake(200, 130, wScreen/3, 14)];
        rating.backgroundColor = [UIColor clearColor];
        rating.textColor = [UIColor whiteColor];
        rating.text = [NSString stringWithFormat:@"(已有%@人收藏)",fav];
        [cell.contentView addSubview:rating];
        
        
        
        // Configure the cell...
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }
    else if (indexPath.section==1){
        
        
        static NSString * CellIndentifier = @"Cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        CGFloat imgW = (wScreen-200)/6;
        
        
        NSInteger i = 0;
        
        for(RecModel * model in self.tuijianarr) {
            
//            model.avatarURL = model.user.avatarURL;
            
//            NSLog(@"%@",model.avatarURL);
            UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10 + i*10+imgW*i, 10, 30, 30)];
            
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [imageView1 setImage:imageView1.image];
                //头像圆形
                imageView1.layer.masksToBounds = YES;
                imageView1.layer.cornerRadius = imageView1.frame.size.width/2;
            }];
            
            [cell.contentView addSubview:imageView1];
            i++;
        }

        
        
        

//        UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
//        
//        [imageView1 sd_setImageWithURL:[NSURL URLWithString:jiangrenuser] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [imageView1 setImage:imageView1.image];
//            //头像圆形
//            imageView1.layer.masksToBounds = YES;
//            imageView1.layer.cornerRadius = imageView1.frame.size.width/2;
//        }];
//        
//        [cell.contentView addSubview:imageView1];
        
      
//        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imgW+20, 10, 30, 30)];
//        
//        [imageView2 sd_setImageWithURL:[NSURL URLWithString:jiangrenuser] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [imageView2 setImage:imageView2.image];
//            //头像圆形
//            imageView2.layer.masksToBounds = YES;
//            imageView2.layer.cornerRadius = imageView2.frame.size.width/2;
//        }];
//
//        [cell.contentView addSubview:imageView2];
//        
//       
//        UIImageView * imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(imgW*2+30, 10, 30, 30)];
//        
//        [imageView3 sd_setImageWithURL:[NSURL URLWithString:jiangrenuser] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [imageView3 setImage:imageView3.image];
//            //头像圆形
//            imageView3.layer.masksToBounds = YES;
//            imageView3.layer.cornerRadius = imageView3.frame.size.width/2;
//        }];
//
//        [cell.contentView addSubview:imageView3];
//        
//       
//        UIImageView * imageView4= [[UIImageView alloc]initWithFrame:CGRectMake(imgW*3+40, 10, 30, 30)];
//        
//        [imageView4 sd_setImageWithURL:[NSURL URLWithString:jiangrenuser] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [imageView4 setImage:imageView4.image];
//            //头像圆形
//            imageView4.layer.masksToBounds = YES;
//            imageView4.layer.cornerRadius = imageView4.frame.size.width/2;
//        }];
//
//        [cell.contentView addSubview:imageView4];
//        
//      
//        UIImageView * imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(imgW*4+50, 10, 30, 30)];
//        
//        [imageView5 sd_setImageWithURL:[NSURL URLWithString:jiangrenuser] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [imageView5 setImage:imageView5.image];
//            //头像圆形
//            imageView5.layer.masksToBounds = YES;
//            imageView5.layer.cornerRadius = imageView5.frame.size.width/2;
//        }];
//
//        [cell.contentView addSubview:imageView5];
//        
//        
//        UIImageView * imageView6 = [[UIImageView alloc]initWithFrame:CGRectMake(imgW*5+60, 10, 30, 30)];
//        
//        [imageView6 sd_setImageWithURL:[NSURL URLWithString:jiangrenuser] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [imageView6 setImage:imageView6.image];
//            //头像圆形
//            imageView6.layer.masksToBounds = YES;
//            imageView6.layer.cornerRadius = imageView1.frame.size.width/2;
//        }];
//
//        [cell.contentView addSubview:imageView6];
        
        
        
        NSInteger tuijian = self.tuijianarr.count;
        NSString * tui = [NSString stringWithFormat:@"%ld",tuijian];
        
        
        if (tuijian>0) {
            UIButton * text = [[UIButton alloc]initWithFrame:CGRectMake(imgW*6+70,10,120, 30)];
            [text setTitle:[NSString stringWithFormat:@"%@ 位匠人推荐",tui] forState:UIControlStateNormal];
            text.titleLabel.font = TextFont;
            text.backgroundColor = [UIColor grayColor];
            text.layer.masksToBounds = YES;
            text.layer.cornerRadius = 4.0;
            [cell.contentView addSubview:text];
            [text addTarget:self action:@selector(textbtn:) forControlEvents:UIControlEventTouchUpInside];
            

        }else{
        }
        
        
        
        
        
        
        UILabel * text1 = [[UILabel alloc]initWithFrame:CGRectMake(10,60, 70, 20)];
        text1.text = @"导演好";
        text1.textColor = [UIColor grayColor];
        text1.textAlignment = NSTextAlignmentCenter;
        text1.layer.borderColor = [[UIColor grayColor]CGColor];
        text1.layer.borderWidth = 1.0f;
        text1.layer.masksToBounds = YES;
        text1.font = TextFont;
        [cell.contentView addSubview:text1];
        UILabel * text2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 60,70, 20)];
        text2.text = @"视觉好";
        text2.textColor = [UIColor grayColor];
        text2.textAlignment = NSTextAlignmentCenter;
        text2.layer.borderColor = [[UIColor grayColor]CGColor];
        text2.layer.borderWidth = 1.0f;
        text2.layer.masksToBounds = YES;
        text2.font = TextFont;
        [cell.contentView addSubview:text2];
        UILabel * text3 = [[UILabel alloc]initWithFrame:CGRectMake(170, 60,70, 20)];
        text3.text = @"摄影好";
        text3.textColor = [UIColor grayColor];
        text3.textAlignment = NSTextAlignmentCenter;
        text3.layer.borderColor = [[UIColor grayColor]CGColor];
        text3.layer.borderWidth = 1.0f;
        text3.layer.masksToBounds = YES;
        text3.font = TextFont;
        [cell.contentView addSubview:text3];
        
        UILabel * text4 = [[UILabel alloc]initWithFrame:CGRectMake(250, 60,70, 20)];
        text4.text = @"音乐好";
        text4.textColor = [UIColor grayColor];
        text4.textAlignment = NSTextAlignmentCenter;
        text4.layer.borderColor = [[UIColor grayColor]CGColor];
        text4.layer.borderWidth = 1.0f;
        text4.layer.masksToBounds = YES;
        text4.font = TextFont;
        [cell.contentView addSubview:text4];
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }
    else if(indexPath.section==2){
        
        NSString *ID = [NSString stringWithFormat:@"ShuoXi"];
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        [cell setup:self.ActivityArr[indexPath.row]];
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shuoxiuserbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
        
        
    }
    else if(indexPath.section==3){
        static NSString * CellIndentifier = @"quanbushuoxi";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        if (self.ActivityArr.count>=3) {
            
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(wScreen/3, 10, wScreen/3, 30);
            
            NSString * str = [NSString stringWithFormat:@"%ld",self.movieshuoxiarr.count];
            
            [button setTitle:[NSString stringWithFormat:@"全部%@条说戏",str] forState:UIControlStateNormal];
            
            
            
            
            
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            [button addTarget:self action:@selector(shuoxiBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:button];
            button.layer.cornerRadius = 5.0f;
            
            button.layer.masksToBounds = YES;
            
            button.layer.borderWidth = 0.5f;
            
            button.layer.borderColor = [[UIColor grayColor]CGColor];
            
            UIView *tempView = [[UIView alloc] init];
            [cell setBackgroundView:tempView];
            [cell setBackgroundColor:[UIColor clearColor]];
            
            cell .contentView .backgroundColor = [ UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
            
            
        }
        //         cell .contentView .backgroundColor = [ UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }
    
    else if (indexPath.section==4)
    {
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置cell
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        NSString * string = model.image;
        
        
        __weak MovieSecondViewController *weakSelf = self;
        
        //设置cell
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *url = [NSURL URLWithString:string];
        if( ![manager diskImageExistsForURL:url]){
            [imageView sd_cancelCurrentImageLoad];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"myBackImg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"Dingge Image Size: %f",image.size.height,nil);
                if (image.size.height > 0) {
                    cell.tagEditorImageView.imagePreviews.image = image;
                    CGFloat ratio = (wScreen - 10) / image.size.width;
                    cell.tagEditorImageView.frame = CGRectMake(5, 5, wScreen-10, image.size.height * ratio); //190
                    cell.tagEditorImageView.imagePreviews.frame = CGRectMake(5, 5, wScreen-20, image.size.height * ratio);
                    cell.commentview.frame = CGRectMake(5,image.size.height * ratio - 25,wScreen-20, 30);
                    DingGeModelFrame *statusFrame = weakSelf.statusFramesDingGe[indexPath.row];
                    statusFrame.imageHeight = image.size.height * ratio;
                    cell.ratio = ratio;
                    [cell setTags];
                    //                    [statusFrame setModel:model];
                    //                    [weakSelf.statusFramesDingGe setObject:statusFrame atIndexedSubscript:indexPath.row];
                    //                    ((DingGeModelFrame *)weakSelf.statusFramesDingGe[indexPath.row]).imageHeight = image.size.height;
                    //                    [((DingGeModelFrame *)weakSelf.statusFramesDingGe[indexPath.row]) setModel:model];
                    NSInteger height = [statusFrame getHeight:model];
                    [self.cellHeightDic setObject:[NSString stringWithFormat:@"%ld",(long)height] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                    //                    cell.modelFrame = statusFrame;
                    //                    [weakSelf performSelectorOnMainThread:@selector(reloadCellAtIndexPath:) withObject:indexPath waitUntilDone:NO];
                    
                    //                    [weakSelf.dingge reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf.tableview reloadData];
                }
            }];
        }else{
            UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            cell.tagEditorImageView.imagePreviews.image = image;
            
            CGFloat ratio = (wScreen - 10) / image.size.width;
            
            cell.tagEditorImageView.frame = CGRectMake(5, 5, wScreen-10, image.size.height * ratio); //190
            cell.tagEditorImageView.imagePreviews.frame = CGRectMake(5, 5, wScreen-20, image.size.height * ratio);
            cell.commentview.frame = CGRectMake(5,image.size.height * ratio - 25,wScreen-20, 30);
            NSLog(@"Dingge Image Size: %f",image.size.height * ratio,nil);
            DingGeModelFrame *statusFrame = weakSelf.statusFramesDingGe[indexPath.row];
            statusFrame.imageHeight = image.size.height * ratio;
            cell.ratio = ratio;
            [cell setTags];
            NSInteger height = [statusFrame getHeight:model];
            
            if([[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue] != height){
                //                [weakSelf.statusFramesDingGe setObject:statusFrame atIndexedSubscript:indexPath.row];
                //                ((DingGeModelFrame *)weakSelf.statusFramesDingGe[indexPath.row]).imageHeight = image.size.height;
                //                [((DingGeModelFrame *)weakSelf.statusFramesDingGe[indexPath.row]) setModel:model];
                //                [weakSelf.dingge reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.cellHeightDic setObject:[NSString stringWithFormat:@"%ld",(long)height] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                [weakSelf.tableview reloadData];
                //                [weakSelf.dingge reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        //        [cell.contentView addSubview:imageView];
        cell.message.text = model.content;
        [cell.contentView addSubview:cell.message];
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        cell.movieName.userInteractionEnabled = YES;
        
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
        
        
        
        
        
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
        //        cell.separatorColor = [UIColor redColor];//设置行间隔边框
        
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }
    else if(indexPath.section==5){
        
        static NSString * CellIndentifier = @"quanbutuijian";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        if (self.statusFramesDingGe.count>=3) {
            
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(wScreen/3, 10, wScreen/3, 30);
            
            NSString * str = [NSString stringWithFormat:@"%ld",self.moviedinggearr.count];
            
            [button setTitle:[NSString stringWithFormat:@"全部%@条定格",str] forState:UIControlStateNormal];
            
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            [button addTarget:self action:@selector(dinggeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:button];
            button.layer.cornerRadius = 5.0f;
            
            button.layer.masksToBounds = YES;
            
            button.layer.borderWidth = 0.5f;
            
            button.layer.borderColor = [[UIColor grayColor]CGColor];
            
            cell .contentView .backgroundColor = [ UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
            
            
        }
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }
    
    
    else if(indexPath.section==6){
        
        NSString *ID = [NSString stringWithFormat:@"Rec"];
        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[RecMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RecArr[indexPath.row]];
        
        
        RecModel *model = self.RecArr[indexPath.row];
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recuserbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        cell.movieName.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recmoviebtn:)];
        
        [cell.movieName addGestureRecognizer:movieGesture];
        
        
        if (model.thankCount == nil) {
            [cell.appBtn setTitle:[NSString stringWithFormat:@"0人 感谢"] forState:UIControlStateNormal];
        }
        [cell.appBtn setTitle:[NSString stringWithFormat:@"%@人 感谢",model.thankCount] forState:UIControlStateNormal];
        [cell.appBtn addTarget:self action:@selector(thankBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.appBtn];
        
        
        [cell.screenBtn addTarget:self action:@selector(recscreenbtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:cell.screenBtn];
        
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
        //        cell.separatorColor = [UIColor redColor];//设置行间隔边框
        
        
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if(indexPath.section==7){
        static NSString * CellIndentifier = @"quanbutuijian";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        if (self.RecArr.count>=3) {
            
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(wScreen/3, 10, wScreen/3, 30);
            
            NSString * str = [NSString stringWithFormat:@"%ld",self.movietuijianarr.count];
            
            [button setTitle:[NSString stringWithFormat:@"全部%@条推荐",str] forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            [button addTarget:self action:@selector(tuijianBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:button];
            button.layer.cornerRadius = 5.0f;
            
            button.layer.masksToBounds = YES;
            
            button.layer.borderWidth = 0.5f;
            
            button.layer.borderColor = [[UIColor grayColor]CGColor];
            
            cell .contentView .backgroundColor = [ UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
            
            
        }
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }
    
    else if(indexPath.section==8){
        
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
        
        
        cell.movieName.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moviebtn:)];
        
        [cell.movieName addGestureRecognizer:movieGesture];
        
        
        [cell.screenBtn addTarget:self action:@selector(screenrevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.screenBtn];
        
        
        [cell.answerBtn addTarget:self action:@selector(answerrevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.answerBtn];
        
        
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",model.viewCount] forState:UIControlStateNormal];
        [cell.seeBtn addTarget:self action:@selector(seerevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.seeBtn];
        
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
        //        cell.separatorColor = [UIColor redColor];//设置行间隔边框
        
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }else{
        static NSString * CellIndentifier = @"quanbuhaoping";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        if (self.RevArr.count>=3) {
            
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(wScreen/3, 10, wScreen/3, 30);
            NSString * str = [NSString stringWithFormat:@"%ld",self.moviehaopingarr.count];
            
            [button setTitle:[NSString stringWithFormat:@"全部%@条好评",str] forState:UIControlStateNormal];
            
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            [button addTarget:self action:@selector(haopingBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:button];
            button.layer.cornerRadius = 5.0f;
            
            button.layer.masksToBounds = YES;
            
            button.layer.borderWidth = 0.5f;
            
            button.layer.borderColor = [[UIColor grayColor]CGColor];
            
            cell .contentView .backgroundColor = [ UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
            
            
        }
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }
    
    
    return nil;
}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 170;
    }
    else if(indexPath.section==1) {
        
        return 100;
        
    }
    else if(indexPath.section==2){
        
        return 330;
        
    }
    else if(indexPath.section==3){
        
        if (self.ActivityArr.count>=3) {
            
            return 50;
        }else{
            
            return 0;
            
        }
        
    }
    
    else if (indexPath.section==4)
    {
        
        CGFloat height = [[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
        if(height > 0){
            return height;
        }else
            return 400;
    }
    else if(indexPath.section==5){
        
        if (self.statusFramesDingGe.count>=3) {
            
            return 50;
        }else{
            
            return 0;
            
        }
        
        
    }
    
    else if(indexPath.section==6){
        
        
        return 300;
        
        
    }
    else if(indexPath.section==7){
        
        if (self.RecArr.count>=3) {
            
            return 50;
        }else{
            
            return 0;
            
        }
        
        
    }
    else if (indexPath.section==8){
        
        ReviewModel *model = [self.RevArr objectAtIndex:indexPath.row];
        return [model getCellHeight];
        
    }else{
        
        if (self.RevArr.count>=3) {
            
            return 50;
        }else{
            
            return 0;
            
        }
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==2) {
        
        ShuoxiTwoViewController * shuoxi = [[ShuoxiTwoViewController alloc]init];
        shuoxi.hidesBottomBarWhenPushed = YES;
        ActivityModel *model = self.ActivityArr[indexPath.row];
        shuoxi.movie = model.movie;
        shuoxi.activityId = model.activityId;
        shuoxi.activityimage = model.image;
        
        shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
        sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;
        
        [self.navigationController pushViewController:shuoxi animated:YES];
        
        
    }
    
    else if (indexPath.section==4)
    {
        DinggeSecondViewController * DingViewController = [[DinggeSecondViewController alloc]init];
        DingViewController.hidesBottomBarWhenPushed = YES;
        DingGeModel *model = DingGeArr[indexPath.row];
        
        DingViewController.dingimage = model.image;
        
        DingViewController.DingID  = model.ID;
        
        shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;
        
        [self.navigationController pushViewController:DingViewController animated:YES];
        
    }
    //    else if (indexPath.section==6){
    //
    //        RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
    //        rec.hidesBottomBarWhenPushed = YES;
    //        RecModel * model = self.RecArr[indexPath.row];
    //
    //        rec.recimage = model.image;
    //
    //        rec.recID = model.recId;
    //
    //
    //        [self.navigationController pushViewController:rec animated:YES];
    //
    //    }
    else if (indexPath.section==8){
        
        ReviewSecondViewController * rev = [[ReviewSecondViewController alloc]init];
        rev.hidesBottomBarWhenPushed = YES;
        ReviewModel * model = self.RevArr[indexPath.row];
        
        rev.revimage = model.image;
        
        rev.revID = model.reviewId;
        
        shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;
        
        [self.navigationController pushViewController:rev animated:YES];
        
        
    }
    
    
}


/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==2) {
        
        if (self.ActivityArr.count>=1) {
            
            return 30;
            
        }else{
            
            return 0;
            
        }
        
    }else if(section == 4){
        
        if (self.statusFramesDingGe.count>=1) {
            
            return 30;
            
        }else{
            
            return 0;
            
        }
        
        
    }
    else if(section == 6){
        
        if (self.RecArr.count>=1) {
            
            return 30;
            
        }else{
            
            return 0;
            
        }
        
        
    }
    else if(section == 8){
        
        if (self.RevArr.count>=1) {
            
            return 30;
            
        }else{
            
            return 0;
            
        }
        
        
    }
    else{
        
        
        return 0;
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        
        if (self.ActivityArr.count>=1) {
            
            
            
            
            UIView * view = [[UIView alloc]init];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
            label.text = @"电影说戏";
            label.textColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1.0];
            [view addSubview:label];
            
            
            return view;
        }
    }
    else if(section == 4)
    {
        
        
        if (self.statusFramesDingGe.count>=1){
            
            
            UIView * view = [[UIView alloc]init];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
            label.text = @"电影定格";
            label.textColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1.0];
            [view addSubview:label];
            
            
            return view;
        }
        
        
    }else if(section == 6){
        
        
        if (self.RecArr.count>=1){
            
            
            
            UIView * view = [[UIView alloc]init];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
            label.text = @"电影推荐";
            label.textColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1.0];
            [view addSubview:label];
            
            
            return view;
            
        }
        
    }else if(section == 8){
        
        if (self.RevArr.count>=1){
            
            
            
            UIView * view = [[UIView alloc]init];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
            label.text = @"电影好评";
            label.textColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1.0];
            [view addSubview:label];
            
            
            
            return view;
            
        }
    }
    
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableview)
    {
        //为最高的那个headerView的高度
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
        
        
    }
    
    
}


-(void)ratingbtn:(id)sender{
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/favorite/%@", BASE_API,userId,self.ID];
    NSLog(@"收藏电影%@",url);
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"收藏成功,%@",responseObject);
              
              [self loadMymovie];
              [self loadmovie];
             

              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
}



-(void)textbtn:(id)sender{
    
    AddPersonViewController * person = [[AddPersonViewController alloc]init];
    
    person.hidesBottomBarWhenPushed = YES;
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:person animated:YES];
    
}



-(void)thankBtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableview indexPathForCell:cell];
    
    RecModel *model = self.RecArr[indexPath.row];
    
    
    
    NSInteger thank = [model.thankCount integerValue];
    thank = thank+1;
    model.thankCount = [NSString stringWithFormat:@"%ld",(long)thank];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/thank/recommend/%@",BASE_API,userId,model.recId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"感谢成功,%@",responseObject);
              [self loadRecData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
}






-(void)shuoxiBtn:(id)sender{
    ShuoxiTotalViewController * shuoxi = [[ShuoxiTotalViewController alloc]init];
    shuoxi.hidesBottomBarWhenPushed = YES;
    
    
    shuoxi.movieID = self.ID;
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:shuoxi animated:YES];
}
-(void)dinggeBtn:(id)sender{
    
    
    DinggeTotalViewController * ding = [[DinggeTotalViewController alloc]init];
    ding.hidesBottomBarWhenPushed = YES;
    
    ding.movieID = self.ID;
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:ding animated:YES];
    
    
    
}
-(void)tuijianBtn:(id)sender{
    
    TuijianTotalViewController * rec = [[TuijianTotalViewController alloc]init];
    rec.hidesBottomBarWhenPushed = YES;
    
    
    rec.movieID = self.ID;
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:rec animated:YES];
    
}
-(void)haopingBtn:(id)sender{
    
    HaopingTotalViewController * look = [[HaopingTotalViewController alloc]init];
    look.hidesBottomBarWhenPushed = YES;
    
    
    look.movieID = self.ID;
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:look animated:YES];
}



-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableview indexPathForCell:cell];
    
    
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",(long)zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/votecount",DINGGE_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"点赞成功,%@",responseObject);
              [self loadDingGe];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
}
-(void)zamrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableview indexPathForCell:cell];
    
    
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",(long)zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/votecount",REVIEW_API,model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"点赞成功,%@",responseObject);
              [self loadRevData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
}


-(void)screenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableview indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    sharestring = @"定格";
    
    self.sharedingge = model;
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
                
            }];
            
            
            shareview.hidden = NO;
        }else{
            
            shareview.hidden = YES;
            
             shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        }
        
        
        
    }
    else{
        
        if (sharetwoview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
                
            }];
            sharetwoview.hidden = NO;
        }else{
            
            sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
            
            sharetwoview.hidden = YES;
        }
        
        
        
    }
    
    
    
    
}

-(void)seebtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableview indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",DINGGE_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self loadDingGe];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:dinggesecond animated:YES];
    
    
}


-(void)answerbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableview indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",DINGGE_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self loadDingGe];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:dinggesecond animated:YES];
    
    
}



-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    taviewcontroller.model = model.user;
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    movieviewcontroller.name = model.movieName;
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
}



- (void)detailBtn:(UITapGestureRecognizer *)sender{
    
    
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",DINGGE_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self loadDingGe];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:dinggesecond animated:YES];
}


-(void)screenrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableview indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    self.sharerev = model;
    
    sharestring = @"推荐";
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
                
            }];
            
            
            shareview.hidden = NO;
        }else{
             shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
            
            shareview.hidden = YES;
        }
        
        
        
    }
    else{
        
        if (sharetwoview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
                
            }];
            sharetwoview.hidden = NO;
        }else{
            
            sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
            
            sharetwoview.hidden = YES;
        }
        
        
        
    }
    
    
}

-(void)seerevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableview indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",REVIEW_API,model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self loadRevData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:revsecond animated:YES];
    
    
}


-(void)answerrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableview indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",REVIEW_API,model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self loadRevData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:revsecond animated:YES];
    
    
}



-(void)userrevbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)shuoxiuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    
    ActivityModel *model = self.ActivityArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}





-(void)movierevbtn:(UITapGestureRecognizer *)sender{
    
    
    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview;
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
}

-(void)recuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    
    RecModel *model = self.RecArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)recmoviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    
    RecModel *model = self.RecArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
}

-(void)recscreenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableview indexPathForCell:cell];
    
    
    RecModel *model = self.RecArr[indexPath.row];
    
    self.sharerec = model;
    
    sharestring = @"推荐";
    
    
    RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
    
    rec.hidesBottomBarWhenPushed = YES;
    
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
                
            }];
            

            shareview.hidden = NO;
        }else{
            
            shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
            
            shareview.hidden = YES;
        }
        
        
        
    }
    else{
        
        if (sharetwoview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
                
            }];

            sharetwoview.hidden = NO;
        }else{
            
            sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);

            
            sharetwoview.hidden = YES;
        }
        
        
        
    }
    
    
    
    
}





- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableview];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                       
            [self loadmovie];
            [self loadDingGe];
            [self loadRecData];
            [self loadRevData];
            [self loadShuoXiData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableview];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadmovie];
        [self loadDingGe];
        [self loadRecData];
        [self loadRevData];
        [self loadShuoXiData];
        [self.refreshFooter endRefreshing];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [self setHidesBottomBarWhenPushed:NO];
    [super viewDidDisappear:animated];
}


@end

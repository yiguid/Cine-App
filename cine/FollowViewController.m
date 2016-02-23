//
//  FollowViewController.m
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "FollowViewController.h"
#import "AddPersonViewController.h"
#import "DingGeModel.h"
#import "MyDingGeTableViewCell.h"
#import "PublishViewController.h"
#import "ChooseMovieViewController.h"
#import "DingGeModelFrame.h"
#import "RecMovieTableViewCell.h"
#import "RecModel.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "TaViewController.h"
#import "DinggeSecondViewController.h"
#import "ReviewModel.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "ReviewTableViewCell.h"
#import "CommentTableViewCell.h"
#import "RecommendSecondViewController.h"
#import "ReviewSecondViewController.h"
#import "ShuoXiModel.h"
#import "ShuoxiViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "ShuoxiTwoViewController.h"
#import "MovieSecondViewController.h"
@interface FollowViewController (){
    
    NSMutableArray * DingGeArr;
    UserModel * user;
    NSString * page;
    
    UIView * shareview;
    UIView * sharetwoview;
    
    NSString * sharestring;
}
@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic, strong)NSMutableArray *dataload;
@property(nonatomic, strong)NSMutableDictionary *cellHeightDic;
@property(nonatomic, strong)NSArray *statusFramesComment;
@property(nonatomic, strong)NSArray *ActivityArr;
@property(nonatomic,strong)NSMutableArray * RecArr;
@property(nonatomic,strong)NSMutableArray * RevArr;
@property(nonatomic,strong)NSMutableArray * RedArr;
@property(nonatomic,strong)NSArray * CommentArr;
@property MBProgressHUD *hud;

@property(nonatomic,strong)DingGeModel * sharedingge;
@property(nonatomic,strong)RecModel * sharerec;
@property(nonatomic,strong)ReviewModel * sharerev;

@property(nonatomic,strong)NSMutableArray * followArr;
@property(nonatomic,strong)NSMutableArray * followDic;


@end

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置导航栏
    [self setNav];
    page = [[NSString alloc]init];
    page = @"10";
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen-108) style:UITableViewStylePlain];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
    

    [self loadfollowData];
    
    
    self.followArr = [[NSMutableArray alloc]init];
    self.followDic = [[NSMutableArray alloc]init];
    self.RecArr = [[NSMutableArray alloc]init];
    self.RevArr = [[NSMutableArray alloc]init];
        DingGeArr = [[NSMutableArray alloc]init];
    
    self.cellHeightDic = [[NSMutableDictionary alloc] init];
    
    self.dataload = [[NSMutableArray alloc]init];
    
    
    
    
    _followview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wScreen,65)];
    _followview.backgroundColor = [UIColor colorWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:0.9];
    [self.view addSubview:_followview];
    
    
    CGFloat img = (wScreen-120)/2;
    
    
    UIImageView * pingfen = [[UIImageView alloc]initWithFrame:CGRectMake(30,10,20,20)];
    pingfen.image=[UIImage imageNamed:@"guanzhu_fabuyingping@3x.png"] ;
    UILabel * pinglabel = [[UILabel alloc]initWithFrame:CGRectMake(15,35,60, 20)];
    pinglabel.text = @"电影评分";
    pinglabel.font = TextFont;
    
    UIButton * pingfenbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,wScreen/3,65)];
    [_followview addSubview:pingfenbtn];
    
    [pingfenbtn addTarget:self action:@selector(pingfenBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_followview addSubview:pingfen];
    [_followview addSubview:pinglabel];
    
    UIImageView * fadingge = [[UIImageView alloc]initWithFrame:CGRectMake(img+50,10,20,20)];
    UILabel * falabel = [[UILabel alloc]initWithFrame:CGRectMake(img+35,35,60,20)];
    falabel.text = @" 发定格";
    falabel.font = TextFont;
    
    fadingge.image=[UIImage imageNamed:@"guanzhu_fabudingge@3x.png"];
    
    UIButton * fadinggebtn = [[UIButton alloc]initWithFrame:CGRectMake(wScreen/3,0,wScreen/3,65)];
    [_followview addSubview:fadinggebtn];
    
    
    [fadinggebtn addTarget:self action:@selector(fadinggeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_followview addSubview:fadingge];
    [_followview addSubview:falabel];
    
    
    UIImageView * tuijian = [[UIImageView alloc]initWithFrame:CGRectMake(img*2+70,10,20,20)];
    
    UILabel * tuijianlabel = [[UILabel alloc]initWithFrame:CGRectMake(img*2+55,35,60,20)];
    tuijianlabel.text = @"推荐电影";
    tuijianlabel.font = TextFont;
    
    tuijian.image=[UIImage imageNamed:@"guanzhu_fabutuijian@3x.png"];
    
    UIButton * tuijianbtn = [[UIButton alloc]initWithFrame:CGRectMake(wScreen*2/3,0,wScreen/3,65)];
    [_followview addSubview:tuijianbtn];
    [tuijianbtn addTarget:self action:@selector(tuijianBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_followview addSubview:tuijian];
    [_followview addSubview:tuijianlabel];
    
    _followview.hidden = YES;
    
    [self setupHeader];
    [self setupFooter];
    
    [self shareData];
    [self sharetwoData];
    
    
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



-(void)shareData{
    
    shareview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen/2-44, wScreen, hScreen/3+44)];
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
    
    sharetwoview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen/2-44, wScreen, hScreen/3+44)];
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
    
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
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
                  
                  sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                  sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
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
                  
                  sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                  sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
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
                  
                  sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                  sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
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
                    [self loadfollowData];
                    
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
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
                    [self loadfollowData];
                    
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
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
                    [self loadfollowData];
                    
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    shareview.hidden = YES;
                    sharetwoview.hidden = YES;

                    
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"请求失败,%@",error);
                }];
        
        
    }
    
    
    
}



- (void)loadfollowData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
//        NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"0"};
    
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":page};
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/timeline",BASE_API,userId];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
//             self.followArr = [ActivityModel mj_objectArrayWithKeyValuesArray:responseObject];
             
//             NSMutableArray *statusFrames = [NSMutableArray array];
             for (NSDictionary * dic in responseObject) {
                 
                 if ([dic[@"type"]isEqualToString:@"post"]) {
                     
                     DingGeModel * model = [DingGeModel mj_objectWithKeyValues:dic];
                     
                     [self.followArr addObject:model];
//                     NSLog(@"DingGeArr------%@",model.content);
                     
                     
//                     [statusFrames addObject:statusFrame];
//                     
//                     self.statusFramesDingGe = statusFrames;
                     [self.followDic addObject:@"post"];
                     
                     
                 }else if ([dic[@"type"]isEqualToString:@"review"]){
                     
                     ReviewModel * model = [ReviewModel mj_objectWithKeyValues:dic];
                     
                     [self.followArr addObject:model];

                     [self.followDic addObject:@"review"];
                 
                 }else if([dic[@"type"] isEqualToString:@"recommend"]){
                     
                     RecModel * model = [RecModel mj_objectWithKeyValues:dic];
                     
                     [self.followArr addObject:model];

                     [self.followDic addObject:@"recommend"];

                     
                 }
                 
                 
             }
             
             
             [self.tableView reloadData];
             [self.hud setHidden:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.followArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    if ([self.followDic[indexPath.row] isEqualToString:@"post"])
    {
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        DingGeModel *model = self.followArr[indexPath.row];
        model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
        model.seeCount = model.viewCount;
        model.zambiaCount = model.voteCount;
        NSInteger comments = model.comments.count;
        NSString * com = [NSString stringWithFormat:@"%ld",(long)comments];
        model.answerCount = com;
        //               NSLog(@"model.movie == %@",model.movie.title,nil);
        model.movieName = model.movie.title;
        model.nikeName = model.user.nickname;
        model.movieName =[NSString stringWithFormat:@"《%@》",model.movie.title];
        model.time = model.createdAt;
        //创建MianDingGeModelFrame模型
        DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
        statusFrame.model = model;
        [statusFrame setModel:model];
        //设置cell
        cell.modelFrame = statusFrame;
        
        NSString * string = model.image;
        if([string containsString:@"(null)"])
            string = @"http://img3.douban.com/view/photo/photo/public/p2285067062.jpg";
        __weak FollowViewController *weakSelf = self;
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *url = [NSURL URLWithString:string];
        if( ![manager diskImageExistsForURL:url]){
            //            [imageView sd_cancelCurrentImageLoad];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"myBackImg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"Dingge Image Size: %f",image.size.height,nil);
                UIImage *img = imageView.image;
                if (img.size.height > 0) {
                    cell.tagEditorImageView.imagePreviews.image = img;
                    CGFloat ratio = (wScreen - 10) / img.size.width;
                    cell.tagEditorImageView.frame = CGRectMake(5, 5, wScreen-10, img.size.height * ratio); //190
                    cell.tagEditorImageView.imagePreviews.frame = CGRectMake(5, 5, wScreen-20, img.size.height * ratio);
                    cell.commentview.frame = CGRectMake(5,img.size.height * ratio - 25,wScreen-20, 30);
                    statusFrame.imageHeight = img.size.height * ratio;
                    cell.ratio = ratio;
                    [cell setTags];
                  
                    NSInteger height = [statusFrame getHeight:model];
                    [self.cellHeightDic setObject:[NSString stringWithFormat:@"%ld",(long)height] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                  
                    [weakSelf.tableView reloadData];
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
                [weakSelf.tableView reloadData];
                //                [weakSelf.dingge reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        //        [cell.contentView addSubview:imageView];
        
        
        
        cell.message.text = model.content;
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];
        
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        cell.commentview.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moviebtn:)];
        
        [cell.commentview addGestureRecognizer:movieGesture];
        
        
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
        
        
        
        
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;

       
    }else if ([self.followDic[indexPath.row] isEqualToString:@"recommend"]){
        
        NSString *ID = [NSString stringWithFormat:@"rec"];
        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[RecMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.followArr[indexPath.row]];
        
        RecModel *model = self.followArr[indexPath.row];
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recuserbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        cell.commentview.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recmoviebtn:)];
        
        [cell.commentview addGestureRecognizer:movieGesture];
        
        
        if (model.thankCount == nil) {
            [cell.appBtn setTitle:[NSString stringWithFormat:@"0人 感谢"] forState:UIControlStateNormal];
        }
        [cell.appBtn setTitle:[NSString stringWithFormat:@"%@人 感谢",model.thankCount] forState:UIControlStateNormal];
        [cell.appBtn addTarget:self action:@selector(thankBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.appBtn];
        
        
        [cell.screenBtn addTarget:self action:@selector(recscreenbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.screenBtn];
        
        
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
        
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
        

        
        
    }else  if ([self.followDic[indexPath.row] isEqualToString:@"review"]){
        
        NSString *ID = [NSString stringWithFormat:@"REVIEW"];
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ReviewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.followArr[indexPath.row]];
        
        ReviewModel * model = self.followArr[indexPath.row];
        
        
        [cell.zambiaBtn setTag:[indexPath row]];
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zamrevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userrevbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        
        
//        cell.movieName.text = [NSString stringWithFormat:@"《%@》",model.movie.title];
//        cell.movieName.textColor = [UIColor  colorWithRed:234/255.0 green:153/255.0 blue:0/255.0 alpha:1.0];
//        [cell.contentView addSubview:cell.movieName];
//        
//        cell.movieName.userInteractionEnabled = YES;
//        
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
        
        
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
        
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;

        
      
    
    }

    
    
    
    
    
       return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.followDic[indexPath.row] isEqualToString:@"post"])
    {
        
        CGFloat height = [[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
        if(height > 0){
            return height;
        }else
            return 400;
    }else if ([self.followDic[indexPath.row] isEqualToString:@"recommend"]){
        
        return wScreen+80;
        
        
    }else if ([self.followDic[indexPath.row] isEqualToString:@"review"]){
        
        ReviewModel *model = [self.followArr objectAtIndex:indexPath.row];
        return [model getCellHeight]+30;
        
    }else{
    
        return 340;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.followDic[indexPath.row] isEqualToString:@"review"]) {
        ReviewSecondViewController * rev = [[ReviewSecondViewController alloc]init];
        
        
        ReviewModel *model = self.followArr[indexPath.row];
        
        rev.revimage = model.image;
        rev.revID  = model.reviewId;
        
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
                  [self.tableView reloadData];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        
        
        rev.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:rev animated:YES];
        
    }
//    else if ([self.followDic[indexPath.row] isEqualToString:@"post"])
//        
//    {
//        
//        DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
//        
//        dingge.hidesBottomBarWhenPushed = YES;
//        
//        DingGeModel *model = DingGeArr[indexPath.row];
//        
//        dingge.dingimage = model.image;
//        
//        dingge.DingID  = model.ID;
//        
//        
//        _followview.hidden = YES;
//        
//        sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
//        sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
//        shareview.hidden = YES;
//        sharetwoview.hidden = YES;
//        
//        
//        [self.navigationController pushViewController:dingge animated:YES];
//        
//        
//    }
}


-(void)thankBtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    
    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.followArr[indexPath.row];
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if (cell.appBtn.selected == YES) {
        
        cell.appBtn.selected = NO;
        
        NSInteger thank = [model.thankCount integerValue];
        thank = thank+1;
        model.thankCount = [NSString stringWithFormat:@"%ld",(long)thank];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/thank/recommend/%@",BASE_API,userId,model.recId];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"感谢成功,%@",responseObject);
                  [self loadfollowData];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
    }else{
        
        
        
        self.hud.labelText = @"已感谢";
        [self.hud show:YES];
        [self.hud hide:YES afterDelay:1];
        
        NSLog(@"您已经感谢过了");
        
   
    
    }
}





-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
    if ([self.followDic[indexPath.row] isEqualToString:@"post"]){
    
    DingGeModel *model = self.followArr[indexPath.row];
    
    
    
    
    if (cell.zambiaBtn.selected == NO) {
        cell.zambiaBtn.selected = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDef stringForKey:@"userID"];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/vote/post/%@",BASE_API,userId,model.ID];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"赞成功,%@",responseObject);
                  [self loadfollowData];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        
        
        
        
    }else{
        
        cell.zambiaBtn.selected = NO;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDef stringForKey:@"userID"];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/unvote/post/%@",BASE_API,userId,model.ID];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"取消赞成功,%@",responseObject);
                  [self loadfollowData];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
    }

    }
    
}

//-(void)shuoxiuserbtn:(UITapGestureRecognizer *)sender{
//    
//    
//    
//    TaViewController * taviewcontroller = [[TaViewController alloc]init];
//    
//    
//    
//    taviewcontroller.hidesBottomBarWhenPushed = YES;
//    
//    UIImageView *imageView = (UIImageView *)sender.view;
//    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    
//    ActivityModel *model = self.ActivityArr[indexPath.row];
//    
//    taviewcontroller.model = model.user;
//    
//    _followview.hidden = YES;
//    
//    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
//    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
//    shareview.hidden = YES;
//    sharetwoview.hidden = YES;
//    
//    
//    [self.navigationController pushViewController:taviewcontroller animated:YES];
//    
//}



-(void)zamrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)btn.superview.superview;
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    if ([self.followDic[indexPath.row] isEqualToString:@"review"]) {
    
    ReviewModel *model = self.followArr[indexPath.row];
    
    
    
    if (cell.zambiaBtn.selected == NO) {
        cell.zambiaBtn.selected = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDef stringForKey:@"userID"];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/vote/review/%@",BASE_API,userId,model.reviewId];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"赞成功,%@",responseObject);
                  [self loadfollowData];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        
        
        
        
    }else{
        
        cell.zambiaBtn.selected = NO;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDef stringForKey:@"userID"];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/unvote/review/%@",BASE_API,userId,model.reviewId];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"取消赞成功,%@",responseObject);
                  [self loadfollowData];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        
    }
    }
}
-(void)screenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = self.followArr[indexPath.row];
    
    
    sharestring = @"定格";
    
    self.sharedingge = model;
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0, hScreen/2-44, wScreen, hScreen/3+44);
                
            }];
            
            
            shareview.hidden = NO;
        }else{
            
            shareview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
            
            shareview.hidden = YES;
        }
        
        
        
    }
    else{
        
        if (sharetwoview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                sharetwoview.frame = CGRectMake(0, hScreen/2-44, wScreen, hScreen/3+44);
                
            }];
            
            sharetwoview.hidden = NO;
        }else{
            
            sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
            
            sharetwoview.hidden = YES;
        }
        
        
        
    }
    
    
    
}

-(void)seebtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = self.followArr[indexPath.row];
    
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
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    _followview.hidden = YES;
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:dinggesecond animated:YES];
    
    
}


-(void)answerbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = self.followArr[indexPath.row];
    
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
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    _followview.hidden = YES;
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:dinggesecond animated:YES];
    
    
}



-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DingGeModel *model = self.followArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    
    _followview.hidden = YES;
    
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIView * label = (UIView *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DingGeModel *model = self.followArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    
    
    _followview.hidden = YES;
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
}



- (void)detailBtn:(UITapGestureRecognizer *)sender{
    
    
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DingGeModel *model = self.followArr[indexPath.row];
    
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
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    _followview.hidden = YES;
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:dinggesecond animated:YES];
}

-(void)screenrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.followArr[indexPath.row];
    
    
    sharestring = @"好评";
    
    self.sharerev = model;
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0, hScreen/2-44, wScreen, hScreen/3+44);
                
            }];
            
            shareview.hidden = NO;
        }else{
            
            shareview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
            
            shareview.hidden = YES;
        }
        
        
        
    }
    else{
        
        if (sharetwoview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                sharetwoview.frame = CGRectMake(0, hScreen/2-44, wScreen, hScreen/3+44);
                
            }];
            
            
            sharetwoview.hidden = NO;
        }else{
            
            sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
            
            
            sharetwoview.hidden = YES;
        }
        
        
        
    }
    
    
}

-(void)seerevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.followArr[indexPath.row];
    
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
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    _followview.hidden = YES;
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:revsecond animated:YES];
    
    
}


-(void)answerrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.followArr[indexPath.row];
    
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
              [self loadfollowData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    _followview.hidden = YES;
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:revsecond animated:YES];
    
    
}



-(void)userrevbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewModel *model = self.followArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    _followview.hidden = YES;
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

//-(void)movierevbtn:(UITapGestureRecognizer *)sender{
//    
//    
//    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
//    
//    movieviewcontroller.hidesBottomBarWhenPushed = YES;
//    
//    UILabel * label = (UILabel *)sender.view;;
//    UITableViewCell *cell = (UITableViewCell *)label.superview.superview;
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    
//    ReviewModel *model = self.followArr[indexPath.row];
//    
//    movieviewcontroller.ID = model.movie.ID;
//    
//    
//    _followview.hidden = YES;
//    
//    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
//    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
//    shareview.hidden = YES;
//    sharetwoview.hidden = YES;
//    
//    [self.navigationController pushViewController:movieviewcontroller animated:YES];
//    
//    
//}

-(void)recuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.followArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    
    _followview.hidden = YES;
    
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)recmoviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIView * label = (UIView *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.followArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    
    _followview.hidden = YES;
    
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
}

-(void)recscreenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
    sharestring = @"推荐";
    
    
    
    RecModel *model = self.followArr[indexPath.row];
    
    self.sharerec = model;
    
    
    RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
    
    rec.hidesBottomBarWhenPushed = YES;
    
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0, hScreen/2-44, wScreen, hScreen/3+44);
                
            }];
            
            shareview.hidden = NO;
        }else{
            
            shareview.frame = CGRectMake(0, hScreen/2-44, wScreen, hScreen/3+44);
            
            shareview.hidden = YES;
        }
        
        
        
    }
    else{
        
        if (sharetwoview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                sharetwoview.frame = CGRectMake(0, hScreen/2-44, wScreen, hScreen/3+44);
                
            }];
            
            sharetwoview.hidden = NO;
        }else{
            
            sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
            
            
            sharetwoview.hidden = YES;
        }
        
        
        
    }
    
    
    
    
}

- (IBAction)follow:(id)sender {
    //   NSLog(@"open follow scene",nil);
}

- (IBAction)publish:(id)sender {
    
    if ( _followview.hidden ==YES) {
        
        _followview.hidden = NO;
    }
    
    else{
        
        _followview.hidden = YES;
    }
    
    
    
}

- (IBAction)addPerson:(UIButton *)sender {
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    AddPersonViewController *addPer = [[AddPersonViewController alloc]init];
    addPer.hidesBottomBarWhenPushed = YES;
    
    _followview.hidden = YES;
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:addPer animated:YES];
}

-(void)pingfenBtn:(id)sender{
    
    
    
    ChooseMovieViewController *view = [[ChooseMovieViewController alloc]init];
    view.hidesBottomBarWhenPushed = YES;
    
    NSString * string = [[NSString alloc]init];
    string = @"评分";
    view.judge = string;
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:view animated:YES];
    
    
    _followview.hidden = YES;
    
    
    
    
}
-(void)fadinggeBtn:(id)sender{
    
    
    
    
    ChooseMovieViewController *view = [[ChooseMovieViewController alloc]init];
    view.hidesBottomBarWhenPushed = YES;
    
    NSString * string = [[NSString alloc]init];
    string = @"定格";
    view.judge = string;
    
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:view animated:YES];
    
    
    _followview.hidden = YES;
    
    
}
-(void)tuijianBtn:(id)sender{
    
    
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
    
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
    
    if ([user.catalog isEqualToString:@"1"]) {
        ChooseMovieViewController *view = [[ChooseMovieViewController alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        
        
        NSString * string = [[NSString alloc]init];
        string = @"推荐";
        view.judge = string;
        
        sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
        sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;
        
        
        [self.navigationController pushViewController:view animated:YES];
        
        
        
        _followview.hidden = YES;

    }else{
        
        
        self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:self.hud];
        // Set custom view mode
        self.hud.mode = MBProgressHUDModeCustomView;
        
        self.hud.labelText = @"您不是匠人";//显示提示
//        self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
        
        [self.hud show:YES];
        [self.hud hide:YES afterDelay:1];
        
    
        NSLog(@"您不是匠人");
    
    }
    
       
    
    
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
            
            [self loadfollowData];
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
       
        NSInteger a = [page intValue];
        a = a + a;
        page = [NSString stringWithFormat:@"%ld",(long)a];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        NSString *userId = [userDef stringForKey:@"userID"];
        
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":page};
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/timeline",BASE_API,userId];
        [manager GET:url parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 //             self.followArr = [ActivityModel mj_objectArrayWithKeyValuesArray:responseObject];
                 
                 //             NSMutableArray *statusFrames = [NSMutableArray array];
                 for (NSDictionary * dic in responseObject) {
                     
                     if ([dic[@"type"]isEqualToString:@"post"]) {
                         
                         DingGeModel * model = [DingGeModel mj_objectWithKeyValues:dic];
                         
                         [self.followArr addObject:model];
                         //                     NSLog(@"DingGeArr------%@",model.content);
                         
                         
                         //                     [statusFrames addObject:statusFrame];
                         //
                         //                     self.statusFramesDingGe = statusFrames;
                         [self.followDic addObject:@"post"];
                         
                         
                     }else if ([dic[@"type"]isEqualToString:@"review"]){
                         
                         ReviewModel * model = [ReviewModel mj_objectWithKeyValues:dic];
                         
                         [self.followArr addObject:model];
                         
                         [self.followDic addObject:@"review"];
                         
                     }else if([dic[@"type"] isEqualToString:@"recommend"]){
                         
                         RecModel * model = [RecModel mj_objectWithKeyValues:dic];
                         
                         [self.followArr addObject:model];
                         
                         [self.followDic addObject:@"recommend"];
                         
                         
                     }
                     
                     
                 }
                 
                 
                 [self.tableView reloadData];
                 [self.hud setHidden:YES];
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self.hud setHidden:YES];
                 NSLog(@"请求失败,%@",error);
             }];
        
        [self.refreshFooter endRefreshing];
    });
}
@end
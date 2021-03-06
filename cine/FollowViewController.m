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
#import "ShuoxiTwoViewController.h"
#import "MyshuoxiTableViewCell.h"
#import "MovieSecondViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface FollowViewController (){
    
    NSMutableArray * DingGeArr;
    UserModel * user;
    NSString * spage;
    NSString * lpage;
 
    
    UIView * shareview;
    UIView * sharetwoview;
    
    NSString * sharestring;
}
@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic, strong)NSMutableArray *dataload;
@property(nonatomic, strong)NSMutableDictionary *cellHeightDic;
@property(nonatomic, strong)NSArray *statusFramesComment;
@property(nonatomic, strong)NSArray *ActivityArr;
@property MBProgressHUD *hud;

@property(nonatomic,strong)DingGeModel * sharedingge;
@property(nonatomic,strong)RecModel * sharerec;
@property(nonatomic,strong)ReviewModel * sharerev;
@property(nonatomic,strong)ShuoXiModel * shareshuoxi;
@property (nonatomic, strong)MovieModel * sharemovie;
@property (nonatomic, strong)UIImage * shareimage;
@property(nonatomic,strong)NSMutableArray * followArr;
@property(nonatomic,strong)NSMutableArray * followDic;


@end

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置导航栏
    [self setNav];
    spage = [[NSString alloc]init];
    spage = @"0";
    lpage = [[NSString alloc]init];
    lpage = @"5";
    
    
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
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
    
    [self.hud show:YES];
    
    self.noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(wScreen/2-50,wScreen/4,100, 100)];
    self.noDataImageView.image=[UIImage imageNamed:@"图层-13@2x.png"];
    [self.tableView addSubview:self.noDataImageView];
    
    self.noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,110+wScreen/4,wScreen-40, 30)];
    self.noDataLabel.text = @"暂时还没有关注消息哦";
    self.noDataLabel.font = NameFont;
    self.noDataLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    self.noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:self.noDataLabel];
    
    
    self.followArr = [[NSMutableArray alloc]init];
    self.followDic = [[NSMutableArray alloc]init];
    DingGeArr = [[NSMutableArray alloc]init];
    
    self.cellHeightDic = [[NSMutableDictionary alloc] init];
    
    self.dataload = [[NSMutableArray alloc]init];
    
    
    self.zhedangBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];
    self.zhedangBtn.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.4];
    [self.view addSubview:self.zhedangBtn];
    [self.zhedangBtn addTarget:self action:@selector(zhedangBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.zheBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];
    self.zheBtn.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.4];
    [self.view addSubview:self.zheBtn];
    [self.zheBtn addTarget:self action:@selector(zheBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _followview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wScreen,65)];
    _followview.backgroundColor = [UIColor colorWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:0.9];
    [self.view addSubview:_followview];
    
    
    CGFloat img = (wScreen-120)/2;
    
    
    UIImageView * pingfen = [[UIImageView alloc]initWithFrame:CGRectMake(30,10,20,20)];
    pingfen.image=[UIImage imageNamed:@"guanzhu_fabuyingping@3x.png"] ;
    UILabel * pinglabel = [[UILabel alloc]initWithFrame:CGRectMake(15,35,60, 20)];
    pinglabel.text = @"发布影评";
    pinglabel.font = TextFont;
    
    UIButton * pingfenbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,wScreen/3,65)];
    [_followview addSubview:pingfenbtn];
    
    [pingfenbtn addTarget:self action:@selector(pingfenBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_followview addSubview:pingfen];
    [_followview addSubview:pinglabel];
    
    UIImageView * fadingge = [[UIImageView alloc]initWithFrame:CGRectMake(img+50,10,20,20)];
    UILabel * falabel = [[UILabel alloc]initWithFrame:CGRectMake(img+35,35,60,20)];
    falabel.text = @"发布定格";
    falabel.font = TextFont;
    
    fadingge.image=[UIImage imageNamed:@"guanzhu_fabudingge@3x.png"];
    
    UIButton * fadinggebtn = [[UIButton alloc]initWithFrame:CGRectMake(wScreen/3,0,wScreen/3,65)];
    [_followview addSubview:fadinggebtn];
    
    
    [fadinggebtn addTarget:self action:@selector(fadinggeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_followview addSubview:fadingge];
    [_followview addSubview:falabel];
    
    
    UIImageView * tuijian = [[UIImageView alloc]initWithFrame:CGRectMake(img*2+70,10,20,20)];
    
    UILabel * tuijianlabel = [[UILabel alloc]initWithFrame:CGRectMake(img*2+55,35,60,20)];
    tuijianlabel.text = @"发布推荐";
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

- (void)viewDidAppear:(BOOL)animated
{
    
    [self.followArr removeAllObjects];
    [self.followDic removeAllObjects];
    
    //获取数据
    [self loadfollowData];
    
}




/**
 * 设置导航栏
 */
- (void)setNav{
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       
       NSForegroundColorAttributeName:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3"};



-(void)shareData{
    
    shareview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen/2-44, wScreen,260)];
    shareview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shareview];
    
    UILabel * sharlabel = [[UILabel alloc]initWithFrame:CGRectMake(wScreen/3,10, wScreen/3, 20)];
    sharlabel.text = @"分享至";
    sharlabel.textAlignment =NSTextAlignmentCenter;
    sharlabel.textColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.0];
    [shareview addSubview:sharlabel];
    
    
    CGFloat imgW = (wScreen-30)/4;
    
    UIButton * sharweixin = [[UIButton alloc]initWithFrame:CGRectMake(20,40, 40, 40)];
    [sharweixin addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharweixin setImage:[UIImage imageNamed:@"shareweixin@2x.png"] forState:UIControlStateNormal];
    sharweixin.tag = 1;
    [shareview addSubview:sharweixin];
    
    UILabel * sharweixinlabel = [[UILabel alloc]initWithFrame:CGRectMake(20,80, 40, 40)];
    sharweixinlabel.text = @"微信";
    sharweixinlabel.textAlignment = NSTextAlignmentCenter;
    sharweixinlabel.font = TextFont;
    [shareview addSubview:sharweixinlabel];
    
    
    
    UIButton * sharfriend = [[UIButton alloc]initWithFrame:CGRectMake(imgW+30,40, 40, 40)];
    [sharfriend addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharfriend setImage:[UIImage imageNamed:@"sharepengyou@2x.png"] forState:UIControlStateNormal];
    sharfriend.tag =2;
    [shareview addSubview:sharfriend];
    
    
    UILabel * sharfriendlabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW+30,80, 40, 40)];
    sharfriendlabel.text = @"朋友圈";
    sharfriendlabel.textAlignment = NSTextAlignmentCenter;
    sharfriendlabel.font = TextFont;
    [shareview addSubview:sharfriendlabel];
    
    
    UIButton * sharxinlang = [[UIButton alloc]initWithFrame:CGRectMake(imgW*2+40,40, 40, 40)];
    [sharxinlang addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharxinlang setImage:[UIImage imageNamed:@"shareweibo@2x.png"] forState:UIControlStateNormal];
    sharxinlang.tag =3;
    [shareview addSubview:sharxinlang];
    
    UILabel * sharxinlanglabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW*2+30,80,60, 40)];
    sharxinlanglabel.text = @"新浪微博";
    sharxinlanglabel.textAlignment = NSTextAlignmentCenter;
    sharxinlanglabel.font = TextFont;
    [shareview addSubview:sharxinlanglabel];
    
    UIButton * sharqq = [[UIButton alloc]initWithFrame:CGRectMake(imgW*3+50,40, 40, 40)];
    [sharqq addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharqq setImage:[UIImage imageNamed:@"shareqq@2x.png"] forState:UIControlStateNormal];
    sharqq.tag =4;
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
    
    sharetwoview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen/2-44, wScreen,260)];
    sharetwoview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sharetwoview];
    
    UILabel * sharlabel = [[UILabel alloc]initWithFrame:CGRectMake(wScreen/3,10, wScreen/3, 20)];
    sharlabel.text = @"分享至";
    sharlabel.textAlignment =NSTextAlignmentCenter;
    sharlabel.textColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.0];
    [sharetwoview addSubview:sharlabel];
    
    
    CGFloat imgW = (wScreen-30)/4;
    
    UIButton * sharweixin = [[UIButton alloc]initWithFrame:CGRectMake(20,40, 40, 40)];
    [sharweixin addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharweixin setImage:[UIImage imageNamed:@"shareweixin@2x.png"] forState:UIControlStateNormal];
    sharweixin.tag =1;
    [sharetwoview addSubview:sharweixin];
    
    UILabel * sharweixinlabel = [[UILabel alloc]initWithFrame:CGRectMake(20,80, 40, 40)];
    sharweixinlabel.text = @"微信";
    sharweixinlabel.textAlignment = NSTextAlignmentCenter;
    sharweixinlabel.font = TextFont;
    [sharetwoview addSubview:sharweixinlabel];
    
    
    
    UIButton * sharfriend = [[UIButton alloc]initWithFrame:CGRectMake(imgW+30,40, 40, 40)];
    [sharfriend addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharfriend setImage:[UIImage imageNamed:@"sharepengyou@2x.png"] forState:UIControlStateNormal];
    sharfriend.tag = 2;
    [sharetwoview addSubview:sharfriend];
    
    
    UILabel * sharfriendlabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW+30,80, 40, 40)];
    sharfriendlabel.text = @"朋友圈";
    sharfriendlabel.textAlignment = NSTextAlignmentCenter;
    sharfriendlabel.font = TextFont;
    [sharetwoview addSubview:sharfriendlabel];
    
    
    UIButton * sharxinlang = [[UIButton alloc]initWithFrame:CGRectMake(imgW*2+40,40, 40, 40)];
    [sharxinlang addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharxinlang setImage:[UIImage imageNamed:@"shareweibo@2x.png"] forState:UIControlStateNormal];
    sharxinlang.tag = 3;
    [sharetwoview addSubview:sharxinlang];
    
    UILabel * sharxinlanglabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW*2+30,80,60, 40)];
    sharxinlanglabel.text = @"新浪微博";
    sharxinlanglabel.textAlignment = NSTextAlignmentCenter;
    sharxinlanglabel.font = TextFont;
    [sharetwoview addSubview:sharxinlanglabel];
    
    UIButton * sharqq = [[UIButton alloc]initWithFrame:CGRectMake(imgW*3+50,40, 40, 40)];
    [sharqq addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharqq setImage:[UIImage imageNamed:@"shareqq@2x.png"] forState:UIControlStateNormal];
    sharqq.tag = 4;
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

-(void)sharebtn:(UIButton *)sender{
    
    
    
    //     SSDKPlatformTypeWechat       SSDKPlatformSubTypeWechatTimeline  SSDKPlatformTypeSinaWeibo    SSDKPlatformSubTypeQZone
    
//    :self.sharedingge.movieName
//images:@[self.shareimage]
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.sharemovie.title
                                     images:@[self.shareimage]
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeImage];
    
    switch (sender.tag) {
        case 1:
            //进行分享
            [ShareSDK share:SSDKPlatformTypeWechat parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     default:
                         break;
                 }
                 
             }];
            
            break;
        case 2:
            //进行分享
            [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     default:
                         break;
                 }
                 
             }];
            
            break;
        case 3:
            //进行分享
            [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     default:
                         break;
                 }
                 
             }];
            
            break;
        case 4:
            //进行分享
            [ShareSDK share:SSDKPlatformSubTypeQZone parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     default:
                         break;
                 }
                 
             }];
            
            break;
            
        default:
            break;
    }
    
    
    
}

-(void)zhedangBtn:(id)sender{
    
    _followview.hidden = YES;
    
    
    self.zhedangBtn.frame = CGRectMake(0, 0, 0, 0);
    
    
}
-(void)zheBtn:(id)sender{
    
    shareview.frame = CGRectMake(0,hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0,hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    self.zheBtn.frame = CGRectMake(0, 0, 0, 0);
    
    
}



-(void)cancelBtn:(id)sender{
    
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    self.zheBtn.frame = CGRectMake(0, 0, 0, 0);
    
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
                  
                   self.zheBtn.frame = CGRectMake(0, 0, 0, 0);


                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
    }else if ([sharestring isEqualToString:@"说戏"]){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        NSUserDefaults * CommentDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [CommentDefaults objectForKey:@"userID"];
        NSDictionary * param = @{@"user":userID,@"content":self.sharerev.content,@"targetType":@"1",@"target":self.sharerev.reviewId};
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
                  
                  self.zheBtn.frame = CGRectMake(0, 0, 0, 0);
                  
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

                   self.zheBtn.frame = CGRectMake(0, 0, 0, 0);
                  
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
                  
                  self.zheBtn.frame = CGRectMake(0, 0, 0, 0);

                  
                  
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
                    [self.followArr removeAllObjects];
                    [self.followDic removeAllObjects];
                    [self loadfollowData];
                    
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    shareview.hidden = YES;
                    sharetwoview.hidden = YES;
                    
                    self.zheBtn.frame = CGRectMake(0, 0, 0, 0);


                    
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"请求失败,%@",error);
                }];
        
    }else if ([sharestring isEqualToString:@"说戏"]){
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        NSString *url = [NSString stringWithFormat:@"%@/%@",SHUOXI_API,self.shareshuoxi.ID];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager DELETE:url parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [self.hud show:YES];
                    [self.hud hide:YES afterDelay:1];
                    
                    NSLog(@"删除成功");
                    [self.followArr removeAllObjects];
                    [self.followDic removeAllObjects];
                    [self loadfollowData];
                    
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    shareview.hidden = YES;
                    sharetwoview.hidden = YES;
                    
                    self.zheBtn.frame = CGRectMake(0, 0, 0, 0);
                    
                    
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
                    [self.followArr removeAllObjects];
                    [self.followDic removeAllObjects];
                    [self loadfollowData];
                    
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    shareview.hidden = YES;
                    sharetwoview.hidden = YES;
                    
                     self.zheBtn.frame = CGRectMake(0, 0, 0, 0);
                    
                    
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
                    [self.followArr removeAllObjects];
                    [self.followDic removeAllObjects];
                    [self loadfollowData];
                    
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
                    shareview.hidden = YES;
                    sharetwoview.hidden = YES;

                     self.zheBtn.frame = CGRectMake(0, 0, 0, 0);
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"请求失败,%@",error);
                }];
        
        
    }
    
    
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

{
    
    [self loadfollowData];
    
    return YES;
    
}






- (void)loadfollowData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    NSDictionary *parameters = @{@"skip":spage,@"limit":lpage};
    
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/timeline",BASE_API,userId];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"%@",responseObject);
             
             NSArray * arrmodel = [NSArray array];
             [self.followArr removeAllObjects];
             [self.followDic removeAllObjects];
             
             arrmodel = [ShuoXiModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             
             if (arrmodel.count==0) {
                 
                 
                 self.noDataImageView.hidden = NO;
                 self.noDataLabel.hidden = NO;
             }
             else{
                 
                 self.noDataImageView.hidden = YES;
                 self.noDataLabel.hidden = YES;
             
             }
             

             for (NSDictionary * dic in responseObject) {
                 
                 if ([dic[@"type"]isEqualToString:@"post"]) {
                     
                     DingGeModel * model = [DingGeModel mj_objectWithKeyValues:dic];
                     
                     [self.followArr addObject:model];
//                     NSLog(@"DingGeArr------%@",model.content);
                     
                     
//                     [statusFrames addObject:statusFrame];
//                     
//                     self.statusFramesDingGe = statusFrames;
                     [self.followDic addObject:@"post"];
                     
                     
                 }else if ([dic[@"type"]isEqualToString:@"story"]){
                     
                     ShuoXiModel * model = [ShuoXiModel mj_objectWithKeyValues:dic];
                     
                     [self.followArr addObject:model];
                     
                     [self.followDic addObject:@"story"];
                     
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
        
        [cell.zambiaBtn setTag:[indexPath row]];
        
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

       
    } if ([self.followDic[indexPath.row] isEqualToString:@"story"]){
        
        NSString *ID = [NSString stringWithFormat:@"myShuoxi"];
        MyshuoxiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[MyshuoxiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        
        
        [cell setup:self.followArr[indexPath.row]];
        
        
        ShuoXiModel *model = self.followArr[indexPath.row];
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shuoxiuserbtn:)];
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        
        
        if (model.viewCount == nil) {
            [cell.seeBtn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        }
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(shuoxizambiabtn:) forControlEvents:UIControlEventTouchUpInside];
        //        [cell.contentView addSubview:cell.zambiaBtn];
        
        
        
        [cell.screenBtn addTarget:self action:@selector(shuoxiscreenbtn:) forControlEvents:UIControlEventTouchUpInside];
        //        [cell.contentView addSubview:cell.screenBtn];
        
        
        [cell.answerBtn addTarget:self action:@selector(shuoxianswerbtn:) forControlEvents:UIControlEventTouchUpInside];
        //        [cell.contentView addSubview:cell.answerBtn];
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;


        
        
        return cell;
        
        

    
    
    }
    else if ([self.followDic[indexPath.row] isEqualToString:@"recommend"]){
        
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
        
        
        
        
        cell.movieName.text = [NSString stringWithFormat:@"《%@》",model.movie.title];
        cell.movieName.textColor = [UIColor  colorWithRed:234/255.0 green:153/255.0 blue:0/255.0 alpha:1.0];
        [cell.contentView addSubview:cell.movieName];
        
        cell.movieName.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(movierevbtn:)];
        
        [cell.movieName addGestureRecognizer:movieGesture];
        
        
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
    } else if ([self.followDic[indexPath.row] isEqualToString:@"story"]){
        
        ShuoXiModel *model = self.followArr[indexPath.row];
        
        if ([model.image isEqualToString:@"http://7xpumu.com2.z0.glb.qiniucdn.com/(null)"]) {
            return 220;
        }else{
            return 430;
        }
        

    
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
                  [self.followArr removeAllObjects];
                  [self.followDic removeAllObjects];
                  [self loadfollowData];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        
        
        rev.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:rev animated:YES];
        
    }
    else if ([self.followDic[indexPath.row] isEqualToString:@"post"])
        
    {
        
        DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
        
        dingge.hidesBottomBarWhenPushed = YES;
        
        DingGeModel *model = self.followArr[indexPath.row];
        
        dingge.dingimage = model.image;
        
        dingge.DingID  = model.ID;
        dingge.dinggetitle = model.movie.title;
        
        _followview.hidden = YES;
        
        sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
        sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;
        
        
        [self.navigationController pushViewController:dingge animated:YES];
        
        
    }else if ([self.followDic[indexPath.row] isEqualToString:@"story"])
        
    {
        ShuoxiViewController * shuoxi = [[ShuoxiViewController alloc]init];
        
        shuoxi.hidesBottomBarWhenPushed = YES;
        
        
        ShuoXiModel *model = self.followArr[indexPath.row];
        shuoxi.shuoimage = model.image;
        shuoxi.ShuoID = model.ID;
        
        
        NSInteger see = [model.viewCount integerValue];
        see = see+1;
        model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",SHUOXI_API,model.ID];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"成功,%@",responseObject);
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
       
        shuoxi.movie = model.movie;
        
        shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;
        
        [self.navigationController pushViewController:shuoxi animated:YES];
        
        _followview.hidden = YES;
        
        sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
        sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;
        
     
        
        
    }

}


-(void)thankBtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.followArr[indexPath.row];
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if (cell.appBtn.selected == NO) {
        
        cell.appBtn.selected = YES;
        
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
                  [self.followArr removeAllObjects];
                  [self.followDic removeAllObjects];
                  [self loadfollowData];

                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
    }else{
        
        self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:self.hud];
        // Set custom view mode
        self.hud.mode = MBProgressHUDModeCustomView;
          self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
        self.hud.labelText = @"已感谢";
        [self.hud show:YES];
        [self.hud hide:YES afterDelay:2];
        
        NSLog(@"您已经感谢过了");
        
        
    }
    
}





-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)btn.superview.superview;
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
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
                  [self.followArr removeAllObjects];
                  [self.followDic removeAllObjects];
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
                  [self.followArr removeAllObjects];
                  [self.followDic removeAllObjects];
                  [self loadfollowData];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
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
                  [self.followArr removeAllObjects];
                  [self.followDic removeAllObjects];
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
                  [self.followArr removeAllObjects];
                  [self.followDic removeAllObjects];
                  [self loadfollowData];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
 
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
    
    self.zheBtn.frame = CGRectMake(0, 0, wScreen,hScreen-64-260-44);
    
    self.sharemovie = model.movie;
    self.shareimage = cell.tagEditorImageView.imagePreviews.image;
    
    
    sharestring = @"定格";
    
    self.sharedingge = model;
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0,hScreen-64-260-44, wScreen,260);
                
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
                
                sharetwoview.frame = CGRectMake(0,hScreen-64-260-44, wScreen,260);
                
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
    dinggesecond.dinggetitle = model.movie.title;
    
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
              [self.followArr removeAllObjects];
              [self.followDic removeAllObjects];
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
     dinggesecond.dinggetitle = model.movie.title;
    
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
              [self.followArr removeAllObjects];
              [self.followDic removeAllObjects];
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
    dinggesecond.dinggetitle = model.movie.title;
    
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
              [self.followArr removeAllObjects];
              [self.followDic removeAllObjects];
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
    
    self.zheBtn.frame = CGRectMake(0, 0, wScreen,hScreen-64-260-44);
    

    self.sharemovie = model.movie;
    
    
    sharestring = @"好评";
    
    self.sharerev = model;
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0,hScreen-64-260-44, wScreen,260);
                
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
                
                sharetwoview.frame = CGRectMake(0,hScreen-64-260-44, wScreen,260);
                
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
              [self.followArr removeAllObjects];
              [self.followDic removeAllObjects];
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
              [self.followArr removeAllObjects];
              [self.followDic removeAllObjects];
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

-(void)movierevbtn:(UITapGestureRecognizer *)sender{
    
    
    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewModel *model = self.followArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    
    _followview.hidden = YES;
    
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
}

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
    movieviewcontroller.name = model.movie.title;
    
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
    
    self.zheBtn.frame = CGRectMake(0, 0, wScreen,hScreen-64-260-44);
    
    RecModel *model = self.followArr[indexPath.row];
    
    self.sharerec = model;
    
    self.sharemovie = model.movie;
    self.shareimage = cell.movieImg.image;
    
    RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
    
    rec.hidesBottomBarWhenPushed = YES;
    
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0,hScreen-64-260-44, wScreen,260);
                
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
                
                sharetwoview.frame = CGRectMake(0,hScreen-64-260-44, wScreen,260);
                
            }];
            
            sharetwoview.hidden = NO;
        }else{
            
            sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
            
            
            sharetwoview.hidden = YES;
        }
        
        
        
    }
    
    
    
    
}


-(void)shuoxizambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyshuoxiTableViewCell * cell = (MyshuoxiTableViewCell *)btn.superview.superview;
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ShuoXiModel *model = self.followArr[indexPath.row];
    
    
    if (cell.zambiaBtn.selected == NO) {
        cell.zambiaBtn.selected = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDef stringForKey:@"userID"];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/vote/story/%@",BASE_API,userId,model.ID];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"赞成功,%@",responseObject);
                 
                  [self.followArr removeAllObjects];
                  [self.followDic removeAllObjects];
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
        
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/unvote/story/%@",BASE_API,userId,model.ID];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"取消赞成功,%@",responseObject);
                  [self.followArr removeAllObjects];
                  [self.followDic removeAllObjects];
                  [self loadfollowData];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        
        
    }
    
    
    
    
}





-(void)shuoxiuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ShuoXiModel *model = self.followArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}




-(void)shuoxiscreenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyshuoxiTableViewCell * cell = (MyshuoxiTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ShuoxiViewController * shuoxi = [[ShuoxiViewController alloc]init];
    
    shuoxi.hidesBottomBarWhenPushed = YES;
    
    ShuoXiModel *model = self.followArr[indexPath.row];
    
    sharestring = @"说戏";
    
    self.shareshuoxi = model;
    
    self.sharemovie = model.movie;
    self.shareimage = cell.movieImg.image;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    self.zheBtn.frame = CGRectMake(0, 0, wScreen,hScreen-64-260-44);
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0,hScreen-64-260-44, wScreen,260);
                
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
                
                sharetwoview.frame = CGRectMake(0,hScreen-64-260-44, wScreen,260);
                
            }];
            
            sharetwoview.hidden = NO;
        }else{
            
            sharetwoview.frame = CGRectMake(0, hScreen-44, wScreen, hScreen/3+44);
            
            
            sharetwoview.hidden = YES;
        }
        
        
        
    }
    
    
}



-(void)shuoxianswerbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyshuoxiTableViewCell * cell = (MyshuoxiTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ShuoxiViewController * shuoxi = [[ShuoxiViewController alloc]init];
    
    shuoxi.hidesBottomBarWhenPushed = YES;
    
    ShuoXiModel *model = self.followArr[indexPath.row];
    
    shuoxi.shuoimage = model.image;
    shuoxi.ShuoID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",SHUOXI_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.followArr removeAllObjects];
              [self.followDic removeAllObjects];
              [self loadfollowData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:shuoxi animated:YES];
    
}







- (IBAction)follow:(id)sender {
    //   NSLog(@"open follow scene",nil);
}

- (IBAction)publish:(id)sender {
    
    
    
    if ( _followview.hidden ==YES) {
        
        _followview.hidden = NO;
         self.zhedangBtn.frame = CGRectMake(0,65,wScreen,hScreen);
    }
    
    else{
        
        _followview.hidden = YES;
         self.zhedangBtn.frame = CGRectMake(0,0,0,0);
         self.zheBtn.frame = CGRectMake(0,0,0,0);
    }
    
    
    
}

- (IBAction)addPerson:(UIButton *)sender {
    
    
    
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    AddPersonViewController *addPer = [[AddPersonViewController alloc]init];
    addPer.hidesBottomBarWhenPushed = YES;
    
    _followview.hidden = YES;
     self.zhedangBtn.frame = CGRectMake(0,0,0,0);
    self.zheBtn.frame = CGRectMake(0, 0, 0, 0);
    

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
     self.zhedangBtn.frame = CGRectMake(0,0,0,0);
    
    
    
    
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
     self.zhedangBtn.frame = CGRectMake(0,0,0,0);
    
    
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
                 self.zhedangBtn.frame = CGRectMake(0,0,0,0);
                
                 
             }else{
                 
                 
                 self.hud = [[MBProgressHUD alloc] initWithView:self.view];
                 [self.view addSubview:self.hud];
                  self.hud.square = YES;//设置显示框的高度和宽度一样
                 self.hud.labelText = @"您不是匠人";//显示提示
               
                 [self.hud show:YES];
                 [self.hud hide:YES afterDelay:1];
                 
                 
                 NSLog(@"您不是匠人");
                 
             }
             

    
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
    

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
            spage = @"0";
            lpage = @"5";
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
       
        NSInteger a = [spage intValue];
        a = a + 5;
        spage = [NSString stringWithFormat:@"%ld",(long)a];
        
        NSInteger b = [lpage intValue];
        b = b + 5;
        lpage = [NSString stringWithFormat:@"%ld",(long)b];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        NSString *userId = [userDef stringForKey:@"userID"];
        
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        NSDictionary *parameters = @{@"skip":spage,@"limit":lpage};
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/timeline",BASE_API,userId];
        [manager GET:url parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
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
                 
                 [self.hud setHidden:YES];
                 [self.tableView reloadData];
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self.hud setHidden:YES];
                 NSLog(@"请求失败,%@",error);
             }];
        
        [self.refreshFooter endRefreshing];
    });
}
@end
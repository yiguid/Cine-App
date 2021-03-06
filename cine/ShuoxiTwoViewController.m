//
//  ShuoxiTwoViewController.m
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "ShuoxiTwoViewController.h"
#import "ShuoXiModel.h"
#import "MyshuoxiTableViewCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MovieModel.h"
#import "RestAPI.h"
#import "TaViewController.h"
#import "ShuoxiViewController.h"
#import "RecommendPublishViewController.h"
#import "ActivityTableViewCell.h"
#import "ShuoXiImgTableViewCell.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MovieSecondViewController.h"
@interface ShuoxiTwoViewController (){
    
    NSMutableArray * ShuoXiArr;
//    ActivityModel * activity;
     UserModel * user;
    
    UIView * shareview;
    UIView * sharetwoview;
    UILabel * activier;
    
}
@property(nonatomic,strong)UITableView *shuoxi;
@property (nonatomic, strong) NSDictionary *dic;
@property MBProgressHUD *hud;
@property(nonatomic,strong)ShuoXiModel * shareshuoxi;
@property(nonatomic, strong)UIImage * sharimage;
@property(nonatomic, strong)MovieModel * sharmovie;
@end

@implementation ShuoxiTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add two table views
    //设置导航栏
    [self setNav];
    
    self.title = [NSString stringWithFormat:@"%@",self.movie.title];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen-64) style:UITableViewStylePlain];

    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    
    self.zhedangBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];
    self.zhedangBtn.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.4];
    [self.view addSubview:self.zhedangBtn];
    [self.zhedangBtn addTarget:self action:@selector(zhedangBtn:) forControlEvents:UIControlEventTouchUpInside];

    activier = [[UILabel alloc]initWithFrame:CGRectMake(10,0, wScreen,20)];
    activier.font = XiaoxiFont;
    activier.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
    [self loadShuoXiData];
    

    ShuoXiArr = [NSMutableArray array];
    

    [self setupshuoxiHeader];
    [self setupshuoxiFooter];
    [self shareData];
    [self sharetwoData];
    [self setHeaderView];
    
    
}


-(void)shareData{
    
    shareview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen, wScreen,260)];
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
    sharfriend.tag = 2;
    [shareview addSubview:sharfriend];
    
    
    UILabel * sharfriendlabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW+30,80, 40, 40)];
    sharfriendlabel.text = @"朋友圈";
    sharfriendlabel.textAlignment = NSTextAlignmentCenter;
    sharfriendlabel.font = TextFont;
    [shareview addSubview:sharfriendlabel];
    
    
    UIButton * sharxinlang = [[UIButton alloc]initWithFrame:CGRectMake(imgW*2+40,40, 40, 40)];
    [sharxinlang addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharxinlang setImage:[UIImage imageNamed:@"shareweibo@2x.png"] forState:UIControlStateNormal];
    sharxinlang.tag = 3;
    [shareview addSubview:sharxinlang];
    
    UILabel * sharxinlanglabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW*2+30,80,60, 40)];
    sharxinlanglabel.text = @"新浪微博";
    sharxinlanglabel.textAlignment = NSTextAlignmentCenter;
    sharxinlanglabel.font = TextFont;
    [shareview addSubview:sharxinlanglabel];
    
    UIButton * sharqq = [[UIButton alloc]initWithFrame:CGRectMake(imgW*3+50,40, 40, 40)];
    [sharqq addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharqq setImage:[UIImage imageNamed:@"shareqq@2x.png"] forState:UIControlStateNormal];
    sharqq.tag = 4;
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
    
    sharetwoview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen, wScreen,260)];
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
    sharweixin.tag = 1;
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
    
    
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.sharmovie.title
                                     images:@[self.sharimage]
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
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    self.zhedangBtn.frame = CGRectMake(0, 0, 0, 0);
    
    
}


-(void)cancelBtn:(id)sender{
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    self.zhedangBtn.frame = CGRectMake(0, 0, 0, 0);
    
}


-(void)jubaobtn:(id)sender{
    
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    // Set custom view mode
    self.hud.mode = MBProgressHUDModeCustomView;
    
    self.hud.labelText = @"已举报";//显示提示
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
  
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSUserDefaults * CommentDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [CommentDefaults objectForKey:@"userID"];
    NSDictionary * param = @{@"user":userID,@"content":self.shareshuoxi.content,@"targetType":@"1",@"target":self.shareshuoxi.ID};
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
              
               self.zhedangBtn.frame = CGRectMake(0, 0, 0, 0);
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
}

-(void)deletebtn:(id)sender{
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    // Set custom view mode
    self.hud.mode = MBProgressHUDModeCustomView;
    
    self.hud.labelText = @"已删除";//显示提示
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
   
    
    
    
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
                [self loadShuoXiData];
                
                shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                shareview.hidden = YES;
                sharetwoview.hidden = YES;
                
                 self.zhedangBtn.frame = CGRectMake(0, 0, 0, 0);
                
                
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"请求失败,%@",error);
            }];
    
    
}


//- (void)loadData{
//    //    NSLog(@"init array dingge",nil);
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    
//    NSString *token = [userDef stringForKey:@"token"];
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
//    
//    NSString *url = [NSString stringWithFormat:@"%@/%@",ACTIVITY_API,self.activityId];
//    [manager GET:url parameters:nil
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             
//             activity = [ActivityModel mj_objectWithKeyValues:responseObject];
//             NSLog(@"%@",activity);
//             
//             [self.tableView reloadData];
//             
//         }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             
//             
//             
//             NSLog(@"请求失败,%@",error);
//         }];
//    
//}


/**
 * 设置tabview顶部视图
 */
- (void)setHeaderView{
    
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, wScreen,200*hScreen/667);
    //    headView.backgroundColor = [UIColor colorWithRed:210/255.0 green:212/255.0 blue:225/255.0 alpha:1.0];
    self.tableView.tableHeaderView = headView;
    
    
    UIButton * movieBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 160*hScreen/667, wScreen, 40*hScreen/667)];
    [movieBtn addTarget:self action:@selector(movieBtn)forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:movieBtn];
    
    
    
    UIImageView * heardimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,wScreen, 200*hScreen/667)];
    
     [heardimageview sd_setImageWithURL:[NSURL URLWithString:self.activityimage] placeholderImage:nil];
    [headView addSubview:heardimageview];
    
    UIView * movienameview = [[UIView alloc]initWithFrame:CGRectMake(0,160*hScreen/667, wScreen,40*hScreen/667)];
   
    movienameview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [heardimageview addSubview:movienameview];
    
    UILabel * moviename = [[UILabel alloc]initWithFrame:CGRectMake(10, 5*hScreen/667, wScreen, 20*hScreen/667)];
    moviename.text = self.movie.title;
    moviename.font = TextFont;
    
    moviename.textColor = [UIColor whiteColor];

    
    [movienameview addSubview:moviename];
    
    
    
    UILabel * movietime = [[UILabel alloc]initWithFrame:CGRectMake(10,20*hScreen/667, wScreen, 15*hScreen/667)];
    movietime.text = [NSString stringWithFormat:@"上映日期:%@",self.movie.initialReleaseDate];
    
    [movienameview addSubview:movietime];
    movietime.textColor = [UIColor grayColor];
    movietime.font = TimeFont;

    
}

-(void)movieBtn{
    
    
    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title =@"";
    self.navigationItem.backBarButtonItem = backIetm;
    
    
    movieviewcontroller.ID = self.movie.ID;
    movieviewcontroller.name = self.movie.title;
    
    
    shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
}




- (void)loadShuoXiData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"%@/activity/%@/story",BASE_API,self.activityId];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             ShuoXiArr = [ShuoXiModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             [self.tableView reloadData];
             
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
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       
       NSForegroundColorAttributeName:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]}];
    
    
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
             
             if (![user.catalog isEqualToString:@"0"]) {
                 
                 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
                 
                 
             }

             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
    
   
}

- (void)publish{
    // 创建发布页面导航控制器
    //调用的定格，影评，推荐电影相同的view，需要加判断
    RecommendPublishViewController *publishview = [[RecommendPublishViewController alloc]init];

    publishview.movie = self.movie;
    publishview.publishType = @"shuoxi";
    publishview.activityId = self.activityId;
    [self.navigationController pushViewController:publishview animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
if (section==0){
        return 1;
    }
    else{
    
        
        return ShuoXiArr.count;
        
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section==0) {
//        
//        NSString *ID = [NSString stringWithFormat:@"Cell"];
//        ActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
//        
//        if (cell == nil) {
//            cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//        }
//        
//        [cell setup:activity];
//        
//        
//        
//        cell.userImg.userInteractionEnabled = YES;
//        
//        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actuserbtn:)];
//        
//        [cell.userImg addGestureRecognizer:tapGesture];
//        
//        
//        
//        
//        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:self.activityimage] placeholderImage:nil];
//        
//        
//        cell.selectionStyle =UITableViewCellSelectionStyleNone;
//        
//        
//        return  cell;
if (indexPath.section ==0){
    
        NSString *ID = [NSString stringWithFormat:@"Jiangren"];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[MyshuoxiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        
      
        activier.text = [NSString stringWithFormat:@"匠人说戏(%ld)",ShuoXiArr.count];
        [cell.contentView addSubview:activier];
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        
        return cell;
    
    }
    else if (indexPath.section ==1){
    
        
        NSString *ID = [NSString stringWithFormat:@"myShuoxi"];
        MyshuoxiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[MyshuoxiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        
        
        [cell setup:ShuoXiArr[indexPath.row]];
        
        
        ShuoXiModel *model = ShuoXiArr[indexPath.row];
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        
        
        if (model.viewCount == nil) {
            [cell.seeBtn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        }
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:cell.zambiaBtn];
        
        
        
        [cell.screenBtn addTarget:self action:@selector(screenbtn:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:cell.screenBtn];
        
        
        [cell.answerBtn addTarget:self action:@selector(answerbtn:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:cell.answerBtn];
        
        
          
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        
        return cell;
        
        
    }
    
    return nil;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (indexPath.section==0){
        return 20;
    }
    else{
    
        ShuoXiModel *model = ShuoXiArr[indexPath.row];
        
        if ([model.image isEqualToString:@"http://7xpumu.com2.z0.glb.qiniucdn.com/(null)"]) {
            return 220;
        }else{
             return 430;
        }
       
        
        
        
    }
    
}


-(void)zambiabtn:(id)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyshuoxiTableViewCell * cell = (MyshuoxiTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ShuoXiModel *model = ShuoXiArr[indexPath.row];
    
    
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
                  [self loadShuoXiData];
                  
                  
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
                  [self loadShuoXiData];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        
        
    }
    
    
    
    
}



//-(void)actuserbtn:(UITapGestureRecognizer *)sender{
//    
//    
//    
//    TaViewController * taviewcontroller = [[TaViewController alloc]init];
//    
//    
//    
//    taviewcontroller.hidesBottomBarWhenPushed = YES;
//    
//    taviewcontroller.model = activity.user;
//    
//    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
//    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
//    shareview.hidden = YES;
//    sharetwoview.hidden = YES;
//    
//    
//    [self.navigationController pushViewController:taviewcontroller animated:YES];
//    
//}




-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title =@"";
    self.navigationItem.backBarButtonItem = backIetm;
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ShuoXiModel *model = ShuoXiArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}




-(void)screenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyshuoxiTableViewCell * cell = (MyshuoxiTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ShuoxiViewController * shuoxi = [[ShuoxiViewController alloc]init];
    
    shuoxi.hidesBottomBarWhenPushed = YES;
    
    ShuoXiModel *model = ShuoXiArr[indexPath.row];
    
    self.shareshuoxi = model;
    
    self.sharmovie = model.movie;
    self.sharimage = cell.movieImg.image;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    self.zhedangBtn.frame = CGRectMake(0, 0, wScreen,hScreen-64-260);
    
    
    if ([model.user.userId isEqual:userId]) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            // 设置view弹出来的位置
            
            shareview.frame = CGRectMake(0,hScreen-64-260, wScreen,260);
            
        }];
        
        
        if (shareview.hidden==YES) {
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
                
                sharetwoview.frame = CGRectMake(0,hScreen-64-260, wScreen,260);
                
            }];
            sharetwoview.hidden = NO;
        }else{
            
            sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
            
            
            sharetwoview.hidden = YES;
        }
        
        
        
    }
    
    
}



-(void)answerbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyshuoxiTableViewCell * cell = (MyshuoxiTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ShuoxiViewController * shuoxi = [[ShuoxiViewController alloc]init];
    
    shuoxi.hidesBottomBarWhenPushed = YES;
    
    ShuoXiModel *model = ShuoXiArr[indexPath.row];
    
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
              [self loadShuoXiData];
              
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






-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section==1) {
        ShuoxiViewController * shuoxi = [[ShuoxiViewController alloc]init];
        
        shuoxi.hidesBottomBarWhenPushed = YES;
        
        
        ShuoXiModel *model = ShuoXiArr[indexPath.row];
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
                  [self loadShuoXiData];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
        backIetm.title =@"";
        self.navigationItem.backBarButtonItem = backIetm;
        shuoxi.movie = self.movie;
        
        shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        sharetwoview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;
        
        [self.navigationController pushViewController:shuoxi animated:YES];
    }
    
    
    
    
    
}

- (void)setupshuoxiHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadShuoXiData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    
}

- (void)setupshuoxiFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(shuoxifooterRefresh)];
    _shuoxirefreshFooter = refreshFooter;
}


- (void)shuoxifooterRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadShuoXiData];
        [self.shuoxirefreshFooter endRefreshing];
    });
}

@end

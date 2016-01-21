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
#import "ShuoxiTwoViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MovieModel.h"
#import "RestAPI.h"
#import "TaViewController.h"
#import "DinggeTitleViewController.h"
#import "CommentModel.h"
#import "MovieSecondViewController.h"
#import "RecModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
//微信SDK头文件
#import "WXApi.h"
@interface CineViewController (){
    
  
    NSMutableArray * DingGeArr;
    NSMutableArray * ActivityArr;
    HMSegmentedControl *segmentedControl;
    NSMutableArray * CommentArr;
    NSMutableArray * TuijianArr;
    NSString * str;
    
    UIView * shareview;
    UIView * sharetwoview;
}
@property(nonatomic,retain)IBOutlet UITableView *dingge;
@property(nonatomic,retain)IBOutlet UITableView *activity;
@property(nonatomic, strong)NSMutableArray * statusFramesDingGe;
@property(nonatomic, strong)NSMutableDictionary *cellHeightDic;
@property(nonatomic, strong)NSMutableArray * DingGerefresh;
@property (nonatomic, strong) NSDictionary *dic;
@property MBProgressHUD *hud;
@property (nonatomic, strong)DingGeModel * sharedingge;
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
    self.cellHeightDic = [[NSMutableDictionary alloc] init];
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
  
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
    TuijianArr = [NSMutableArray array];
    self.statusFramesDingGe = [NSMutableArray array];
    self.DingGerefresh = [NSMutableArray array];
   

    
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dinggebtn:)];
    tapGesture.numberOfTapsRequired = 2;
    [segmentedControl addGestureRecognizer:tapGesture];
    
    
    
    
    
    _dinggeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wScreen, 50)];
    _dinggeView.backgroundColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    [self.view addSubview:_dinggeView];
    UIButton * tuijianBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, wScreen/2, 30)];
    tuijianBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    [tuijianBtn setTitle:@"  推荐 " forState:UIControlStateNormal];
    [tuijianBtn setImage:[UIImage imageNamed:@"jiantou@2x.png"] forState:UIControlStateNormal];
    tuijianBtn.imageEdgeInsets = UIEdgeInsetsMake(0,wScreen/3, 0,0);
    
    [tuijianBtn addTarget:self action:@selector(tuijianBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [tuijianBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [_dinggeView addSubview:tuijianBtn];
    
    UIButton * titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(wScreen/2, 10, wScreen/2, 30)];
    titleBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    [titleBtn setTitle:@"热门标签 " forState:UIControlStateNormal];
    titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0,wScreen/3, 0,0);
    [titleBtn setImage:[UIImage imageNamed:@"jiantou@2x.png"] forState:UIControlStateNormal];
    
    [titleBtn addTarget:self action:@selector(titileBtn:) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [_dinggeView addSubview:titleBtn];
    
    _dinggeView.hidden = YES;
    

    
    [self setupdinggeHeader];
    [self setupdinggeFooter];
    [self setupshuoxiHeader];
    [self setupshuoxiFooter];
    [self dingge];
    [self activity];
    
    [self shareData];
    [self sharetwoData];
    
    [self loadDingGeData];
    [self loadShuoXiData];
    
    
    
}

-(void)shareData{
    
    shareview = [[UIView alloc]initWithFrame:CGRectMake(0,hScreen-44, wScreen, hScreen/3+44)];
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
    sharweixin.tag = 1;
    
    [sharweixin setImage:[UIImage imageNamed:@"shareweixin@2x.png"] forState:UIControlStateNormal];
    
    [shareview addSubview:sharweixin];
    
    UILabel * sharweixinlabel = [[UILabel alloc]initWithFrame:CGRectMake(20,80, 40, 40)];
    sharweixinlabel.text = @"微信";
    sharweixinlabel.textAlignment = NSTextAlignmentCenter;
    sharweixinlabel.font = TextFont;
    [shareview addSubview:sharweixinlabel];
    
    
    
    UIButton * sharfriend = [[UIButton alloc]initWithFrame:CGRectMake(imgW+30,40, 40, 40)];
    [sharfriend addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    sharfriend.tag = 2;
    
    [sharfriend setImage:[UIImage imageNamed:@"sharepengyou@2x.png"] forState:UIControlStateNormal];
    [shareview addSubview:sharfriend];
    
    
    UILabel * sharfriendlabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW+30,80, 40, 40)];
    sharfriendlabel.text = @"朋友圈";
    sharfriendlabel.textAlignment = NSTextAlignmentCenter;
    sharfriendlabel.font = TextFont;
    [shareview addSubview:sharfriendlabel];
    
    
    UIButton * sharxinlang = [[UIButton alloc]initWithFrame:CGRectMake(imgW*2+40,40, 40, 40)];
    [sharxinlang addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    
    sharxinlang.tag = 3;
    
    [sharxinlang setImage:[UIImage imageNamed:@"shareweibo@2x.png"] forState:UIControlStateNormal];
    [shareview addSubview:sharxinlang];
    
    UILabel * sharxinlanglabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW*2+30,80,60, 40)];
    sharxinlanglabel.text = @"新浪微博";
    sharxinlanglabel.textAlignment = NSTextAlignmentCenter;
    sharxinlanglabel.font = TextFont;
    [shareview addSubview:sharxinlanglabel];
    
    UIButton * sharqq = [[UIButton alloc]initWithFrame:CGRectMake(imgW*3+50,40, 40, 40)];
    [sharqq addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    sharqq.tag = 4;
    
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
    
    sharetwoview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen-44, wScreen, hScreen/3+44)];
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
    sharweixin.tag = 1;
    
    [sharweixin setImage:[UIImage imageNamed:@"shareweixin@2x.png"] forState:UIControlStateNormal];
    
    [sharetwoview addSubview:sharweixin];
    
    UILabel * sharweixinlabel = [[UILabel alloc]initWithFrame:CGRectMake(20,80, 40, 40)];
    sharweixinlabel.text = @"微信";
    sharweixinlabel.textAlignment = NSTextAlignmentCenter;
    sharweixinlabel.font = TextFont;
    [sharetwoview addSubview:sharweixinlabel];
    
    
    
    UIButton * sharfriend = [[UIButton alloc]initWithFrame:CGRectMake(imgW+30,40, 40, 40)];
    
    [sharfriend addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    sharfriend.tag = 2;
    
    [sharfriend setImage:[UIImage imageNamed:@"sharepengyou@2x.png"] forState:UIControlStateNormal];
    [sharetwoview addSubview:sharfriend];
    
    
    UILabel * sharfriendlabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW+30,80, 40, 40)];
    sharfriendlabel.text = @"朋友圈";
    sharfriendlabel.textAlignment = NSTextAlignmentCenter;
    sharfriendlabel.font = TextFont;
    [sharetwoview addSubview:sharfriendlabel];
    
    
    UIButton * sharxinlang = [[UIButton alloc]initWithFrame:CGRectMake(imgW*2+40,40, 40, 40)];
    [sharxinlang addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    sharxinlang.tag = 3;
    
    [sharxinlang setImage:[UIImage imageNamed:@"shareweibo@2x.png"] forState:UIControlStateNormal];
    [sharetwoview addSubview:sharxinlang];
    
    UILabel * sharxinlanglabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW*2+30,80,60, 40)];
    sharxinlanglabel.text = @"新浪微博";
    sharxinlanglabel.textAlignment = NSTextAlignmentCenter;
    sharxinlanglabel.font = TextFont;
    [sharetwoview addSubview:sharxinlanglabel];
    
    UIButton * sharqq = [[UIButton alloc]initWithFrame:CGRectMake(imgW*3+50,40, 40, 40)];
    [sharqq addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    sharqq.tag = 4;
    
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


-(void)sharebtn:(UIButton *)sender{
    
    
//    switch (sender.tag) {
//            //微信
//        case 1:{
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"分享内容 @value(url)"
                                             images:@[[UIImage imageNamed:@"shareImg"]]
                                                url:[NSURL URLWithString:@"http://mob.com"]
                                              title:@"分享标题"
                                               type:SSDKContentTypeImage];
            
            //进行分享
            [ShareSDK share:SSDKPlatformTypeSinaWeibo
                 parameters:shareParams
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
    __weak CineViewController *weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/%@",DINGGE_API,self.sharedingge.ID];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager DELETE:url parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self.hud show:YES];
                [self.hud hide:YES afterDelay:1];
                
                NSLog(@"删除成功,%@",responseObject);
                [self loadDingGeData];
                
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf.hud setHidden:YES];
                NSLog(@"请求失败,%@",error);
            }];
    
    
    
    
    
    
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
    NSDictionary * param = @{@"user":userID,@"content":self.sharedingge.content,@"targetType":@"0",@"target":self.sharedingge.ID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:Jubao_API parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [self.hud show:YES];
              [self.hud hide:YES afterDelay:1];
              
              NSLog(@"举报成功,%@",responseObject);
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    
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

    
-(void)tuijianBtn:(id)sender{
    
    
    
    
   
    
}


-(void)cancelBtn:(id)sender{

    shareview.frame = CGRectMake(0,hScreen-44, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0,hScreen-44, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
}



-(void)titileBtn:(id)sender{
    
    
    
    DinggeTitleViewController * title = [[DinggeTitleViewController alloc]init];
    
    DingGeModel *model = DingGeArr[0];
    
    title.hidesBottomBarWhenPushed = YES;
    
    
    title.firstdingge = model.movie.cover;
    
    _dinggeView.hidden=YES;
    
    
    [self.navigationController pushViewController:title animated:YES];
    
    
}



- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":str};
    __weak CineViewController *weakSelf = self;
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
                                 
                 //创建模型
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.seeCount = model.viewCount;
                 
                 NSInteger comments = model.comments.count;
                 NSString * com = [NSString stringWithFormat:@"%ld",comments];
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
             
             
             weakSelf.statusFramesDingGe = statusFrames;
//             [self reloadData];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.dingge reloadData];
             });
             
             
             [weakSelf.hud setHidden:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [weakSelf.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
  }



- (void)loadShuoXiData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    __weak CineViewController *weakSelf = self;
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:ACTIVITY_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             ActivityArr = [ActivityModel mj_objectArrayWithKeyValuesArray:responseObject];
//             [weakSelf.activity reloadData];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.activity reloadData];
             });
             [weakSelf.hud setHidden:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [weakSelf.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
}


-(void)loadtuijianData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             TuijianArr = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.dingge reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        
        shareview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
        sharetwoview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;

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
    
    
    __weak CineViewController *weakSelf = self;
    if ([tableView isEqual:self.dingge]) {
        NSString *ID = @"Dinge";
        //创建cell
        MyDingGeTableViewCell * cell = [self.dingge dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
          cell = [[MyDingGeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
              
        DingGeModel *model = DingGeArr[indexPath.row];
        
        NSString * string = model.image;
        
        //设置图片为圆角的
        CALayer * imagelayer = [cell.movieImg layer];
        [imagelayer setMasksToBounds:YES];
        [imagelayer setCornerRadius:6.0];
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
                    [weakSelf.dingge reloadData];
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
                [weakSelf.dingge reloadData];
//                [weakSelf.dingge reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        
//        [imageView setImage:cell.movieImg.image];
        
//        [cell.contentView addSubview:imageView];
         cell.message.text = model.content;
        [cell.contentView addSubview:cell.message];
        
        
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
      
    
        if (model.viewCount == nil) {
            [cell.seeBtn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        }
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",model.viewCount] forState:UIControlStateNormal];
        [cell.seeBtn addTarget:self action:@selector(seebtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.seeBtn];
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];
        
        
        
       
        cell.tagEditorImageView.viewC = self;
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
//        cell.separatorColor = [UIColor redColor];//设置行间隔边框
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;


        
        return cell;
    }
   else {
       NSString *ID = [NSString stringWithFormat:@"ShuoXi"];
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
       
       if (cell == nil) {
           cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
       }
       
       cell.userImg.userInteractionEnabled = YES;
       
       UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shuoxiuserbtn:)];
       
       [cell.userImg addGestureRecognizer:tapGesture];
       
              
       [cell setup:ActivityArr[indexPath.row]];
       
       
       cell.selectionStyle =UITableViewCellSelectionStyleNone;
       
        return cell;
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    if ([tableView isEqual:self.dingge]) {
        CGFloat height = [[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
        if(height > 0){
            return height;
        }else
            return 400;
    }
    else{
       
        return 340;

    }
        
}

-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.dingge indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
  
    
    NSInteger zan = [model.voteCount integerValue];
    
//    if () {
//        zan = zan + 1;
//    }
//    else{
//        zan = zan - 1;
//    
//    }
    
    model.voteCount = [NSString stringWithFormat:@"%ld",(long)zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/votecount",DINGGE_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"点赞成功,%@",responseObject);
              [self loadDingGeData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
}

-(void)screenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.dingge indexPathForCell:cell];
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];

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
    NSIndexPath * indexPath = [self.dingge indexPathForCell:cell];
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
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
              
//              NSLog(@"成功,%@",responseObject);
              [self.dingge reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];

    
    
    _dinggeView.hidden=YES;
    
    shareview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    sharetwoview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;

    
    [self.navigationController pushViewController:dingge animated:YES];
    
    
}


-(void)answerbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.dingge indexPathForCell:cell];
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
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
              
//              NSLog(@"成功,%@",responseObject);
              [self.dingge reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];

    
    
    _dinggeView.hidden=YES;
    
    shareview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    sharetwoview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;

    
    [self.navigationController pushViewController:dingge animated:YES];
    
}



-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.dingge indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    taviewcontroller.model = model.user;


    _dinggeView.hidden = YES;
    
    shareview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    sharetwoview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;

    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.dingge indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    movieviewcontroller.name = model.movieName;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
      _dinggeView.hidden = YES;
    shareview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    sharetwoview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;

    
}



- (void)detailBtn:(UITapGestureRecognizer *)sender{
    
    
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview.superview;
    NSIndexPath *indexPath = [self.dingge indexPathForCell:cell];
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
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
              
//              NSLog(@"成功,%@",responseObject);
              [self loadDingGeData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    
    _dinggeView.hidden=YES;
    shareview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    sharetwoview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;

    
    
    [self.navigationController pushViewController:dingge animated:YES];
}



-(void)shuoxiuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.activity indexPathForCell:cell];
    
    ActivityModel *model = ActivityArr[indexPath.row];
    
   taviewcontroller.model = model.user;
    
    
    _dinggeView.hidden = YES;
    shareview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    sharetwoview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;

    
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.dingge]) {
        DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
        
        dingge.hidesBottomBarWhenPushed = YES;
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        dingge.dingimage = model.image;
        dingge.DingID  = model.ID;
    
        
        
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
                  
//                  NSLog(@"成功,%@",responseObject);
                  [self loadDingGeData];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];

 
     
        
        _dinggeView.hidden=YES;
        
        shareview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
        sharetwoview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;


        
        [self.navigationController pushViewController:dingge animated:YES];
    }
    else{
    
        ShuoxiTwoViewController * shuoxi = [[ShuoxiTwoViewController alloc]init];
        
        shuoxi.hidesBottomBarWhenPushed = YES;
     

        
        _dinggeView.hidden=YES;
        
        shareview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
        sharetwoview.frame = CGRectMake(0,hScreen-50, wScreen, hScreen/3+50);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;

        
        
        ActivityModel *model = ActivityArr[indexPath.row];
        shuoxi.movie = model.movie;
        shuoxi.activityId = model.activityId;
        shuoxi.activityimage = model.image;
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
            
           
            [self loadDingGeData];
            
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
         
            [self loadShuoXiData];
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
        a = a + a;
        str = [NSString stringWithFormat:@"%ld",(long)a];
      
        
    
            
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
                         
                         //创建模型
                         model.seeCount = model.viewCount;
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
        
        [self loadShuoXiData];
        
        [self.shuoxirefreshFooter endRefreshing];
    });
}





@end

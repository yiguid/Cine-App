//
//  MyRecMovieViewController.m
//  cine
//
//  Created by wang on 16/1/19.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "MyRecMovieViewController.h"
#import "RecModel.h"
#import "RecMovieTableViewCell.h"
#import "RestAPI.h"
#import "RecommendSecondViewController.h"
#import "TaViewController.h"
#import "MovieSecondViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface MyRecMovieViewController (){
    
    UIView * shareview;
}
@property NSMutableArray *dataSource;
@property MBProgressHUD *hud;
@property (nonatomic,strong)RecModel * sharerec;
@property(nonatomic, strong)UIImage * sharimage;
@property(nonatomic, strong)MovieModel * sharmovie;

@end

@implementation MyRecMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的推荐";
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.navigationController.view addSubview:self.hud];
    
    
    
    // Set custom view mode
    self.hud.mode = MBProgressHUDModeCustomView;
    
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen-64) style:UITableViewStylePlain];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
     self.tableView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    
    self.noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(wScreen/2-50,wScreen/4,100, 100)];
    self.noDataImageView.image=[UIImage imageNamed:@"图层-13@2x.png"];
    [self.tableView addSubview:self.noDataImageView];
    
    self.noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,110+wScreen/4,wScreen-40, 30)];
    self.noDataLabel.text = @"暂时还没有推荐消息哦";
    self.noDataLabel.font = NameFont;
    self.noDataLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    self.noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:self.noDataLabel];
    

    
    
    self.zhedangBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];
    self.zhedangBtn.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.4];
    [self.view addSubview:self.zhedangBtn];
    [self.zhedangBtn addTarget:self action:@selector(zhedangBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.dataSource = [[NSMutableArray alloc]init];
    [self loadData];
    [self setupHeader];
    [self setupFooter];

    
    [self shareData];
    
    
    
    
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
    [sharweixin addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    [sharweixin setImage:[UIImage imageNamed:@"shareweixin@2x.png"] forState:UIControlStateNormal];
    sharweixin.tag =1;
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
    shareview.hidden = YES;
    
    
    self.zhedangBtn.frame = CGRectMake(0, 0, 0, 0);
    
    
}


-(void)cancelBtn:(id)sender{
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    
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
    NSDictionary * param = @{@"user":userID,@"content":self.sharerec.content,@"targetType":@"4",@"target":self.sharerec.recId};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:Jubao_API parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [self.hud show:YES];
              [self.hud hide:YES afterDelay:1];
              
              NSLog(@"举报成功,%@",responseObject);
              
              shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
              shareview.hidden = YES;
              
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
    NSString *url = [NSString stringWithFormat:@"%@/%@",REC_API,self.sharerec.recId];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager DELETE:url parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self.hud show:YES];
                [self.hud hide:YES afterDelay:1];
                
                NSLog(@"删除成功");
                [self loadData];
                
                shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
                shareview.hidden = YES;
                
                self.zhedangBtn.frame = CGRectMake(0, 0, 0, 0);

                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"请求失败,%@",error);
            }];
    
    
}



-(void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user"] = userId;
    param[@"sort"] = @"createdAt DESC";
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.dataSource = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             
             if (self.dataSource.count==0) {
                 self.noDataImageView.hidden = NO;
                 self.noDataLabel.hidden = NO;;
             }
             else{
                 self.noDataImageView.hidden = YES;
                 self.noDataLabel.hidden = YES;
             }
             

             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
}





- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSString *ID = [NSString stringWithFormat:@"Rec"];
    RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[RecMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    [cell setup:self.dataSource[indexPath.row]];
    
    RecModel *model = self.dataSource[indexPath.row];
    
    
    cell.userImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
    
    [cell.userImg addGestureRecognizer:tapGesture];
    
    cell.commentview.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moviebtn:)];
    
    [cell.commentview addGestureRecognizer:movieGesture];
    
    
    [cell.screenBtn addTarget:self action:@selector(screenbtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.screenBtn];
    
    if (model.thankCount == nil) {
        [cell.appBtn setTitle:[NSString stringWithFormat:@"0人 感谢"] forState:UIControlStateNormal];
    }
    [cell.appBtn setTitle:[NSString stringWithFormat:@"%@人 感谢",model.thankCount] forState:UIControlStateNormal];
    [cell.appBtn addTarget:self action:@selector(thankBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.appBtn];
    
    
    
    cell.layer.borderWidth = 10;
    cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
    //        cell.separatorColor = [UIColor redColor];//设置行间隔边框
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return wScreen+80;
}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//        RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
//
//
//        RecModel *model = self.dataSource[indexPath.row];
//
//        rec.recimage = model.image;
//        rec.recID  = model.recId;
//
//
//
//        [self.navigationController pushViewController:rec animated:YES];
//
//
//}




-(void)thankBtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.dataSource[indexPath.row];
    
    
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
                          [self loadData];
                          
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




-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.dataSource[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIView * label = (UIView *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.dataSource[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    movieviewcontroller.name = model.movie.title;
    
    shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
    
}





-(void)screenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
    
    RecModel *model = self.dataSource[indexPath.row];
    
    self.sharerec = model;
    
    self.sharmovie = model.movie;
    self.sharimage = cell.movieImg.image;
    
    
    RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
    
    rec.hidesBottomBarWhenPushed = YES;
    
     self.zhedangBtn.frame = CGRectMake(0, 0, wScreen,hScreen-64-260);
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([model.user.userId isEqual:userId]) {
        
        
        if (shareview.hidden==YES) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                // 设置view弹出来的位置
                
                shareview.frame = CGRectMake(0,hScreen-64-260, wScreen,260);
                
            }];
            
            
            shareview.hidden = NO;
        }else{
            
            shareview.frame = CGRectMake(0, hScreen, wScreen, hScreen/3+44);
            
            shareview.hidden = YES;
        }
        
        
        
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
            
            [self loadData];
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
        
        [self loadData];
        [self.refreshFooter endRefreshing];
    });
}

@end

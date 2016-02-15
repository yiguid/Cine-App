//
//  DinggeSecondViewController.m
//  cine
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "DinggeSecondViewController.h"
#import "DingGeSecondTableViewCell.h"
#import "DingGeModel.h"
#import "DingGeModelFrame.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "RestAPI.h"
#import "UserModel.h"
#import "TagModel.h"
#import "TagCoordinateModel.h"
#import "TaViewController.h"
#import "MovieSecondViewController.h"
@interface DinggeSecondViewController (){


    DingGeModel * dingge;
    NSMutableArray * CommentArr;
//    NSMutableArray * DingGeArr;
    
    UIView * shareview;
    UIView * sharetwoview;
    
    NSArray * user;


}
@property MBProgressHUD *hud;
@property NSMutableArray *dataSource;
//@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic, strong)NSMutableArray * textArray;
@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, strong)NSArray *statusFramesComment;
//@property(nonatomic, strong)DingGeModelFrame *statusFramesDingGe;
@end

@implementation DinggeSecondViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"定格详情界面";
    [MovieModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    [UserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userId" : @"id"};
    }];
    

    
    
    self.dataSource = [[NSMutableArray alloc]init];
    CommentArr = [NSMutableArray array];
    
    _dataArray=[[NSMutableArray alloc]init];
    _textView=[[UIView alloc]initWithFrame:CGRectMake(0,hScreen - 108, wScreen, 44)];
    _textView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:_textView];
    
    _textButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _textButton.frame=CGRectMake(wScreen - 55, 8, 45, 30);
    _textButton.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    [_textButton setTitle:@"发布" forState:UIControlStateNormal];
    [_textButton setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:
     UIControlStateNormal];
    
    _textButton.layer.masksToBounds = YES;
    _textButton.layer.cornerRadius = 4.0;
    
    [_textButton addTarget:self action:@selector(sendmessage) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:_textButton];
    
    _textFiled=[[UITextView alloc]initWithFrame:CGRectMake(10, 4.5, wScreen - 75, 35)];
    _textFiled.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textFiled.delegate = self;
    _textFiled.returnKeyType=UIReturnKeyDone;
   // _textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [_textView addSubview:_textFiled];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen - 108) style:UITableViewStylePlain];
    _tableView.backgroundColor = [ UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    //给最外层的view添加一个手势响应UITapGestureRecognizer
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGr];
    
    //键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHid:) name: UIKeyboardWillHideNotification object:nil];
    
    
    [self setupHeader];
    [self setupFooter];
    [self shareData];
    [self sharetwoData];
    
    [self loadDingGeData];
    [self loadCommentData];
    
    [self loadUsers];
 
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
    
    sharetwoview = [[UIView alloc]initWithFrame:CGRectMake(0, hScreen, wScreen, hScreen/3+50)];
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
    
    
        
    shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
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
    

    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSUserDefaults * CommentDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [CommentDefaults objectForKey:@"userID"];
    NSDictionary * param = @{@"user":userID,@"content":dingge.content,@"targetType":@"0",@"target":dingge.ID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:Jubao_API parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [self.hud show:YES];
              [self.hud hide:YES afterDelay:1];
              
              NSLog(@"举报成功,%@",responseObject);
              
              shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
              sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
              shareview.hidden = YES;
              sharetwoview.hidden = YES;
              
              
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
    NSString *url = [NSString stringWithFormat:@"%@/%@",DINGGE_API,dingge.ID];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager DELETE:url parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self.hud show:YES];
                [self.hud hide:YES afterDelay:1];
                
                NSLog(@"删除成功,%@",responseObject);
                
                shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
                sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
                shareview.hidden = YES;
                sharetwoview.hidden = YES;
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"请求失败,%@",error);
            }];
    
    
}



-(void)loadUsers{


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/users",BASE_API];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
             
             user = [UserModel mj_objectArrayWithKeyValuesArray:responseObject];
             
     
               NSLog(@"获取个人信息成功,%@",user);
             
             
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];





}





- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/%@",DINGGE_API, self.DingID];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
             dingge = [DingGeModel mj_objectWithKeyValues:responseObject];
             
             DingGeModel * model = [[DingGeModel alloc]init];
             self.tagsArray = [[NSMutableArray alloc] init];
             self.coordinateArray = [[NSMutableArray alloc] init];
             self.tagsArray = dingge.tags;
             self.coordinateArray = dingge.coordinates;
             model.movieName =[NSString stringWithFormat:@"《%@》",model.movie.title];
             
            [_tableView reloadData];
//             UIImageView *image = [[UIImageView alloc] init];
//             [image sd_setImageWithURL:[NSURL URLWithString:dingge.image] placeholderImage:nil];
             
                     
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             
             NSLog(@"请求失败,%@",error);
         }];
}

- (void)loadCommentData{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSDictionary *parameters = @{@"post":self.DingID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:COMMENT_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
//             NSLog(@"评论内容-----%@",responseObject);
             CommentArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject];
            //将里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
//             NSLog(@"1234-------------%@",responseObject);
             
             for (CommentModel * model in CommentArr) {
               //  CommentModel * status = [[CommentModel alloc]init];
                 model.comment= model.content;
                 model.nickName = model.user.nickname;
                 model.time = model.createdAt;
                
//                 model.zambiaCounts = model.voteCount;
                 
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=200)
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您已输入200个字" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    else
    {
        return YES;
    }
}


-(void)sendmessage{
    
    
    if (_textFiled.text.length==0) {
        
        return;
        
    }
  
    NSString * textstring = _textFiled.text;
        
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSUserDefaults * CommentDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [CommentDefaults objectForKey:@"userID"];
    NSDictionary * param = @{@"user":userID,@"content":textstring,@"post":self.DingID,@"commentType":@"1",@"movie":dingge.movie.ID,@"receiver":dingge.user.userId};
    
    NSString *url = COMMENT_API;
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"评论成功,%@",responseObject);
              [self loadCommentData];
              [self.view endEditing:YES];
              self.textFiled.text = @"";
              
              [UIView animateWithDuration:0.25 animations:^{
                  [UIView setAnimationCurve:7];
                  _textView.frame = CGRectMake(0, hScreen - 108, wScreen, 44);
                  _textFiled.frame = CGRectMake(10, 4.5, wScreen - 75, 35);
                  _tableView.frame=CGRectMake(0, 0, wScreen, hScreen - 108);
                  _image.frame = CGRectMake(0, 0, wScreen, 44);
              }];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];

}



-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:7];
        _textView.frame = CGRectMake(0, hScreen-108, wScreen, 44);
        _textFiled.frame = CGRectMake(10, 4.5, wScreen - 75, 35);
        _tableView.frame=CGRectMake(0, 0, wScreen, hScreen-108);
        _image.frame = CGRectMake(0, 0, wScreen, 44);
    }];
    
   // [_textFiled resignFirstResponder];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - keyboard events -

///键盘显示事件
- (void) keyboardShow:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.25 animations:^{
        _textView.frame = CGRectMake(0, hScreen-168-216-44, wScreen,104);
        _tableView.frame=CGRectMake(0, 0, wScreen, hScreen-168-216-44);
    }];


}
///键盘关闭事件
- (void) keyboardHid:(NSNotification *)notification {
    
  [UIView animateWithDuration:2.5 animations:^{
        _textView.frame = CGRectMake(0, hScreen-168, wScreen,104);
        _tableView.frame=CGRectMake(0, 0, wScreen, hScreen-168);
  
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    
            [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationCurve:7];
            _textView.frame = CGRectMake(0, hScreen-168, wScreen,104);
            _textFiled.frame = CGRectMake(10, 4.5, wScreen - 75, 95);
            _tableView.frame=CGRectMake(0, 0, wScreen, hScreen-168);
            _image.frame = CGRectMake(0, 0, wScreen, 104);
        }];
     
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
          
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationCurve:7];
            _textView.frame = CGRectMake(0, hScreen-108, wScreen, 44);
            _textFiled.frame = CGRectMake(10, 4.5, wScreen - 75, 35);
            _tableView.frame=CGRectMake(0, 0, wScreen, hScreen-108);
            _image.frame = CGRectMake(0, 0, wScreen, 44);
        }];
    
    
    return YES;
}


-(void)setLastCellSeperatorToLeft:(UITableViewCell *)cell
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        
        return 1;

    }
    else if(section==1){
        
        return 1;
    
    }
    else
    {
    return CommentArr.count;
    }
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section==0) {
        
        static NSString *ID = @"Cell";
        
        DingGeSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        
        if (!cell) {
            cell = [[DingGeSecondTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
                
        [cell setup:dingge];
        
       
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        [cell.screenBtn addTarget:self action:@selector(screenBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.zambiaBtn addTarget:self action:@selector(zambiaBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",dingge.voteCount] forState:UIControlStateNormal];
        
        
        [cell.contentView addSubview:cell.zambiaBtn];
        
        cell.commentview.userInteractionEnabled = YES;
        
               
        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moviebtn:)];
        
        [cell.commentview addGestureRecognizer:movieGesture];

       
        __weak DinggeSecondViewController *weakSelf = self;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if([self.dingimage containsString:@"(null)"])
            self.dingimage = @"http://img3.douban.com/view/photo/photo/public/p2285067062.jpg";
        NSURL *url = [NSURL URLWithString:self.dingimage];
        if(![manager diskImageExistsForURL:url]){
            [cell.movieImg sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"Detail Dingge Image Size: %f",image.size.height,nil);
                UIImage *img = cell.movieImg.image;
                if (img.size.height > 0) {
                    CGFloat ratio = wScreen / img.size.width;
                    cell.tagEditorImageView.imagePreviews.image = img;
                    cell.tagEditorImageView.frame = CGRectMake(0, 0, wScreen, img.size.height * ratio); //190
                    cell.tagEditorImageView.imagePreviews.frame = CGRectMake(0, 0, wScreen, img.size.height * ratio);
                    cell.imageHeight = img.size.height * ratio;
                    cell.ratio = ratio;
                    [cell setTags];
                    self.cellHeight = [cell getHeight];
                    //                self.statusFramesDingGe.imageHeight = image.size.height;
//                                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
        }else{
            UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            cell.tagEditorImageView.imagePreviews.image = image;
            CGFloat ratio = wScreen / image.size.width;
            cell.tagEditorImageView.frame = CGRectMake(0, 0, wScreen, image.size.height * ratio); //190
            cell.tagEditorImageView.imagePreviews.frame = CGRectMake(0, 0, wScreen, image.size.height * ratio);
            cell.imageHeight = image.size.height * ratio;
            cell.ratio = ratio;
            [cell setTags];
            if(self.cellHeight != [cell getHeight]){
                self.cellHeight = [cell getHeight];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",dingge.viewCount] forState:UIControlStateNormal];
       
        [cell.contentView addSubview:cell.seeBtn];
        
        NSInteger comments = dingge.comments.count;
        NSString * com = [NSString stringWithFormat:@"%ld",(long)comments];
        dingge.answerCount = com;
        
        [cell.answerBtn setTitle:[NSString stringWithFormat:@"%@",dingge.answerCount] forState:UIControlStateNormal];
        
        [cell.contentView addSubview:cell.answerBtn];
        
        
        [cell.timeBtn setTitle:[NSString stringWithFormat:@"%@",dingge.createdAt] forState:UIControlStateNormal];
        
        [cell.contentView addSubview:cell.timeBtn];
        
        
        
        cell.tagEditorImageView.viewC = self;
        
        
         cell .contentView .backgroundColor = [ UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        

        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    else if (indexPath.section==1){
        
        static NSString * CellIndentifier = @"pinglun";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 100, 15)];
        label.text = @"评论列表";
        label.font = TextFont;
        label.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1.0];
        [cell.contentView addSubview:label];
        
        
        
        cell.contentView.backgroundColor = [ UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    else{
    
        //创建cell
        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
        //设置高度
        cell.modelFrame = self.statusFramesComment[indexPath.row];
        
       CommentModel * model = CommentArr[indexPath.row];
        
        
        cell.comment.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapComment = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commenttwo:)];
        [cell.comment addGestureRecognizer:tapComment];
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentuserbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        [cell.zambia setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambia addTarget:self action:@selector(comzambia:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambia];
        
        
        cell .contentView .backgroundColor = [ UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
     
        
        return cell;
        
    }
    return nil;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (self.cellHeight > 0) {
            return self.cellHeight;
        }
        else
            return 290;
    }
    else if (indexPath.section==1){
    
    
        return 35;
        
    }
    else{
        CommentModelFrame *modelFrame = self.statusFramesComment[indexPath.row];
        return modelFrame.cellHeight;
    }

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==2) {
        TaViewController * taviewcontroller = [[TaViewController alloc]init];
        
        
        
        taviewcontroller.hidesBottomBarWhenPushed = YES;
        
        taviewcontroller.model = dingge.user;
        
        shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
        sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
        shareview.hidden = YES;
        sharetwoview.hidden = YES;
        
        [self.navigationController pushViewController:taviewcontroller animated:YES];
        

    }
    
    

}



-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
   taviewcontroller.model = dingge.user;
    
    shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}


-(void)zambiaBtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    DingGeSecondTableViewCell * cell = (DingGeSecondTableViewCell *)[[btn superview] superview];
    


    
    if (cell.zambiaBtn.selected == NO) {
        cell.zambiaBtn.selected = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDef stringForKey:@"userID"];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/vote/post/%@",BASE_API,userId,dingge.ID];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"赞成功,%@",responseObject);
                  [self loadDingGeData];
                  
                  
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
        
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/unvote/post/%@",BASE_API,userId,dingge.ID];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"取消赞成功,%@",responseObject);
                  [self loadDingGeData];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        
        
    }

    
    
}



-(void)screenBtn:(id)sender{

    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    if ([dingge.user.userId isEqual:userId]) {
        
        
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



-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieSecondViewController * movieviewcontroller = [[MovieSecondViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    

   
    
    movieviewcontroller.ID = dingge.movie.ID;
    movieviewcontroller.name = dingge.movie.title;
    
    
    shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
}

-(void)commentuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TaViewController * taviewcontroller = [[TaViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    CommentModel *model = CommentArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    shareview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
    sharetwoview.frame = CGRectMake(0, hScreen/2, wScreen, hScreen/3+44);
    shareview.hidden = YES;
    sharetwoview.hidden = YES;
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}




-(void)commenttwo:(UITapGestureRecognizer *)sender{
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
     CommentModel *model = CommentArr[indexPath.row];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    
    
    if ([model.user.userId isEqual:userId]){
        
        
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert show];
    
    
    
    }
  

    
}




-(void)comzambia:(UIButton *)sender{
    
        
    UIButton * btn = (UIButton *)sender;
    
    
    CommentTableViewCell * cell = (CommentTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    CommentModel *model = CommentArr[indexPath.row];
    
    
    
       
    if (cell.zambia.selected == NO) {
        cell.zambia.selected = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDef stringForKey:@"userID"];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/vote/comment/%@",BASE_API,userId,model.commentId];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"赞成功,%@",responseObject);
                
                  [self loadCommentData];
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        
        
        
        
    }else{
        
        cell.zambia.selected = NO;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDef stringForKey:@"userID"];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/unvote/comment/%@",BASE_API,userId,model.commentId];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"取消赞成功,%@",responseObject);
            
                  [self loadCommentData];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        
        
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
            
            
            [self loadDingGeData];
            [self loadCommentData];
          
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
        
        [self loadDingGeData];
        [self loadCommentData];
        [self.refreshFooter endRefreshing];
    });
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if(buttonIndex == 1){
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        NSDictionary *parameters = @{@"post":self.DingID};
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager DELETE:COMMENT_API parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {

                    
                    NSLog(@"删除成功,%@",responseObject);
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"请求失败,%@",error);
                }];

        
        
        
        [self.tableView reloadData];
        
    }
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

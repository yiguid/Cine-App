//
//  ReviewSecondViewController.m
//  cine
//
//  Created by wang on 15/12/15.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ReviewSecondViewController.h"
#import "ReviewModel.h"
#import "ReviewTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "RestAPI.h"

@interface ReviewSecondViewController (){
    
    ReviewModel * rev;
    
}


@property NSMutableArray *dataSource;
@property(nonatomic, strong)NSArray *statusFramesComment;
@property(nonatomic,strong)NSArray * RevArr;
@property(nonatomic,strong)NSArray * CommentArr;



@end

@implementation ReviewSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"影评详情界面";
    [MovieModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    [UserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userId" : @"id"};
    }];
    
    
    
    
    self.dataSource = [[NSMutableArray alloc]init];
    
    
    _dataArray=[[NSMutableArray alloc]init];
    _textView=[[UIView alloc]initWithFrame:CGRectMake(0, 560, wScreen, 44)];
    _textView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:_textView];
    
    _textButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _textButton.frame=CGRectMake(wScreen - 55, 8, 45, 30);
    _textButton.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    [_textButton setTitle:@"发布" forState:UIControlStateNormal];
    [_textButton setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:
     UIControlStateNormal];
    [_textButton addTarget:self action:@selector(sendmessage) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:_textButton];
    
    _textFiled=[[UITextField alloc]initWithFrame:CGRectMake(10, 4.5, wScreen - 75, 35)];
    _textFiled.borderStyle=UITextBorderStyleRoundedRect;
    //_textFiled.clearButtonMode = UITextFieldViewModeAlways;
    _textFiled.clearsOnBeginEditing = YES;
    _textFiled.adjustsFontSizeToFitWidth = YES;
    _textFiled.delegate = self;
    _textFiled.returnKeyType=UIReturnKeyDone;
    _textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _textFiled.delegate=self;
    [_textView addSubview:_textFiled];
    
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, wScreen, 560) style:UITableViewStylePlain];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    //    [_tableView addGestureRecognizer:tap];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    
    
    
    //给最外层的view添加一个手势响应UITapGestureRecognizer
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGr];
    
    //键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHid:) name: UIKeyboardWillHideNotification object:nil];
    
    
    
    //初始化 SD上下拉
    [self Refresh];
    [self loadRevData];
    [self loadCommentData];
    
    
    
}



-(void)loadRevData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REVIEW_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RevArr = [ReviewModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
         }];
    
}

- (void)loadCommentData{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *url = @"http://fl.limijiaoyin.com:1337/comment";
    NSDictionary *parameters = @{@"post":self.revID};
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




-(void)sendmessage{
    
    
    if (_textFiled.text.length==0) {
        
        return;
        
    }
    
    NSString * textstring = _textFiled.text;
    
    
    
    
    
    NSUserDefaults * CommentDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [CommentDefaults objectForKey:@"userID"];
    NSDictionary * param = @{@"user":userID,@"content":textstring,@"post":self.revID,@"commentType":@"3",@"movie":rev.movie.ID,@"receiver":rev.user.userId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = @"http://fl.limijiaoyin.com:1337/comment";
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"评论成功,%@",responseObject);
              [self loadCommentData];
              [self.view endEditing:YES];
              self.textFiled.text = @"";
              
              [UIView animateWithDuration:0.25 animations:^{
                  [UIView setAnimationCurve:7];
                  _textView.frame = CGRectMake(0, 560, wScreen, 44);
                  _textFiled.frame = CGRectMake(10, 4.5, wScreen - 75, 35);
                  _tableView.frame=CGRectMake(0, 0, wScreen, 560);
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
        _textView.frame = CGRectMake(0, 560, wScreen, 44);
        _textFiled.frame = CGRectMake(10, 4.5, wScreen - 75, 35);
        _tableView.frame=CGRectMake(0, 0, wScreen, 560);
        _image.frame = CGRectMake(0, 0, wScreen, 44);
    }];
    
    // [_textFiled resignFirstResponder];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///键盘显示事件
- (void) keyboardShow:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.25 animations:^{
        _textView.frame = CGRectMake(0, 500-216-44, wScreen,104);
        _tableView.frame=CGRectMake(0, 0, wScreen, 500-216-44);
    }];
    
    
}
///键盘关闭事件
- (void) keyboardHid:(NSNotification *)notification {
    
    [UIView animateWithDuration:2.5 animations:^{
        _textView.frame = CGRectMake(0, 500, wScreen,104);
        _tableView.frame=CGRectMake(0, 0, wScreen, 500);
        
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:7];
        _textView.frame = CGRectMake(0, 500, wScreen,104);
        _textFiled.frame = CGRectMake(10, 4.5, wScreen - 75, 95);
        _tableView.frame=CGRectMake(0, 0, wScreen, 500);
        _image.frame = CGRectMake(0, 0, wScreen, 104);
    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:7];
        _textView.frame = CGRectMake(0, 560, wScreen, 44);
        _textFiled.frame = CGRectMake(10, 4.5, wScreen - 75, 35);
        _tableView.frame=CGRectMake(0, 0, wScreen, 560);
        _image.frame = CGRectMake(0, 0, wScreen, 44);
    }];
    
    
    return YES;
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
        ;
    }else{
        return self.statusFramesComment.count;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0)  {
        
        NSString *ID = [NSString stringWithFormat:@"rev"];
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ReviewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RevArr[indexPath.row]];
        
        
        
        NSString * string = self.revimage;
        
        
        
        
        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        
        
        
        
        return cell;
    }
    
    else{
        
        //创建cell
        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
        //设置高度
        cell.modelFrame = self.statusFramesComment[indexPath.row];
        
        return cell;
        
    }
    
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        
        return 270;
    }
    else{
        CommentModelFrame *modelFrame = self.statusFramesComment[indexPath.row];
        return modelFrame.cellHeight;
    }
    
    
}











-(void)Refresh
{
    self.refreshHeader.isEffectedByNavigationController = NO;
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_tableView];
    [refreshHeader addTarget:self refreshAction:@selector(endRefresh)];
    self.refreshHeader=refreshHeader;
    [refreshHeader autoRefreshWhenViewDidAppear];
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_tableView];
    [refreshFooter addTarget:self refreshAction:@selector(endRefresh)];
    self.refreshFooter=refreshFooter;
    
    
    
}
-(void)endRefresh
{
    [self.refreshFooter endRefreshing];
    [self.refreshHeader endRefreshing];
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

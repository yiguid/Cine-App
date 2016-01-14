//
//  ShuoxiViewController.m
//  cine
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ShuoxiViewController.h"
#import "ShuoXiImgTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "RestAPI.h"
#import "MovieModel.h"
#import "UserModel.h"
#import "ShuoXiModel.h"
#import "cine.pch"
#import "TadeTableViewController.h"
@interface ShuoxiViewController (){
    
    ShuoXiModel * shuoxi;
    NSMutableArray * CommentArr;
    
    
}
@property NSMutableArray *dataSource;

@property(nonatomic, strong)NSArray * DingArr;
@property(nonatomic,strong)NSArray * statusFramesComment;
@property(nonatomic,strong)NSArray * statusFramesShuoxi;

@property(nonatomic,copy)NSString * messageText;


@end

@implementation ShuoxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = [NSString stringWithFormat:@"说戏#%@#详情",self.movie.title];

    
    [MovieModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    [UserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userId" : @"id"};
    }];

    
    [self loadShuoXiData];
    [self loadCommentData];
    
    
    self.dataSource = [[NSMutableArray alloc]init];
    CommentArr = [NSMutableArray array];
    
    _textView=[[UIView alloc]initWithFrame:CGRectMake(0, hScreen - 108, wScreen, 44)];
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
    _textFiled.delegate=self;
    [_textView addSubview:_textFiled];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen - 108) style:UITableViewStylePlain];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    //    [_tableView addGestureRecognizer:tap];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    
    
    [self setupHeader];
    [self setupFooter];
    

    
    
    
    
    
    
    //给最外层的view添加一个手势响应UITapGestureRecognizer
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGr];
    
    //键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHid:) name: UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:7];
        _textView.frame = CGRectMake(0, hScreen - 108, wScreen, 44);
        _textFiled.frame = CGRectMake(10, 4.5, wScreen-75, 35);
        _tableView.frame=CGRectMake(0, 0, wScreen, hScreen - 108);
        _imageview.frame = CGRectMake(0, 0, wScreen, 44);
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







#pragma mark - keyboard events -

///键盘显示事件
- (void) keyboardShow:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.5 animations:^{
    
    _textView.frame = CGRectMake(0, hScreen - 168-216-44, wScreen,104);
    _tableView.frame=CGRectMake(0, 0, wScreen, hScreen - 168-216-44);
    
    }];
    
    
}
///键盘关闭事件
- (void) keyboardHid:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.5 animations:^{
        
    _textView.frame = CGRectMake(0, hScreen - 168, wScreen,104);
    _tableView.frame=CGRectMake(0, 0, wScreen, hScreen - 168);
    
    }];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:7];
        _textView.frame = CGRectMake(0, hScreen - 168, wScreen,104);
        _textFiled.frame = CGRectMake(10, 4.5, wScreen-75, 95);
        _tableView.frame=CGRectMake(0, 0, wScreen, hScreen - 168);
        _imageview.frame = CGRectMake(0, 0, wScreen, 104);
    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:7];
        _textView.frame = CGRectMake(0, hScreen - 108, wScreen, 44);
        _textFiled.frame = CGRectMake(10, 4.5, wScreen-75, 35);
        _tableView.frame=CGRectMake(0, 0, wScreen, hScreen - 108);
        _imageview.frame = CGRectMake(0, 0, wScreen, 44);
    }];
    
    
    return YES;
}

- (void)loadShuoXiData{
//    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",SHUOXI_API, self.ShuoID];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             shuoxi = [ShuoXiModel mj_objectWithKeyValues:responseObject];
             
             
             [_tableView reloadData];
             
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
    NSDictionary *parameters = @{@"story":self.ShuoID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
//             NSLog(@"评论内容-----%@",responseObject);
             CommentArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject];
             //将里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (CommentModel * model in CommentArr) {
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
    NSDictionary * param = @{@"user":userID,@"content":textstring,@"story":self.ShuoID,@"commentType":@"0",@"movie":shuoxi.movie.ID,@"receiver":shuoxi.user.userId};
    
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
                  _textView.frame = CGRectMake(0, hScreen - 108, wScreen, 44);
                  _textFiled.frame = CGRectMake(10, 4.5, wScreen - 75, 35);
                  _tableView.frame=CGRectMake(0, 0, wScreen, hScreen - 108);
                  _imageview.frame = CGRectMake(0, 0, wScreen, 44);
              }];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
}



- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = NO;
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    
    if (section==0) {
        return 1;

    }else if (section==1){
    
        return 1;
    
    }else{
        return self.statusFramesComment.count;
    }

      
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        NSString *ID = [NSString stringWithFormat:@"Cell"];
        ShuoXiImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ShuoXiImgTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:shuoxi];
        
        NSString * string = self.shuoimage;
        
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        

        
        
               
        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",shuoxi.voteCount] forState:UIControlStateNormal];
       
        [cell.contentView addSubview:cell.zambiaBtn];
        
        
        
      
        
        return  cell;
        
        
    }else if (indexPath.section==1){
    
        static NSString * CellIndentifier = @"pinglun";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 100, 15)];
        label.text = @"评论列表";
        label.font = TextFont;
        label.textColor = [UIColor colorWithRed:88/255.0 green:87/255.0 blue:85/255.0 alpha:49/255.0];
        [cell.contentView addSubview:label];

        
        
         cell .contentView .backgroundColor = [ UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        
        return cell;
    
    }
    else{
        
        
        //创建cell
        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
        //设置高度
        cell.modelFrame = self.statusFramesComment[indexPath.row];
        
        CommentModel * model = CommentArr[indexPath.row];

        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentuserbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        [cell.zambia setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambia addTarget:self action:@selector(comzambia:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambia];
        
        
       
        //返回cell
        return  cell;
        
    }
    return nil;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 430;
    }else if (indexPath.section==1){
    
        return 35;
    }
    else{
        CommentModelFrame *modelFrame = self.statusFramesComment[indexPath.row];
        return modelFrame.cellHeight;
    }
    
    
}

-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    taviewcontroller.userimage = shuoxi.user.avatarURL ;
    taviewcontroller.nickname = shuoxi.user.nickname;
    taviewcontroller.vip = shuoxi.user.catalog;
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}





-(void)commentuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    CommentModel *model = CommentArr[indexPath.row];
    
    taviewcontroller.userimage = model.user.avatarURL ;
    taviewcontroller.nickname = model.user.nickname;
    taviewcontroller.vip = model.user.catalog;
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}




-(void)comzambia:(id)sender{
    
    
    CommentTableViewCell * cell = (CommentTableViewCell *)[[sender superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    CommentModel *model = CommentArr[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%d",zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/votecount",@"http://fl.limijiaoyin.com:1337/comment/",model.commentId];
    
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




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

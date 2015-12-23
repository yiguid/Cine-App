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

@interface DinggeSecondViewController (){


    DingGeModel * dingge;
    NSMutableArray * CommentArr;
    NSMutableArray * DingGeArr;


}

@property NSMutableArray *dataSource;
//@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic, strong)NSMutableArray * textArray;
@property(nonatomic, strong)NSArray *statusFramesComment;
@property(nonatomic, strong)NSArray *statusFramesDingGe;
@end

@implementation DinggeSecondViewController

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
    
    [self loadDingGeData];
    [self loadCommentData];
    
    
    self.dataSource = [[NSMutableArray alloc]init];
    CommentArr = [NSMutableArray array];
    
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
    
    
    [self setupHeader];
    [self setupFooter];
   
 
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
             
             
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             DingGeModel * model = [[DingGeModel alloc]init];
             model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
             model.nikeName = @"11";
             model.content = @"22";
             model.time = @"9分钟";
             self.tagsArray = [[NSMutableArray alloc] init];
             self.coordinateArray = [[NSMutableArray alloc] init];
             self.tagsArray = dingge.tags;
             self.coordinateArray = dingge.coordinates;
            
             
             DingGeModelFrame * dingFrame = [[DingGeModelFrame alloc]init];
             
             dingFrame.model = model;
             [dingFrame setModel:model];
             [statusFrames addObject:dingFrame];
             
             
             
             self.statusFramesDingGe = statusFrames;
             
          
            [_tableView reloadData];
//             UIImageView *image = [[UIImageView alloc] init];
//             [image sd_setImageWithURL:[NSURL URLWithString:dingge.image] placeholderImage:nil];
//             self.tagEditorImageView = [[YXLTagEditorImageView alloc]initWithImage:image.image imageEvent:ImageHaveNoEvent];
//             self.tagEditorImageView.viewC=self;
//             self.tagEditorImageView.userInteractionEnabled=YES;
//             [self.tableView addSubview:self.tagEditorImageView];
//             self.tagEditorImageView.frame = CGRectMake(0, 0, wScreen, 170);
             
             for (NSInteger i = 0; i < [self.tagsArray count];i++) {
                 NSDictionary *tag = [self.tagsArray objectAtIndex:i];
                 NSDictionary *coordinate = [self.coordinateArray objectAtIndex:i];
                 float pointX = [coordinate[@"x"] floatValue];
                 float pointY = [coordinate[@"y"] floatValue];
                 NSString *textString = tag[@"name"];
                 NSString *directionString = coordinate[@"direction"];
                 if([directionString isEqualToString:@"left"])
                 {
                     [self.tagEditorImageView addTagViewText:textString Location:CGPointMake(pointX,pointY) isPositiveAndNegative:YES];
                 }
                 else
                 {
                     [self.tagEditorImageView addTagViewText:textString Location:CGPointMake(pointX,pointY) isPositiveAndNegative:NO];
                 }
                 
             }
            
                     
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
    NSDictionary *parameters = @{@"post":self.DingID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"评论内容-----%@",responseObject);
             CommentArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject];
            //将里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             NSLog(@"1234-------------%@",responseObject);
             
             for (CommentModel * model in CommentArr) {
               //  CommentModel * status = [[CommentModel alloc]init];
                 model.comment= model.content;
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.nickName = model.user.nickname;
                 model.time = model.createdAt;
                 model.zambiaCounts = model.voteCount;
                 
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
    NSDictionary * param = @{@"user":userID,@"content":textstring,@"post":self.DingID,@"commentType":@"1",@"movie":dingge.movie.ID,@"receiver":dingge.user.userId};
    
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

    
    
    NSInteger answer = [dingge.votecount integerValue];
    answer = answer + 1;
    dingge.votecount = [NSString stringWithFormat:@"%ld",answer];
    
    
    
    NSString *aurl = [NSString stringWithFormat:@"%@%@/votecount",@"http://fl.limijiaoyin.com:1337/post/",dingge.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:aurl parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
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


#pragma mark - keyboard events -

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
        return self.statusFramesDingGe.count;

    }else{
    return self.statusFramesComment.count;
    }
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section==0) {
        
        static NSString *ID = @"Cell";
        
        DingGeSecondTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        
        if (!cell) {
            cell = [[DingGeSecondTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
                
        [cell setup:dingge];
        
        NSString * string = self.dingimage;
        
        
       
        
        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        //[cell.contentView addSubview:self.tagEditorImageView];
       
        
        return cell;
        
    }else{
    
        //创建cell
        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
        //设置高度
        cell.modelFrame = self.statusFramesComment[indexPath.row];
        
        return cell;
        
    }
    return nil;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        
        DingGeModelFrame *modelFrame = self.statusFramesDingGe[indexPath.row];
        return modelFrame.cellHeight;
        
        
    }
    else{
            CommentModelFrame *modelFrame = self.statusFramesComment[indexPath.row];
            return modelFrame.cellHeight;
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
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            
            NSString *token = [userDef stringForKey:@"token"];
            NSString *url = @"http://fl.limijiaoyin.com:1337/comment";
            NSDictionary *parameters = @{@"post":self.DingID};
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
            [manager GET:url parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                     NSLog(@"评论内容-----%@",responseObject);
                     CommentArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject];
                     //将里面的所有字典转成模型,放到新的数组里
                     NSMutableArray *statusFrames = [NSMutableArray array];
                     
                     for (CommentModel * model in CommentArr) {
                         //  CommentModel * status = [[CommentModel alloc]init];
                         model.comment= model.content;
                         model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                         model.nickName = model.user.nickname;
                         model.time = model.createdAt;
                         model.zambiaCounts = model.voteCount;
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

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
#import "TadeTableViewController.h"
#import "MovieTableViewController.h"
@interface DinggeSecondViewController (){


    DingGeModel * dingge;
    NSMutableArray * CommentArr;
//    NSMutableArray * DingGeArr;


}

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
    
    [self loadDingGeData];
    [self loadCommentData];
    
    
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
     NSString *url = @"http://fl.limijiaoyin.com:1337/comment";
    NSDictionary *parameters = @{@"post":self.DingID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
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
        
        
        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moviebtn:)];
        
        [cell.movieName addGestureRecognizer:movieGesture];

       
        __weak DinggeSecondViewController *weakSelf = self;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *url = [NSURL URLWithString:self.dingimage];
        if( ![manager diskImageExistsForURL:url]){
            [cell.movieImg sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"Detail Dingge Image Size: %f",image.size.height,nil);
                if (image.size.height > 0) {
                    CGFloat ratio = wScreen / image.size.width;
                    cell.tagEditorImageView.imagePreviews.image = image;
                    cell.tagEditorImageView.frame = CGRectMake(0, 0, wScreen, image.size.height * ratio); //190
                    cell.tagEditorImageView.imagePreviews.frame = CGRectMake(0, 0, wScreen, image.size.height * ratio);
                    cell.imageHeight = image.size.height * ratio;
                    self.cellHeight = cell.cellHeight;
                    //                self.statusFramesDingGe.imageHeight = image.size.height;
                    //                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
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
            if(self.cellHeight != cell.cellHeight){
                self.cellHeight = cell.cellHeight;
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",dingge.voteCount] forState:UIControlStateNormal];
        
        
        [cell.contentView addSubview:cell.zambiaBtn];
        
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
        
//        if (indexPath.row==DingGeArr.count-1) {
//            
//            
//            
//            [self setLastCellSeperatorToLeft:cell];
//           
//        }
        
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
        label.textColor = [UIColor colorWithRed:13/255.0 green:13/255.0 blue:13/255.0 alpha:1.0];
        [cell.contentView addSubview:label];
        
        
        
        cell.contentView.backgroundColor = [ UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        
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
        
        
        cell .contentView .backgroundColor = [ UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
        
        
     
        
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


-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    taviewcontroller.userimage = dingge.user.avatarURL ;
    taviewcontroller.nickname = dingge.user.nickname;
    taviewcontroller.vip = dingge.user.catalog;
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    

   
    
    movieviewcontroller.ID = dingge.movie.ID;
    
    

    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
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
    model.voteCount = [NSString stringWithFormat:@"%ld",(long)zan];
    
    
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
            
            
            [self loadDingGeData];
            
            
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

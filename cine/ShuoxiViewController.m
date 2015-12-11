//
//  ShuoxiViewController.m
//  cine
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ShuoxiViewController.h"
#import "ShuoXiImgTableViewCell.h"
#import "ShuoXiImgModel.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "UIImageView+WebCache.h"
@interface ShuoxiViewController (){
    
    ShuoXiImgModel * ShuoXi;
    
    
    
}
@property NSMutableArray *dataSource;
@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic, strong)NSArray * DingArr;

@property(nonatomic,copy)NSString * messageText;


@end

@implementation ShuoxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   self.title = @"说戏#霍比特人#详情";
    
    self.dataSource = [[NSMutableArray alloc]init];
    self.textArray = [[NSMutableArray alloc]init];
    
    _textView=[[UIView alloc]initWithFrame:CGRectMake(0, 560, 375, 44)];
    [self.view addSubview:_textView];
    
    _imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 44)];
    _imageview.image=[UIImage imageNamed:@"down.jpg"];
    [_textView addSubview:_imageview];
    _textButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _textButton.frame=CGRectMake(320, 10, 40, 30);
    [_textButton setTitle:@"发布" forState:UIControlStateNormal];
    [_textButton addTarget:self action:@selector(sendmessage) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:_textButton];
    
    _textFiled=[[UITextField alloc]initWithFrame:CGRectMake(10, 4.5, 300, 35)];
    _textFiled.borderStyle=UITextBorderStyleRoundedRect;
    //_textFiled.clearButtonMode = UITextFieldViewModeAlways;
    _textFiled.clearsOnBeginEditing = YES;
    _textFiled.adjustsFontSizeToFitWidth = YES;
    _textFiled.delegate = self;
    _textFiled.returnKeyType=UIReturnKeyDone;
    _textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _textFiled.delegate=self;
    [_textView addSubview:_textFiled];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 560) style:UITableViewStylePlain];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    //    [_tableView addGestureRecognizer:tap];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    
    
    [self Refresh];
    
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = @"http://fl.limijiaoyin.com:1337/post";
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSLog(@"111111---------%@",responseObject);
        
        
        //        [_tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
    
    
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
        _textView.frame = CGRectMake(0, 560, 375, 44);
        _textFiled.frame = CGRectMake(10, 4.5, 300, 35);
        _tableView.frame=CGRectMake(0, 0, 375, 560);
        _imageview.frame = CGRectMake(0, 0, 375, 44);
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
    
    _textView.frame = CGRectMake(0, 500-216-44, 375,104);
    _tableView.frame=CGRectMake(0, 0, 375, 500-216-44);
    
    }];
    
    
}
///键盘关闭事件
- (void) keyboardHid:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.5 animations:^{
        
    _textView.frame = CGRectMake(0, 500, 375,104);
    _tableView.frame=CGRectMake(0, 0, 375, 500);
    
    }];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:7];
        _textView.frame = CGRectMake(0, 500, 375,104);
        _textFiled.frame = CGRectMake(10, 4.5, 300, 95);
        _tableView.frame=CGRectMake(0, 0, 375, 500);
        _imageview.frame = CGRectMake(0, 0, 375, 104);
    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:7];
        _textView.frame = CGRectMake(0, 560, 375, 44);
        _textFiled.frame = CGRectMake(10, 4.5, 300, 35);
        _tableView.frame=CGRectMake(0, 0, 375, 560);
        _imageview.frame = CGRectMake(0, 0, 375, 44);
    }];
    
    
    return YES;
}

//消息的发送

-(void)sendmessage{

    
    NSString * textstring = _textFiled.text;
    
    [self.textArray addObject:textstring];
    
    
    if (_textFiled.text.length==0) {
        
        textstring = @"12345";
        
    }
    
    
    [_tableView reloadData];
    
}

//
//-(NSMutableArray *)textArray{
//    if (_textArray == nil) {
//        //将dictArray里面的所有字典转成模型,放到新的数组里
//        NSMutableArray *statusFrames = [NSMutableArray array];
//       
//            
//            //创建MLStatus模型
//            CommentModel *model = [[CommentModel alloc]init];
//            model.comment= _textFiled.text;
//            model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
//            model.nickName = [NSString stringWithFormat:@"霍比特人"];
//            model.time = [NSString stringWithFormat:@"1小时前"];
//            model.zambiaCounts = @"600";
//            
//            //创建MLStatusFrame模型
//            CommentModelFrame *modelFrame = [[CommentModelFrame alloc]init];
//            modelFrame.model = model;
//            [modelFrame setModel:model];
//            [statusFrames addObject:modelFrame];
//            
//       
//        _statusFrames = statusFrames;
//    }
//    return _textArray;
//
//}

-(NSArray *)statusFrames{
    if (_statusFrames == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (int i = 0; i < 5; i++ ) {
            
            //创建MLStatus模型
            CommentModel *model = [[CommentModel alloc]init];
            model.comment= self.textFiled.text;
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
        _statusFrames = statusFrames;
    }
    return _statusFrames;
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    
  
        return self.statusFrames.count;
      
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSString *ID = [NSString stringWithFormat:@"ShuoxiImg"];
        
        ShuoXiImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[ShuoXiImgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        ShuoXiImgModel *modelImg = [[ShuoXiImgModel alloc]init];
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        NSString * string = self.movieID;
        
        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        
        [imageView setImage:cell.movieImg.image];
        
        [cell.contentView addSubview:imageView];
        
        
        
        modelImg.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];

        cell.foortitle.text = [NSString stringWithFormat:@"评论列表"];
        
      
        //[self.dataSource addObject:modelImg];
        
        //[cell setup:self.dataSource[indexPath.row]];
        
        // Configure the cell...
        
        return cell;
    }
    else {
        //创建cell
        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
        //设置高度
        cell.modelFrame = self.statusFrames[indexPath.row];
        
        return  cell;
        
        
    }
    
    return nil;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 190;
    }
    else {
        CommentModelFrame *modelFrame = self.statusFrames[indexPath.row];
        return modelFrame.cellHeight;
    }
}


-(void)Refresh
{
    self.refreshHeader.isEffectedByNavigationController = NO;
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.tableView];
    [refreshHeader addTarget:self refreshAction:@selector(headRefresh)];
    self.refreshHeader=refreshHeader;
    [refreshHeader autoRefreshWhenViewDidAppear];
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footRefresh)];
    self.refreshFooter=refreshFooter;
    
    
}
-(void)headRefresh
{
    [self.refreshHeader endRefreshing];
}
-(void)footRefresh
{
    [self.refreshFooter endRefreshing];
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

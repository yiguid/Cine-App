//
//  DinggeSecondViewController.m
//  cine
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "DinggeSecondViewController.h"
#import "DingGeSecondTableViewCell.h"
#import "DingGeSecondModel.h"
#import "DingGeModel.h"
#import "DingGeModelFrame.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "RestAPI.h"
@interface DinggeSecondViewController ()

@property NSMutableArray *dataSource;
@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic, strong)NSMutableArray * DingArr;

@end

@implementation DinggeSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"定格详情界面";
    
    [self loadDingGeData];
    
    
    self.dataSource = [[NSMutableArray alloc]init];
    _DingArr = [NSMutableArray array];
    
    _dataArray=[[NSMutableArray alloc]init];
    _textView=[[UIView alloc]initWithFrame:CGRectMake(0, 560, 375, 44)];
    [self.view addSubview:_textView];
    
    _image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 44)];
    _image.image=[UIImage imageNamed:@"down.jpg"];
    [_textView addSubview:_image];
    _textButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _textButton.frame=CGRectMake(320, 10, 40, 30);
    [_textButton setTitle:@"发布" forState:UIControlStateNormal];
   
    
    //[button addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
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

    
    
    
    //给最外层的view添加一个手势响应UITapGestureRecognizer
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGr];
    
    //键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHid:) name: UIKeyboardWillHideNotification object:nil];
    
    
   
 
}


- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:DINGGE_API parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // NSArray * arraymodel  = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             //将里面的所有字典转成模型,放到新的数组里
//             NSMutableArray *dinggeArray = [NSMutableArray array];
//             
//             for (DingGeModel *model in arraymodel) {
//                 
//                 DingGeSecondModel * dingmodel = [[DingGeSecondModel alloc]init];
//                 
//                 dingmodel.movieImg = model.image;
//                 
//                 [dinggeArray addObject:dingmodel];
//                
//             }
//             _DingArr = dinggeArray;
           
             
          
            [_tableView reloadData];
                     
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
        _textView.frame = CGRectMake(0, 560, 375, 44);
        _textFiled.frame = CGRectMake(10, 4.5, 300, 35);
        _tableView.frame=CGRectMake(0, 0, 375, 560);
        _image.frame = CGRectMake(0, 0, 375, 44);
    }];
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - keyboard events -

///键盘显示事件
- (void) keyboardShow:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.25 animations:^{
        _textView.frame = CGRectMake(0, 500-216-44, 375,104);
        _tableView.frame=CGRectMake(0, 0, 375, 500-216-44);
    }];


}
///键盘关闭事件
- (void) keyboardHid:(NSNotification *)notification {
    
  [UIView animateWithDuration:2.5 animations:^{
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
            _image.frame = CGRectMake(0, 0, 375, 104);
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
            _image.frame = CGRectMake(0, 0, 375, 44);
        }];
    
    
    return YES;
}




-(NSArray *)statusFrames{
    if (_statusFrames == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (int i = 0; i < 10; i++ ) {
            
            //创建MLStatus模型
            CommentModel *model = [[CommentModel alloc]init];
            model.comment= [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section==0) {
        return 1;
    }else{
    return self.statusFrames.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section==0) {
        
        static NSString *ID = @"Cell";
        
        DingGeSecondTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        
        if (!cell) {
            cell = [[DingGeSecondTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
//        DingGeModel * model  = _DingArr[indexPath.row];
//        
//        
        NSString * string = self.movieID;
        
        
        
        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        
        [imageView setImage:cell.movieImg.image];
        
        [cell.contentView addSubview:imageView];
        

        
        return cell;
        
    }else{
    
        //创建cell
        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
        //设置高度
        cell.modelFrame = self.statusFrames[indexPath.row];
        
        return cell;
        
    }
    return nil;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 190;
    }
    else{
            CommentModelFrame *modelFrame = self.statusFrames[indexPath.row];
            return modelFrame.cellHeight;
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

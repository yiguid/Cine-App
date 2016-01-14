//
//  CineFeedBackViewController.m
//  cine
//
//  Created by wang on 15/12/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CineFeedBackViewController.h"
#import <QiniuSDK.h>
#import "RestAPI.h"
#import "MBProgressHUD.h"
#import "MySettingTableViewController.h"
@interface CineFeedBackViewController ()



@property(nonatomic,strong)UITextView *textView;
@property MBProgressHUD *hud;
@end

@implementation CineFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    
    
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10,10, wScreen-20,hScreen)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:18];
    _textView.text = @"请输入您的意见";
    _textView.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    [self.view addSubview:_textView];
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    self.navigationItem.rightBarButtonItem=item;

    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = YES;
    
}


-(void)publish{
    
    
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    // Set custom view mode
    self.hud.mode = MBProgressHUDModeCustomView;
    
    self.hud.labelText = @"已提交";//显示提示
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
    

    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userID = [userDef stringForKey:@"userID"];
    
     NSString *urlString = @"http://fl.limijiaoyin.com:1337/feedback";
    
    NSDictionary *parameters = @{@"content": self.textView.text, @"user": userID};
                  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                  
                  [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
                  [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"提交成功 %@",responseObject);
                 
                      [self.hud show:YES];
                      [self.hud hide:YES afterDelay:1];
                      
                      MySettingTableViewController * myset = [[MySettingTableViewController alloc]init];
                      
                      [self.navigationController pushViewController:myset animated:YES];
                      
                      
                      
                      
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"提交失败 --- %@",error);
                  }];
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

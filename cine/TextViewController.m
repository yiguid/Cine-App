//
//  TextViewController.m
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "TextViewController.h"
#import "BackImageViewController.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.translucent = YES ;
    self.view.backgroundColor = [UIColor colorWithRed:179/255.0 green:168/255.0 blue:150/255.0 alpha:1] ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishButton:)] ;
    
    //  定义试图
    [self _initView] ;
    
}
// 定义试图
- (void)_initView
{
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, wScreen-20, hScreen/3.0)] ;
    _textView.backgroundColor = [UIColor whiteColor] ;
    _textView.delegate = self ;
    _textView.font = [UIFont systemFontOfSize:18] ;
    [self.view addSubview:_textView] ;
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, _textView.bottom+10, 200, 200)] ;
    [self.view addSubview:_imageView] ;
    
    // 给图片添加点击事件
    _imageView.userInteractionEnabled = YES ;
    UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGstAction:)] ;
    [_imageView addGestureRecognizer:tapGst] ;
    
    if(self.image == nil)
    {
//        _imageView.hidden = YES ;
        _imageView.backgroundColor = [UIColor purpleColor] ;
    }
    else
    {
        _imageView.image = self.screenshot ;
    }
    
    
}



// tag请求的数据
/*
{
    "posts": [
              {
                  "user": "5636fbee17ac9b551b1fb20c",
                  "content": "hell world",
                  "image": "http://baidu.com",
                  "votecount": 4,
                  "watchedcount": 4,
                  "createdAt": "2015-11-10T02:12:27.258Z",
                  "updatedAt": "2015-11-10T05:38:05.478Z",
                  "movie": "563ad218845552a11ed0b9fb",
                  "coordinate": "5641528b2223ac5e05b67004",
                  "id": "5641528b2223ac5e05b67002"
              }
              ],
    "name": "Good",
    "createdAt": "2015-11-05T06:19:19.793Z",
    "updatedAt": "2015-11-05T06:19:19.793Z",
    "id": "563af4e779078a61273e9a6b"
}

*/


//  右上角的点击事件
- (void)publishButton:(UIButton *)button
{
    // 请求tag，请求创建标签
    
    _tagIDArray = [NSMutableArray array] ;
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *urlString = @"http://fl.limijiaoyin.com:1337/tag" ;
    for (NSDictionary *dic in self.pointAndTextsArray) {
        NSDictionary *parameters = @{@"name":dic[@"text"]} ;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"----11111-------------请求成功 --- %@",responseObject) ;
            NSString *tagID = responseObject[@"id"] ;
            [_tagIDArray addObject:tagID] ;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败 --- %@",error) ;
        }];
    }
//    BackImageViewController *backImageView = [[BackImageViewController alloc]init] ;
//    backImageView.image = self.image ;
//    backImageView.imageUrlString = self.imageUrlString ;
//    backImageView.pointAndTextsArray = self.pointAndTextsArray ;
//    [self.navigationController pushViewController:backImageView animated:YES] ;
    
}

// 点击图片的事件
- (void)tapGstAction:(UITapGestureRecognizer *)tap
{
    [self.navigationController popViewControllerAnimated:YES] ;
}


@end

//
//  TextViewController.m
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "TextViewController.h"
#import "BackImageViewController.h"
#import <QiniuSDK.h>
#import "RestAPI.h"

@interface TextViewController ()

@property MBProgressHUD *hud;

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"发布中...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    self.tabBarController.tabBar.translucent = YES;
    self.view.backgroundColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishButton:)];
    
    //  定义视图
    [self _initView];
    
}
// 定义视图
- (void)_initView
{
    NSLog(@"%f | %f",wScreen,hScreen);
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, wScreen-20, 200)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_textView];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 150, wScreen-20, 500)];
    [self.view addSubview:_imageView];
    
    // 给图片添加点击事件
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGstAction:)];
    [_imageView addGestureRecognizer:tapGst];
    
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if(self.image == nil)
    {
//        _imageView.hidden = YES;
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    else
    {

        
        _imageView.image = self.screenshot;
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
    [self.view bringSubviewToFront:self.hud];
    [self.hud show:YES];
    _tagIDArray = [NSMutableArray array];
    _tagInfoArray = [NSMutableArray array];
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userID = [userDef stringForKey:@"userID"];
    
    NSString *urlString = TAG_API;
    for (NSDictionary *dic in self.pointAndTextsArray) {
        NSDictionary *parameters = @{@"name":dic[@"text"]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"----11111-------------请求成功 --- %@",responseObject);
            NSString *tagID = responseObject[@"id"];
            NSDictionary *tagDic = @{@"x":[dic objectForKey:@"x"],@"y":[dic objectForKey:@"y"],@"direction":[dic objectForKey:@"direction"]};
            [_tagIDArray addObject:tagID];
            [_tagInfoArray addObject:tagDic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败 --- %@",error);
        }];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //获取七牛存储的token
    [manager GET:QINIU_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //存储token值
        NSString *qiniuToken = responseObject[@"token"];
        //存储用户id
        NSString *qiniuDomain = responseObject[@"domain"];
        [userDef setObject:qiniuToken forKey:@"qiniuToken"];
        [userDef setObject:qiniuDomain forKey:@"qiniuDomain"];
        [userDef synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Qiniu Error: %@", error);
    }];
    
    
    
    
    //上传图片到七牛
    
    NSString *qiniuToken = [userDef stringForKey:@"qiniuToken"];
    NSString *qiniuBaseUrl = [userDef stringForKey:@"qiniuDomain"];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *data;
    if (UIImagePNGRepresentation(self.image) == nil) {
        data = UIImageJPEGRepresentation(self.image, 1);
    } else {
        data = UIImagePNGRepresentation(self.image);
    }
    
    NSLog(@"fabu wScreen: %f",wScreen,nil);
    NSLog(@"fabu picw: %f",self.image.size.width,nil);
    NSLog(@"fabu pich: %f",self.image.size.height,nil);
    
    [upManager putData:data key:self.imageUrlString token:qiniuToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"qiniu==%@", info);
                  NSLog(@"qiniu==%@", resp);
                  self.imageQiniuUrl = [NSString stringWithFormat:@"%@%@",qiniuBaseUrl,resp[@"key"]];
                  //创建定格测试
                  NSString *urlString = DINGGE_API;
                  NSDictionary *parameters = @{@"content": self.textView.text, @"image": self.imageQiniuUrl, @"user": userID, @"movie": self.movie.ID, @"tags": self.tagIDArray, @"coordinates": self.tagInfoArray};
                  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                  //申明返回的结果是json类型
                  manager.responseSerializer = [AFJSONResponseSerializer serializer];
                  //申明请求的数据是json类型
                  manager.requestSerializer=[AFJSONRequestSerializer serializer];
                  
                  [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
                  [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"----create post-------------请求成功 --- %@",responseObject);
                      [self.hud hide:YES];
                      self.hud.labelText = @"发布成功...";//显示提示
                      [self.hud show:YES];
                      [self.hud hide:YES];
                      [self.navigationController popToRootViewControllerAnimated:YES];
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"请求失败 --- %@",error);
                  }];

              } option:nil];
    
    /*
     content: 内容
     image： 图片地址
     user： user id
     tags: tag id 数组
     movie: 电影id
     coordinates: 标签坐标数组
     */
    
    //    BackImageViewController *backImageView = [[BackImageViewController alloc]init];
//    backImageView.image = self.image;
//    backImageView.imageUrlString = self.imageUrlString;
//    backImageView.pointAndTextsArray = self.pointAndTextsArray;
//    [self.navigationController pushViewController:backImageView animated:YES];
    
}

// 点击图片的事件
- (void)tapGstAction:(UITapGestureRecognizer *)tap
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

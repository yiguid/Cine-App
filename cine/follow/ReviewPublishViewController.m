//
//  ReviewPublishViewController.m
//  cine
//
//  Created by Guyi on 15/12/14.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ReviewPublishViewController.h"
#import <QiniuSDK.h>
#import "RestAPI.h"

@implementation ReviewPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"发布中...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    self.navigationItem.title = @"发布影评";
    self.good = YES;
    // 创建控件
    [self _initView];
    
    
    
    //键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name: UIKeyboardWillHideNotification object:nil];
    
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
   
    

}


///键盘显示事件
- (void) keyboardShow:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        self.view.center = CGPointMake(self.view.center.x, keyBoardEndY  - self.view.bounds.size.height/2.0);
    }];

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_textView resignFirstResponder];
}



- (void)_initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, wScreen-20, hScreen/2.5)];
    self.bgImageView.image = self.image;
    [self.view addSubview:self.bgImageView];
    
    self.movieName = [[UILabel alloc] initWithFrame:CGRectMake(10, self.bgImageView.bottom + 4, wScreen - 20, 20)];
    self.movieName.textAlignment = NSTextAlignmentCenter;
    self.movieName.text = self.movie.title;
    [self.view addSubview:self.movieName];
    
    //好评差评
    self.goodBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.bgImageView.bottom + 10, wScreen/2 - 10, 100)];
    [self.goodBtn setImage:[UIImage imageNamed:@"good-selected.png"] forState:UIControlStateNormal];
    [self.goodBtn addTarget:self action:@selector(goodBtnPressed) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.goodBtn];
    //我喜欢，给它好评
    self.goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.bgImageView.bottom + 96, wScreen/2 - 10, 20)];
    self.goodLabel.textAlignment = NSTextAlignmentCenter;
    self.goodLabel.text = @"我喜欢，给它好评";
    self.goodLabel.textColor = [UIColor blackColor];
    self.goodLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.goodLabel];
    
    
    //我不喜欢，给它差评
    self.badLabel = [[UILabel alloc] initWithFrame:CGRectMake(wScreen/2 + 10, self.bgImageView.bottom + 96, wScreen/2 - 10, 20)];
    self.badLabel.textAlignment = NSTextAlignmentCenter;
    self.badLabel.text = @"我不喜欢，给差评";
    self.badLabel.textColor = [UIColor lightGrayColor];
    self.badLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.badLabel];
    
    self.badBtn = [[UIButton alloc] initWithFrame:CGRectMake(wScreen/2 + 10, self.bgImageView.bottom + 10, wScreen/2 - 10, 100)];
    [self.badBtn setImage:[UIImage imageNamed:@"bad.png"] forState:UIControlStateNormal];
    [self.badBtn addTarget:self action:@selector(badBtnPressed) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.badBtn];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, self.badBtn.bottom + 10, wScreen-20, 200)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:18];
    _textView.text = @"我的评价";
    [self.view addSubview:_textView];
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    self.navigationItem.rightBarButtonItem=item;
    
}

-(void)goodBtnPressed{
    [self.badBtn setImage:[UIImage imageNamed:@"bad.png"] forState:UIControlStateNormal];
    [self.goodBtn setImage:[UIImage imageNamed:@"good-selected.png"] forState:UIControlStateNormal];
    self.goodLabel.textColor = [UIColor blackColor];
    self.badLabel.textColor = [UIColor lightGrayColor];
    self.good = YES;
}

-(void)badBtnPressed{
    [self.badBtn setImage:[UIImage imageNamed:@"bad-selected.png"] forState:UIControlStateNormal];
    [self.goodBtn setImage:[UIImage imageNamed:@"good.png"] forState:UIControlStateNormal];
    self.goodLabel.textColor = [UIColor lightGrayColor];
    self.badLabel.textColor = [UIColor blackColor];
    self.good = NO;
}

-(void)publish{
    [self.view bringSubviewToFront:self.hud];
    [self.hud show:YES];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userID = [userDef stringForKey:@"userID"];
    
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
    
    [upManager putData:data key:self.urlString token:qiniuToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"qiniu==%@", info);
                  NSLog(@"qiniu==%@", resp);
                  self.imageQiniuUrl = [NSString stringWithFormat:@"%@%@",qiniuBaseUrl,resp[@"key"]];
                  //创建定格测试
                  NSString *urlString = @"http://fl.limijiaoyin.com:1337/review";
                  NSString *isGood = @"true";
                  if (!self.good) {
                      isGood = @"false";
                  }
                  NSDictionary *parameters = @{@"content": self.textView.text, @"image": self.imageQiniuUrl, @"user": userID, @"movie": self.movie.ID, @"good": isGood};
                  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//                  //申明返回的结果是json类型
//                  manager.responseSerializer = [AFJSONResponseSerializer serializer];
//                  //申明请求的数据是json类型
//                  manager.requestSerializer=[AFJSONRequestSerializer serializer];
                  
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
}

@end

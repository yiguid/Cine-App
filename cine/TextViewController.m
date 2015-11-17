//
//  TextViewController.m
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.translucent = YES ;
    self.view.backgroundColor = [UIColor lightGrayColor] ;
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
    if(self.image == nil)
    {
//        _imageView.hidden = YES ;
        _imageView.backgroundColor = [UIColor purpleColor] ;
    }
    else
    {
        _imageView.image = self.image ;
    }
    
    
}

//  右上角的点击事件
- (void)publishButton:(UIButton *)button
{
    NSLog(@"发布成功") ;
}


@end

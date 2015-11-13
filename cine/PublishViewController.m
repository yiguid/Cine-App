//
//  PublishViewController.m
//  cine
//
//  Created by Deluan on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "PublishViewController.h"

@interface PublishViewController ()

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"定格" ;
    self.view.backgroundColor = [UIColor purpleColor] ;
    
    // 创建右上角的按钮
    [self _initRightBar] ;
    
    // 创建试图
    [self _initView] ;

}
// 创建右上角的按钮
- (void)_initRightBar
{
    
}
- (void)_initView
{

    _bgviewImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wScreen, 300)] ;
    _bgviewImage.backgroundColor = [UIColor grayColor] ;
    [self.view addSubview:_bgviewImage] ;
    
}

@end

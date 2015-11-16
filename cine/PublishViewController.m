//
//  PublishViewController.m
//  cine
//
//  Created by Deluan on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "PublishViewController.h"
#import "EditPhotoViewController.h"

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

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    rightButton.frame = CGRectMake(0, 0, 100, 44) ;
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal] ;
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [rightButton addTarget:self action:@selector(rightbuttonAction:) forControlEvents:UIControlEventTouchUpInside] ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton]  ;
}
- (void)_initView
{

    _bgviewImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, wScreen-20, 200)] ;
    _bgviewImage.image = [UIImage imageNamed:@"2011102267331457.jpg"] ;
    [self.view addSubview:_bgviewImage] ;
    
    // 点击开发相册获取图片
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    button.frame = CGRectMake(10, 300+10, 50, 50) ;
    button.backgroundColor = [UIColor redColor] ;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview:button] ;
    
}

// 点击获取图片的点击事件
#pragma mark -  点击获取图片的点击事件
- (void)buttonAction:(UIButton *)button
{
    // 1.创建相册控制器对象
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    // 设置代理对象
    imagePickerVC.delegate = self;
    // 设置照片的编辑模式
    imagePickerVC.allowsEditing = YES;
    // 指定媒体类型
    // 1.获取相册里面的图片，2.获取相册里面的时候，3.打开照相机，4.打开录像机
    imagePickerVC.mediaTypes = @[@"public.image"];
    //    imagePickerVC.mediaTypes = @[@"public.image",@"public.movie"];
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    // 3.通过模态视图弹出相册控制器（因为系统的相册控制器是导航控制器）
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark -  相册对象的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取点击的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage] ;
    // 把图片设置到试图上
    _bgviewImage.image = image ;
    // 关闭相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil] ;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil] ;
}

#pragma mark - rightBarButtonAction 右上角点击事件
- (void)rightbuttonAction:(UIButton *)button
{
    EditPhotoViewController *editPhotoView = [[EditPhotoViewController alloc]init] ;
    editPhotoView.image = _bgviewImage.image ;
    [self.navigationController pushViewController:editPhotoView animated:YES] ;
}

@end

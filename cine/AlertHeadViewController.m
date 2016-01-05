//
//  AlertHeadViewController.m
//  cine
//
//  Created by wang on 16/1/5.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "AlertHeadViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "UserModel.h"
#import "MJExtension.h"
#import <QiniuSDK.h>
@interface AlertHeadViewController ()

@end

@implementation AlertHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.finishUpload = @"uploading";
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"上传中...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
  
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    //头像圆形
    [photoView.layer setCornerRadius:CGRectGetHeight([photoView bounds])/2];
    photoView.layer.masksToBounds = YES;
    
    //头像边框
    photoView.layer.borderColor = [UIColor whiteColor].CGColor;
    photoView.layer.borderWidth = 1.5;
    
    //头像 图片 获取
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    _pickerController.allowsEditing = YES;

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma UIImagePickerController Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //	[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 按钮
-(IBAction)photo:(id)sender//获得头像
{
    [self selectForAlbumButtonClick];
    
}
#pragma mark - 头像的选取
- (void)selectForAlbumButtonClick{
    
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [myActionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return; }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
    //[actionSheet removeFromSuperview];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"请在真机中使用");
    }
}
- (void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
}
-(void)headImage//头像加载
{
    NSString *urlStr=[NSString stringWithFormat:@"%@",headImageStr];
    NSURL *urlHead=[NSURL URLWithString:urlStr];
    NSData *datahead=[NSData dataWithContentsOfURL:urlHead];
    UIImage *imageHead=[UIImage imageWithData:datahead];
    photoView.image = imageHead;
    
}


//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    
    photoView.image=image;
    //    imageForHead =  editingInfo[UIImagePickerControllerOriginalImage];
    headImage=UIImagePNGRepresentation(image);
    //上传头像方法
    [self putimageUp];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 头像上传
//上传头像方法

-(void)putimageUp
{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //上传图片到七牛
    
    NSString *qiniuToken = [userDef stringForKey:@"qiniuToken"];
    NSString *qiniuBaseUrl = [userDef stringForKey:@"qiniuDomain"];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *data;
    if (UIImagePNGRepresentation(photoView.image) == nil) {
        data = UIImageJPEGRepresentation(photoView.image, 1);
    } else {
        data = UIImagePNGRepresentation(photoView.image);
    }
    [self.hud show:YES];
    [upManager putData:data key:self.urlString token:qiniuToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  
                  self.imageQiniuUrl = [NSString stringWithFormat:@"%@%@",qiniuBaseUrl,resp[@"key"]];
                  NSUserDefaults * accountDefaults = [NSUserDefaults standardUserDefaults];
                  [accountDefaults setObject:self.imageQiniuUrl forKey:@"avatarURL"];
                  NSLog(@"保存成功%@",self.imageQiniuUrl);
                  self.finishUpload = @"finished";
                  [self.hud hide:YES];
                  
              } option:nil];
    
}
- (IBAction)saveuserimage:(id)sender {
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSDictionary *parameters = @{@"avatarURL":self.imageQiniuUrl};
    NSString *url = [NSString stringWithFormat:@"%@/%@",USER_AUTH_API,userId];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager PUT:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"请求成功");
             
            [self.navigationController popToRootViewControllerAnimated:YES];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
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

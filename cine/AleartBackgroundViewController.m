//
//  AleartBackgroundViewController.m
//  cine
//
//  Created by wang on 16/1/16.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "AleartBackgroundViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "UserModel.h"
#import "MJExtension.h"
#import <QiniuSDK.h>
@interface AleartBackgroundViewController ()

@end

@implementation AleartBackgroundViewController

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
    
    
    //背景 图片 获取
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
-(IBAction)photo:(id)sender//获得
{
    [self selectForAlbumButtonClick];
    
}
#pragma mark - 选取
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
-(void)headImage//背景图片加载
{
    NSString *urlStr=[NSString stringWithFormat:@"%@",headImageStr];
    NSURL *urlHead=[NSURL URLWithString:urlStr];
    NSData *datahead=[NSData dataWithContentsOfURL:urlHead];
    UIImage *imageHead=[UIImage imageWithData:datahead];
    photo.contentMode =  UIViewContentModeCenter;
    photo.clipsToBounds  = YES;
    photoView.image = imageHead;
   
}


//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    
    photoView.image=image;
    //    imageForHead =  editingInfo[UIImagePickerControllerOriginalImage];
    headImage=UIImagePNGRepresentation(image);
    //上传方法
    [self putimageUp];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 上传
//上传方法

-(void)putimageUp
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
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
    
    
    
    
    
    
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
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
                  [accountDefaults setObject:self.imageQiniuUrl forKey:@"backgroundImage"];
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
    NSDictionary *parameters = @{@"backgroundImage":self.imageQiniuUrl};
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

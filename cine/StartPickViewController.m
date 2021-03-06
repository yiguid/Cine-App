//
//  StartPickViewController.m
//  cine
//
//  Created by wang on 15/12/24.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "StartPickViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "UserModel.h"
#import "MJExtension.h"
#import <QiniuSDK.h>

@interface StartPickViewController ()

@end

@implementation StartPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.finishUpload = @"uploading";
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"上传中...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    self.title = @"设置头像";
   
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
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
    
    [self modifyUIButton:self.nextBtn];
   
}

- (void)modifyUIButton: (UIButton *) button {
    button.backgroundColor = [UIColor grayColor];
    CGRect rect = button.frame;
    rect.size.height = 50;
    button.frame = rect;
    button.layer.cornerRadius = 6.0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
    //获取七牛存储的token
    
    //上传图片到七牛
    
    NSString *qiniuToken = [userDef stringForKey:@"qiniuToken"];
    NSString *qiniuBaseUrl = [userDef stringForKey:@"qiniuDomain"];
//    NSString *token = [userDef stringForKey:@"token"];

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
                  [self.hud hide:YES afterDelay:2];
                  
              } option:nil];
    
}
- (IBAction)saveuserimage:(id)sender {
    
    
    if ([self.finishUpload isEqualToString:@"finished"]) {
        //下一步
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"StartGenderScene"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        UIImageView * imageview = [[UIImageView alloc]init];
        imageview.image = [UIImage imageNamed:@"默认头像.png"];
        
        
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        //获取七牛存储的token
        
        //上传图片到七牛
        
        NSString *qiniuToken = [userDef stringForKey:@"qiniuToken"];
        NSString *qiniuBaseUrl = [userDef stringForKey:@"qiniuDomain"];
        //    NSString *token = [userDef stringForKey:@"token"];
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        NSData *data;
        if (UIImagePNGRepresentation(imageview.image) == nil) {
            data = UIImageJPEGRepresentation(imageview.image, 1);
        } else {
            data = UIImagePNGRepresentation(imageview.image);
        }
        [self.hud show:YES];
        [upManager putData:data key:self.urlString token:qiniuToken
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      
                      self.imageQiniuUrl = [NSString stringWithFormat:@"%@%@",qiniuBaseUrl,resp[@"key"]];
                      NSUserDefaults * accountDefaults = [NSUserDefaults standardUserDefaults];
                      [accountDefaults setObject:self.imageQiniuUrl forKey:@"avatarURL"];
                      NSLog(@"保存成功%@",self.imageQiniuUrl);
                      [self.hud hide:YES afterDelay:2];
                      
                      //下一步
                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                      UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"StartGenderScene"];
                      [self.navigationController pushViewController:vc animated:YES];
                      
                  } option:nil];

        
        

       
    
    }
    
}
- (IBAction)goBack:(id)sender{
    
    
     [self.navigationController popViewControllerAnimated:YES];


}

@end

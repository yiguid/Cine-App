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
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"发布中...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样

   
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    //头像 图片 获取
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    _pickerController.allowsEditing = YES;
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


#pragma mark - 按钮
-(IBAction)photo:(id)sender//获得头像
{
    [self selectForAlbumButtonClick];
    
}
//-(void)headImage//头像加载
//{
//    NSString *urlStr=[NSString stringWithFormat:@"http://fl.limijiaoyin.com:1337/%@",headImageStr];
//    NSURL *urlHead=[NSURL URLWithString:urlStr];
//    NSData *datahead=[NSData dataWithContentsOfURL:urlHead];
//    UIImage *imageHead=[UIImage imageWithData:datahead];
//   
//    photoView.image=imageHead;
//}
#pragma mark - 头像的选取
//访问相册
-(void)selectForAlbumButtonClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_pickerController animated:YES completion:nil];
    }
}
//访问摄像头
-(void)selectForCameraButtonClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_pickerController animated:YES completion:nil];
    }
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
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userID = [userDef stringForKey:@"userID"];
    
    //上传图片到七牛
    
    NSString *qiniuToken = [userDef stringForKey:@"qiniuToken"];
    NSString *qiniuBaseUrl = [userDef stringForKey:@"qiniuDomain"];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *data;
//    if (UIImagePNGRepresentation(self.image) == nil) {
//        data = UIImageJPEGRepresentation(self.image, 1);
//    } else {
//        data = UIImagePNGRepresentation(self.image);
//    }
    
    [upManager putData:data key:self.urlString token:qiniuToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                  self.imageQiniuUrl = [NSString stringWithFormat:@"%@%@",qiniuBaseUrl,resp[@"key"]];
                  //创建测试
                  NSString *urlString = @"http://fl.limijiaoyin.com:1337/auth";
                  NSDictionary *parameters = @{@"image": self.imageQiniuUrl, @"user": userID,};
                  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                  //申明返回的结果是json类型
                  manager.responseSerializer = [AFJSONResponseSerializer serializer];
                  //申明请求的数据是json类型
                  manager.requestSerializer=[AFJSONRequestSerializer serializer];
                  
                  [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
                  [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"----create post-------------请求成功 --- %@",responseObject);
                      
                      [self.navigationController popToRootViewControllerAnimated:YES];
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"请求失败 --- %@",error);
                  }];
                  
              } option:nil];

    
    
    
}
//- (IBAction)goBack:(id)sender {
//        [self.navigationController popViewControllerAnimated:YES];
//    }

@end

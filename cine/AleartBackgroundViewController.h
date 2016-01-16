//
//  AleartBackgroundViewController.h
//  cine
//
//  Created by wang on 16/1/16.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AleartBackgroundViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    
    IBOutlet UIButton *photo;
    IBOutlet UIImageView *photoView;
    //背景图片上传
    NSData * headImage;
    NSString *headImageStr;
    
    
}

// 图片的地址
@property(nonatomic,strong)NSString *urlString;
// 图片的路径
@property(nonatomic,strong)NSString *imageQiniuUrl;
@property(nonatomic,strong)NSString *finishUpload;
@property(nonatomic,strong) MBProgressHUD *hud;
//背景图片
@property (nonatomic )UIImagePickerController *pickerController;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property(nonatomic,strong)NSString * userID;


@end

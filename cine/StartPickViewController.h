//
//  StartPickViewController.h
//  cine
//
//  Created by wang on 15/12/24.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartPickViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{

    IBOutlet UIButton *photo;
    IBOutlet UIImageView *photoView;
    //头像图片上传
    NSData * headImage;
    NSString *headImageStr;


}

//传进来的图片
@property(nonatomic,strong)UIImage * image;

// 图片的地址
@property(nonatomic,strong)NSString *urlString;
// 图片的路径
@property(nonatomic,strong)NSString *imageQiniuUrl;
@property(nonatomic,strong) MBProgressHUD *hud;
//头像
@property (nonatomic )UIImagePickerController *pickerController;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

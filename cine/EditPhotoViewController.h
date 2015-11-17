//
//  EditPhotoViewController.h
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPhotoViewController : UIViewController

// 传进来的图片
@property(nonatomic,strong)UIImage *image ;

// 图片的地址
@property(nonatomic,strong)NSString *urlString ;

@end

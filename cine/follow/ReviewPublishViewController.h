//
//  ReviewPublishViewController.h
//  cine
//
//  Created by Guyi on 15/12/14.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface ReviewPublishViewController : UIViewController<UITextViewDelegate>
// 传进来的图片
@property(nonatomic,strong)UIImage *image;
// 图片的地址
@property(nonatomic,strong)NSString *urlString;

@property(nonatomic,strong)MovieModel *movie;

@property(nonatomic,strong)UIImageView *bgImageView;
// 图片的路径
@property(nonatomic,strong)NSString *imageQiniuUrl;

@property(nonatomic,strong) MBProgressHUD *hud;

@property(nonatomic,strong)UITextView *textView;


@property(nonatomic,strong)UIButton *goodBtn;
@property(nonatomic,strong)UILabel  *goodLabel;
@property(nonatomic,strong)UIButton *badBtn;
@property(nonatomic,strong)UILabel *badLabel;


@property(nonatomic,strong)UILabel *movieName;

@property BOOL good;

@end

//
//  EditPhotoViewController.h
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@protocol MLImageCropDelegate <NSObject>

- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage;

@end

@interface EditPhotoViewController : UIViewController<UIScrollViewDelegate>

// 传进来的图片
@property(nonatomic,strong)UIImage * image;

// 图片的地址
@property(nonatomic,strong)NSString *urlString;

@property(nonatomic,strong)MovieModel *movie;



@property float clipControl;



@property(nonatomic,weak) id<MLImageCropDelegate> delegate;
@property(nonatomic,assign) CGFloat ratioOfWidthAndHeight; //截取比例，宽高比

- (void)showWithAnimation:(BOOL)animation;



@end

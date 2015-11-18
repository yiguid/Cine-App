//
//  BackImageViewController.h
//  cine
//
//  Created by Deluan on 15/11/18.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackImageViewController : UIViewController

// 图片
@property(nonatomic,strong)UIImage *image ;

// 图片的路径
@property(nonatomic,strong)NSString *imageUrlString ;

// 接受图片信息的数组
@property(nonatomic,strong)NSArray *pointAndTextsArray ;


@end

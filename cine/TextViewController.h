//
//  TextViewController.h
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface TextViewController : UIViewController<UITextViewDelegate>

// 图片
@property(nonatomic,strong)UIImage *image;

// 截图
@property(nonatomic,strong)UIImage *screenshot;


// 图片的路径
@property(nonatomic,strong)NSString *imageUrlString;

// 便签的位置，文本，等信息
@property(nonatomic,strong)NSArray *pointAndTextsArray;

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIImageView *imageView;

// 存放tagID的数组
@property(nonatomic,strong)NSMutableArray *tagIDArray;

@property(nonatomic,strong)MovieModel *movie;

@end

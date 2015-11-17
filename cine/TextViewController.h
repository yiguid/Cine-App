//
//  TextViewController.h
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController<UITextViewDelegate>

// 图片
@property(nonatomic,strong)UIImage *image ;


// 图片的路径
@property(nonatomic,strong)NSString *urlString ;

// 便签的位置，文本，等信息
@property(nonatomic,strong)NSArray *pointAndTextsArray ;

@property(nonatomic,strong)UITextView *textView ;
@property(nonatomic,strong)UIImageView *imageView ;

@end

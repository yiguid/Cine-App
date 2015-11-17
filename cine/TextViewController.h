//
//  TextViewController.h
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController<UITextViewDelegate>

@property(nonatomic,strong)UIImage *image ;

@property(nonatomic,strong)UITextView *textView ;
@property(nonatomic,strong)UIImageView *imageView ;

@end

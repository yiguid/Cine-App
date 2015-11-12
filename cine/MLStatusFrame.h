//
//  MLStatusFrame.h
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>//如果是用XCode6的话,".h"文件中无法使用CGRect和CGFloat,需要使用改头文件

@class MLStatus;

@interface MLStatusFrame : NSObject

//头像的frame
@property(nonatomic, assign, readonly) CGRect iconF;
//昵称的frame
@property(nonatomic, assign, readonly) CGRect nameF;
//会员图标的frame
@property(nonatomic, assign, readonly) CGRect vipF;
//正文的frame
@property(nonatomic, assign, readonly) CGRect textF;
//配图的frame
@property(nonatomic, assign, readonly) CGRect pictureF;
//cell的高度
@property(nonatomic, assign, readonly) CGFloat cellHeight;

@property(nonatomic, strong) MLStatus *status;


@end

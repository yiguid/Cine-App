//
//  MLStatusFrame.h
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ShuoXiContentModel;
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

@property(nonatomic, strong) ShuoXiContentModel *model;


@end

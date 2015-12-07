//
//  MLStatus.h
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

/**
 * 数据模型
 */

#import <Foundation/Foundation.h>

@interface ShuoXiModel : NSObject
//正文
@property(nonatomic, copy) NSString *text;
//头像
@property(nonatomic, copy) NSString *icon;
//用户名
@property(nonatomic, copy) NSString *name;
//配图
@property(nonatomic, copy) NSString *picture;

//标示
@property(nonatomic,copy) NSString *mark;

@property(nonatomic, assign) BOOL vip;
//达人
@property(nonatomic,copy) NSString *daRenImg;

@property(nonatomic,copy) NSString *daRenTitle;

//时间
@property(nonatomic,copy) NSString *time;

//用户赞过图片
@property(nonatomic,copy) NSString *zambiaImg;

//用户赞过数量
@property(nonatomic,copy) NSString *zambiaCount;

//用户回复图片
@property(nonatomic,copy) NSString *answerImg;

//用户回复数
@property(nonatomic,copy) NSString *answerCount;

//筛选列表图片
@property(nonatomic,copy) NSString *screenImg;

//图片
@property(nonatomic,copy)NSString * image;


@end

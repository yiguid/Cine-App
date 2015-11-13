//
//  RecModel.h
//  cine
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecModel : NSObject

//电影图片
@property(nonatomic,copy) NSString *movieImg;

//用户图片
@property(nonatomic,copy) NSString *userImg;

//用户名
@property(nonatomic,copy) NSString *nikeName;

//时间
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *timeImg;

//用户感谢图片
@property(nonatomic,copy) NSString *appImg;

//用户感谢数量
@property(nonatomic,copy) NSString *appCount;

//筛选列表图片
@property(nonatomic,copy) NSString *screenImg;
//电影名
@property(nonatomic,copy) NSString *movieName;
//电影内容
@property(nonatomic,copy) NSString *text;
//电影标签
@property(nonatomic,copy) NSString *title;

@end

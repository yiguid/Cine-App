//
//  DingGeModel.h
//  cine
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DingGeModel : NSObject

//电影图片
@property(nonatomic,copy) NSString *movieImg;

//用户图片
@property(nonatomic,copy) NSString *userImg;

//用户名
@property(nonatomic,copy) NSString *nikeName;

//时间
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *timeImg;

//电影名
@property(nonatomic,copy) NSString *movieName;

//用户留言
@property(nonatomic,copy) NSString *message;

//用户浏览量图片
@property(nonatomic,copy) NSString *seeImg;

//用户浏览量数量
@property(nonatomic,copy) NSString *seeCount;

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


//___________________________________NEW MODEL ____________________________

@property(nonatomic,copy)NSMutableArray * comments;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSMutableArray * coordinate;
@property(nonatomic,copy)NSString * createdAt;
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSMutableArray * movie;
@property(nonatomic,copy)NSMutableArray * starring;
@property(nonatomic,copy)NSString * initialReleaseDate;
@property(nonatomic,copy)NSString * screenshots;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * updatedAt;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * year;
@property(nonatomic,copy)NSMutableArray * tags;
@property(nonatomic,copy)NSMutableArray * user;













@end

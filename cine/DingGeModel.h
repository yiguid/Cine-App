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


@end

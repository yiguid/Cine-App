//
//  DingGeSecondModel.h
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DingGeSecondModel : NSObject

//电影图片
@property(nonatomic,copy) NSString *movieImg;

//用户图片
@property(nonatomic,copy) NSString *userImg;

//用户名
@property(nonatomic,copy) NSString *nikeName;

//时间
@property(nonatomic,copy) NSString *time;
//时间图片
@property(nonatomic,copy) NSString *timeImg;

//用户评论
@property(nonatomic,copy) NSString *comment;

@property(nonatomic,copy) NSString *title;


@end

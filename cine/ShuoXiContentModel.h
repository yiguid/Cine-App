//
//  ShuoXiContentModel.h
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShuoXiContentModel : NSObject

@property(nonatomic,copy) NSString *movieImg;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,copy) NSString *nickName;
@property(nonatomic,copy) NSString *userImg;

//达人图片
@property(nonatomic,copy) NSString *daRenImg;
@property(nonatomic,copy) NSString *daRen;

//标示
@property(nonatomic,copy) NSString *mark;

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






@end

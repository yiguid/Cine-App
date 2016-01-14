//
//  GuanZhuFirstModel.h
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface GuanZhuModel : NSObject
//模式图片
@property(nonatomic,copy) NSString *avatarImg;
//用户名
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *userId;
//评论
@property(nonatomic,copy) NSString *content;
//右边图片
@property(nonatomic,copy) NSString *rightBtn;

@property(nonatomic,strong)UserModel * user;

@end

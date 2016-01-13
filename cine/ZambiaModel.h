//
//  ZambiaModel.h
//  cine
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface ZambiaModel : NSObject

//电影图片
@property(nonatomic,copy)NSString *avatarImg;
//评论提示
@property(nonatomic,copy)NSString *alert;
//评论内容
@property(nonatomic,copy)NSString *content;

@property(nonatomic,strong)UserModel * user;

@end

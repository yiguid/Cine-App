//
//  SecondModel.h
//  cine
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
//系统消息模型
@interface SecondModel : NSObject

//头像
@property(nonatomic,copy)NSString *img;
//信息
@property(nonatomic,copy)NSString *message;

@property(nonatomic,strong)UserModel * user;
@end

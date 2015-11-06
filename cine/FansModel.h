//
//  FansModel.h
//  cine
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FansModel : NSObject

//模式图片
@property(nonatomic,copy) NSString *avatarImg;
//用户名
@property(nonatomic,copy) NSString *nickname;
//评论
@property(nonatomic,copy) NSString *content;
//右边图片
@property(nonatomic,copy) NSString *rightBtn;
@end

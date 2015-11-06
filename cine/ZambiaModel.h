//
//  ZambiaModel.h
//  cine
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZambiaModel : NSObject

//电影图片
@property(nonatomic,copy)NSString *movieImg;
//评论提示
@property(nonatomic,copy)NSString *alert;
//评论内容
@property(nonatomic,copy)NSString *content;

@end

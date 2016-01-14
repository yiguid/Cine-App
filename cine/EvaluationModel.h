//
//  EvaluationModel.h
//  cine
//
//  Created by wang on 16/1/14.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "MovieModel.h"
#import "CommentModel.h"
@interface EvaluationModel : NSObject

//电影图片
@property(nonatomic,copy)NSString *movieimage;
//评论提示
@property(nonatomic,copy)NSString *alert;
//评论内容
@property(nonatomic,copy)NSString *content;

@property(nonatomic,strong)UserModel * user;
@property(nonatomic,strong)MovieModel * movie;
@property(nonatomic,strong)CommentModel * comment;

@end

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
#import "DingGeModel.h"
#import "RecModel.h"
#import "ReviewModel.h"
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
@property(nonatomic,strong)DingGeModel * post;
@property(nonatomic,strong)ReviewModel * review;
@property(nonatomic,strong)NSDictionary * who_vote;
@property(nonatomic,strong)NSString * is_read;
@property(nonatomic,strong)NSString * voteId;
@property(nonatomic,strong)NSDictionary * to;
@property(nonatomic,strong)NSDictionary * from;
@property(nonatomic,strong)RecModel * recommend;
@end

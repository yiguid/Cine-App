//
//  CommentModel.h
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "ReviewModel.h"
@interface CommentModel : NSObject

//用户名
@property(nonatomic,copy) NSString *nickName;
//头像
@property(nonatomic,copy) NSString *userImg;
//评论时间
@property(nonatomic,copy) NSString *time;
//评论内容
@property(nonatomic,copy) NSString *comment;
//赞图片
@property(nonatomic,copy) NSString *zambiaImg;
//赞数量
@property(nonatomic,copy) NSString *zambiaCounts;

//赞的人
@property(nonatomic,copy) NSMutableArray * voteBy;


//___________________________________NEW MODEL ____________________________


//rest api
@property(nonatomic,strong)UserModel * user;

@property(nonatomic,strong)ReviewModel * review;

@property(nonatomic,copy) NSString *content;

@property(nonatomic,copy) NSString *post;

@property(nonatomic,copy) NSString *commentType;

@property(nonatomic,copy) NSString *movie;

@property(nonatomic,copy) NSString *receiver;

@property(nonatomic,copy) NSString *voteCount;

@property(nonatomic,copy) NSString *createdAt;

@property(nonatomic,copy) NSString *updatedAt;

@property(nonatomic,copy) NSString *commentId;

@end

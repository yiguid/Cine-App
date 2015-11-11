//
//  CommentModel.h
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

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


@end

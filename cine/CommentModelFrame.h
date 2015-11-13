//
//  CommentModelFrame.h
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CommentModel;

@interface CommentModelFrame : NSObject

//头像的frame
@property(nonatomic, assign, readonly) CGRect iconF;
//昵称的frame
@property(nonatomic, assign, readonly) CGRect nameF;
//时间的frame
@property(nonatomic, assign, readonly) CGRect timeF;
//赞的frame
@property(nonatomic, assign, readonly) CGRect zambiaF;
//评论的frame
@property(nonatomic, assign, readonly) CGRect commentF;

//cell的高度
@property(nonatomic, assign, readonly) CGFloat cellHeight;

@property(nonatomic, strong) CommentModel *model;



@end

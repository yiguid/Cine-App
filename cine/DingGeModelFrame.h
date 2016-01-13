//
//  DingGeModelFrame.h
//  cine
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DingGeModel;
@interface DingGeModelFrame : NSObject

//头像的frame
@property(nonatomic, assign, readonly) CGRect iconF;
//昵称的frame
@property(nonatomic, assign, readonly) CGRect nameF;
//正文的frame
@property(nonatomic, assign, readonly) CGRect textF;
//配图的frame
@property(nonatomic, assign, readonly) CGRect pictureF;
//赞的frame
@property(nonatomic, assign, readonly) CGRect zambiaF;
//浏览的frame
@property(nonatomic, assign, readonly) CGRect seenF;
//时间的frame
@property(nonatomic, assign, readonly) CGRect timeF;
//电影名的frame
@property(nonatomic, assign, readonly) CGRect movieNameF;
//回复的frame
@property(nonatomic, assign, readonly) CGRect answerF;
//筛选的frame
@property(nonatomic, assign, readonly) CGRect screenF;

//分割线的frame
@property(nonatomic,assign,readonly) CGRect carviewF;


@property(nonatomic,assign) CGFloat imageHeight;

//cell的高度
@property(nonatomic, assign) CGFloat cellHeight;

@property(nonatomic, strong) DingGeModel *model;
-(CGFloat)getHeight: (DingGeModel *)model;

@end

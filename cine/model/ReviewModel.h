//
//  ReviewModel.h
//  cine
//
//  Created by Guyi on 15/12/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "UserModel.h"
#import "MovieModel.h"

@interface ReviewModel : NSObject

@property(nonatomic,strong)UserModel *user;
@property(nonatomic,strong)MovieModel *movie;
@property(nonatomic,strong)NSMutableArray *comments;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *good;
@property(nonatomic,copy)NSString *voteCount;
@property(nonatomic,copy)NSString *viewCount;
@property(nonatomic,copy)NSString *createdAt;
@property(nonatomic,copy)NSString *updatedAt;
@property(nonatomic,copy)NSString *reviewId;
@property(nonatomic,copy)NSString *vote;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * votecount;
@property(nonatomic,copy)NSString * watchedcount;
@property(nonatomic,copy)NSString * coordinate;
@property(nonatomic,copy) NSString *commentType;
@property(nonatomic,copy) NSMutableArray * voteBy;
@property(nonatomic,assign) CGFloat cellHeight;
-(CGFloat)getCellHeight;
@end

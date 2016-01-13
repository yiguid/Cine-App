//
//  RecModel.h
//  cine
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "UserModel.h"
#import "MovieModel.h"

@interface RecModel : NSObject


@property(nonatomic,copy)NSMutableArray * tags;
@property(nonatomic,strong)UserModel * user;
@property(nonatomic,strong)MovieModel * movie;
@property(nonatomic,strong)NSMutableArray * comments;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString * voteCount;
@property(nonatomic,copy)NSString * viewCount;
@property(nonatomic,copy)NSString * createdAt;
@property(nonatomic,copy)NSString * updatedAt;
@property(nonatomic,copy)NSString * recId;
@property(nonatomic,copy)NSString * thankCount;

@end

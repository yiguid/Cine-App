//
//  Activity.h
//  cine
//
//  Created by Guyi on 15/12/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieModel.h"
#import "UserModel.h"

@interface ActivityModel : NSObject

@property(nonatomic,strong)UserModel * user;
@property(nonatomic,strong)MovieModel * movie;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString *voteCount;
@property(nonatomic,copy)NSString *viewCount;
@property(nonatomic,copy)NSString * activityId;
@property(nonatomic,copy)NSMutableArray * professionals;
@property(nonatomic,copy)NSMutableArray * masters;
@property(nonatomic,copy)NSString * type;


@end

//
//  AppreciateModel.h
//  cine
//
//  Created by Guyi on 16/2/1.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieModel.h"
#import "UserModel.h"
#import "RecModel.h"


@interface AppreciateModel : NSObject

@property(nonatomic,strong) MovieModel *movie;
@property(nonatomic,strong) RecModel *recommend;
@property(nonatomic,strong)UserModel * user;

@end

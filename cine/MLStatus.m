//
//  MLStatus.m
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//


#import "MLStatus.h"

@implementation MLStatus
+(instancetype)statusWithDict:(NSDictionary *)dict{
    return [[MLStatus alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        //使用kvc(BOOL 和 int 类型kvc也可以实现转化)
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end

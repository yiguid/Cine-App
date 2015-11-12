//
//  MLStatus.h
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

/**
 * 数据模型
 */

#import <Foundation/Foundation.h>

@interface MLStatus : NSObject

@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *picture;
@property(nonatomic, assign) BOOL vip;

+(instancetype)statusWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;


@end

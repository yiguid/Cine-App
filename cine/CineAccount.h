//
//  CineAccount.h
//  cine
//
//  Created by Mac on 15/11/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineAccount : NSObject<NSCoding>
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) NSDate *expires; // 账号的过期时间


+ (instancetype)accountWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end

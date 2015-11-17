//
//  CineAccountTool.h
//  cine
//
//  Created by Mac on 15/11/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CineAccount;
@interface CineAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+ (void)saveAccount:(CineAccount *)account;

/**
 *  返回存储的账号信息
 */
+ (CineAccount *)account;

@end

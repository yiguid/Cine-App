//
//  CineAccountTool.m
//  cine
//
//  Created by Mac on 15/11/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CineAccountTool.h"
#import "CineAccount.h"
#define IWAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]


@implementation CineAccountTool

+ (void)saveAccount:(CineAccount *)account
{
    // 计算账号的过期时间
 //   NSDate *now = [NSDate date];
//    account.expires = [now dateByAddingTimeInterval:account.expires];
    
    [NSKeyedArchiver archiveRootObject:account toFile:IWAccountFile];
}

+ (CineAccount *)account
{
    // 取出账号
    CineAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:IWAccountFile];
    
    // 判断账号是否过期
    NSDate *now = [NSDate date];
    if ([now compare:account.expires] == NSOrderedAscending) { // 还没有过期
        return account;
    } else { // 过期
        return nil;
    }
}


@end

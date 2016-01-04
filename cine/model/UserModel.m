//
//  UserModel.m
//  cine
//
//  Created by Guyi on 15/12/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"userId" : @"id"};
}

@end

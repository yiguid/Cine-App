//
//  TagModel.m
//  cine
//
//  Created by Guyi on 15/12/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "TagModel.h"

@implementation TagModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"tagId" : @"id"};
}

@end

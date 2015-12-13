//
//  ReviewModel.m
//  cine
//
//  Created by Guyi on 15/12/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ReviewModel.h"

@implementation ReviewModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"reviewId" : @"id"};
}

@end

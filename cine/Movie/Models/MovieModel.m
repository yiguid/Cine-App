//
//  movieModel.m
//  cine
//
//  Created by Mac on 15/11/18.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MovieModel.h"
#import "MJExtension.h"

@implementation MovieModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}


-(NSString *)title{

    
    NSArray *strarray = [_title componentsSeparatedByString:@" "];
    
    _title = strarray[0];
    
    return _title;



}



@end

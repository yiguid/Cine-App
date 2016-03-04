//
//  CommentModel.m
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CommentModel.h"
#import <Foundation/Foundation.h>

@implementation CommentModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"commentId" : @"id"};
}


-(NSString *)createdAt{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    //中国时间
    NSTimeInterval secondsInEightHours = 8 * 60 * 60;
    
    
    NSDate * d = [[dateFormatter dateFromString:_createdAt] dateByAddingTimeInterval:secondsInEightHours];
    
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    
    NSString * timeString = nil;
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha = now - late;
    if (cha/3600 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num= [timeString intValue];
        
        if (num <= 1) {
            
            timeString = [NSString stringWithFormat:@"刚刚..."];
            
        }else{
            
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
            
        }
        
    }
    
    if (cha/3600 > 1 && cha/86400 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
        
    }
    
    if (cha/86400 > 1)
        
    {
        
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num = [timeString intValue];
        
        if (num < 2) {
            
            timeString = [NSString stringWithFormat:@"昨天"];
            
        }else if(num == 2){
            
            timeString = [NSString stringWithFormat:@"前天"];
            
        }else if (num > 2 && num <7){
            
            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        }else if (num >= 7 && num <= 10) {
            
            timeString = [NSString stringWithFormat:@"1周前"];
            
        }else if(num > 10){
            
            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        }
        
    }
    return timeString;
}




@end

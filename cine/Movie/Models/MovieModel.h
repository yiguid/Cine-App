//
//  movieModel.h
//  cine
//
//  Created by Mac on 15/11/18.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject


@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *year;
@property(nonatomic,copy) NSString *cover;
@property(nonatomic,copy) NSString *rating;
@property(nonatomic,copy) NSString *director;
@property(nonatomic,copy) NSMutableArray *genre;
@property(nonatomic,copy) NSString *initialReleaseDate;
@property(nonatomic,copy) NSMutableArray *starring;
@property(nonatomic,copy) NSMutableArray *screenshots;
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSMutableArray *favoriteby;


@end

//
//  MovieCollectionViewCell.m
//  cine
//
//  Created by Guyi on 15/12/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MovieCollectionViewCell.h"

@implementation MovieCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor grayColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 20)];
        [self addSubview:self.imageView];
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = [UIFont systemFontOfSize:12];
//        self.title.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.title];
    }
    
    return self;
}

@end

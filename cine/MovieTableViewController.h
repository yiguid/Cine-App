//
//  MovieTableViewController.h
//  cine
//
//  Created by Mac on 15/11/19.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Movie;
@interface MovieTableViewController : UITableViewController 

//@property(nonatomic,strong) Movie *movie;
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *name;

@end

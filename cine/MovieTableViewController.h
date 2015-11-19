//
//  MovieTableViewController.h
//  cine
//
//  Created by Mac on 15/11/19.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MovieModel;
@interface MovieTableViewController : UITableViewController

@property(nonatomic,strong) MovieModel *model;
//@property(nonatomic,copy) NSString *ID;

@end

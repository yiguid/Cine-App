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

@property(nonatomic,strong) Movie *movie;
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *name;

@property(strong,nonatomic) UITableView *mytableView;

//电影图片
@property(nonatomic,weak) UIImageView * movieView;
//电影名字
@property(nonatomic, weak) UILabel *titleView;
//头像
@property(nonatomic,weak) UIImageView * iconView;
//昵称
@property(nonatomic, weak) UILabel *nameView;
//正文
@property(nonatomic, weak) UILabel *textView;
//配图
@property(nonatomic, weak) UIImageView *pictureView;
//标示
@property(nonatomic,strong) UILabel *mark;
//时间
@property(nonatomic,strong) UILabel *time;


@end

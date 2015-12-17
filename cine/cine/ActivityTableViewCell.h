//
//  ActivityTableViewCell.h
//  cine
//
//  Created by Guyi on 15/12/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface ActivityTableViewCell : UITableViewCell
@property(nonatomic,strong)ActivityModel *model;

//电影图片
@property(nonatomic,strong) UIImageView *movieImg;

//用户图片
@property(nonatomic,strong) UIImageView *userImg;

//用户名
@property(nonatomic,strong) UILabel *nikeName;

//电影名
@property(nonatomic,strong) UILabel *movieName;

//影评内容
@property(nonatomic,strong) UILabel *comment;


@property(nonatomic,strong) UILabel *number;


- (void)setup :(ActivityModel *)model;
@end

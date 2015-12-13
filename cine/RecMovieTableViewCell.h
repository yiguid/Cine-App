//
//  RecMovieTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecModel.h"

@interface RecMovieTableViewCell : UITableViewCell

@property(nonatomic,strong)RecModel *model;

//电影图片
@property(nonatomic,strong) UIImageView *movieImg;

//用户图片
@property(nonatomic,strong) UIImageView *userImg;

//用户名
@property(nonatomic,strong) UILabel *nikeName;

//时间
@property(nonatomic,strong) UIButton *time;

//感谢按钮
@property(nonatomic,strong) UIButton *appBtn;
//筛选按钮
@property(nonatomic,strong) UIButton *screenBtn;
//电影名
@property(nonatomic,strong) UILabel *movieName;
//电影内容
@property(nonatomic,strong) UILabel *text;
//电影标签
@property(nonatomic,strong) UILabel *title;

@property(nonatomic,strong) UIView *mianView;



- (void)setup :(RecModel *)model;

@end

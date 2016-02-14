//
//  TuijianMovieTableViewCell.h
//  cine
//
//  Created by Guyi on 16/1/29.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecModel.h"

@interface TuijianMovieTableViewCell : UITableViewCell

@property(nonatomic,strong)RecModel *model;

//用户图片
@property(nonatomic,strong) UIImageView *userImg;

@property(nonatomic,strong) UIButton *userType;

@property(nonatomic,strong) UILabel *userDesc;

//用户名
@property(nonatomic,strong) UILabel *nickName;

@property(nonatomic,strong) UILabel *tag1;
@property(nonatomic,strong) UILabel *tag2;
@property(nonatomic,strong) UILabel *tag3;
@property(nonatomic,strong) UILabel *tag4;

//时间
@property(nonatomic,strong) UIButton *time;

//内容
@property(nonatomic,strong) UILabel *comment;

//感谢按钮
@property(nonatomic,strong) UIButton *appBtn;

//自定义线条
@property (strong, nonatomic) UIView * carview;


@property(nonatomic,assign) CGFloat cellHeight;


- (void)setup :(RecModel *)model;

@end

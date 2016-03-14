//
//  ShuoXiImgTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShuoXiModel.h"

@interface ShuoXiImgTableViewCell : UITableViewCell

@property(nonatomic,strong) ShuoXiModel *model;

@property(nonatomic,strong) UIImageView *movieImg;
@property(nonatomic,strong) UILabel *message;
@property(nonatomic,strong) UILabel *movieName;
@property(nonatomic,strong) UILabel *foortitle;


//用户回复数
@property(nonatomic,copy) NSString *answerCount;

//浏览量按钮
@property(nonatomic,strong) UIButton *seeBtn;
//赞过按钮
@property(nonatomic,strong) UIButton *zambiaBtn;
//回复按钮
@property(nonatomic,strong) UIButton *answerBtn;
//筛选按钮
@property(nonatomic,strong) UIButton *screenBtn;

//用户图片
@property(nonatomic,strong) UIImageView *userImg;

//用户名
@property(nonatomic,strong) UILabel *nikeName;

//时间
@property(nonatomic,strong) UILabel *time;

//自定义线条
@property (strong, nonatomic) UIView * carview;

//时间图片
@property(nonatomic,strong) UIImageView *timeImg;

@property(nonatomic,strong) UIImageView * certifyimage;

@property(nonatomic,strong) UILabel * certifyname;

@property(nonatomic,strong) UILabel *tiaoshi;

@property(nonatomic,strong) UILabel *tag1;
@property(nonatomic,strong) UILabel *tag2;
@property(nonatomic,strong) UILabel *tag3;
@property(nonatomic,strong) UILabel *tag4;


@property(nonatomic,strong) NSString * nullstring;

-(void) setup :(ShuoXiModel *)model;



@end

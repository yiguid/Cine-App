//
//  ReviewTableViewCell.h
//  cine
//
//  Created by Guyi on 15/12/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewModel.h"

@interface ReviewTableViewCell : UITableViewCell

@property(nonatomic,strong)ReviewModel *model;

//电影图片
//@property(nonatomic,strong) UIImageView *movieImg;

//用户图片
@property(nonatomic,strong) UIImageView *userImg;

//用户名
@property(nonatomic,strong) UILabel *nikeName;

//时间
@property(nonatomic,strong) UIButton *time;

//电影名
@property(nonatomic,strong) UILabel *movieName;

//影评内容
@property(nonatomic,strong) UILabel *comment;

//浏览量按钮
@property(nonatomic,strong) UIButton *seeBtn;
//赞过按钮
@property(nonatomic,strong) UIButton *zambiaBtn;
//回复按钮
@property(nonatomic,strong) UIButton *answerBtn;
//筛选按钮
@property(nonatomic,strong) UIButton *screenBtn;

//自定义线条
@property (strong, nonatomic) UIView * carview;



//影评标签，好评or差评
@property(nonatomic,strong) UILabel *reviewLabel;

//@property(nonatomic,strong) UIView *mianView;

- (void)setup :(ReviewModel *)model;
@end

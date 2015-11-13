//
//  MyDingGeTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DingGeModelFrame;
@interface MyDingGeTableViewCell : UITableViewCell

//电影图片
@property(nonatomic,strong) UIImageView *movieImg;

//用户图片
@property(nonatomic,strong) UIImageView *userImg;

//用户名
@property(nonatomic,strong) UILabel *nikeName;

//用户留言
@property(nonatomic,strong) UILabel *message;

//浏览量按钮
@property(nonatomic,strong) UIButton *seeBtn;
//赞过按钮
@property(nonatomic,strong) UIButton *zambiaBtn;
//回复按钮
@property(nonatomic,strong) UIButton *answerBtn;
//筛选按钮
@property(nonatomic,strong) UIButton *screenBtn;
//电影名
@property(nonatomic,strong) UILabel *movieName;

//时间按钮
@property(nonatomic,strong) UIButton *timeBtn;


@property(nonatomic, strong) DingGeModelFrame *modelFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end



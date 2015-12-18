
//  MianMLStatusCell.h
//  cine
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.


#import <UIKit/UIKit.h>
@class ShuoXiModel;
@interface MyShuoXiTableViewCell : UITableViewCell
@property(nonatomic, strong) ShuoXiModel *model;

//头像
@property(nonatomic, weak) UIImageView *iconView;
//昵称
@property(nonatomic, weak) UILabel *nameView;
//达人
@property(nonatomic, weak) UIImageView *vipView;
//正文
@property(nonatomic, weak) UILabel *textView;
//配图
@property(nonatomic, weak) UIImageView *pictureView;
//标示
@property(nonatomic,strong) UILabel *mark;
//达人
@property(nonatomic,strong) UIButton *daRen;

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




- (void) setup :(ShuoXiModel *)model;

@end

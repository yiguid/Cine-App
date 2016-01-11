//
//  GuanZhuFirstTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuanZhuModel;

@interface GuanZhuTableViewCell : UITableViewCell

@property(nonatomic,strong) GuanZhuModel *model;
//电影图片
@property (strong, nonatomic) UIImageView *avatarImg;
//用户名
@property (strong, nonatomic) UILabel *nickname;
//内容
@property (strong, nonatomic) UILabel *content;

//自定义线条
@property (strong, nonatomic) UIView * carview;



//按钮
@property (strong, nonatomic) UIImageView *rightBtn;
- (void)setup: (GuanZhuModel *)model;

@end

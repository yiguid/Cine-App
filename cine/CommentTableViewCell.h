//
//  CommentTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModelFrame;

@interface CommentTableViewCell : UITableViewCell


//用户头像
@property(nonatomic,strong) UIImageView *userImg;
//用户名
@property(nonatomic,strong) UILabel *nickName;
//评论
@property(nonatomic,strong) UILabel *comment;
//赞按钮
@property(nonatomic,strong) UIButton *zambia;
//时间
@property(nonatomic,strong) UILabel *time;
//自定义分割线
@property(nonatomic,strong) UIView * carview;

@property(nonatomic, strong) CommentModelFrame *modelFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

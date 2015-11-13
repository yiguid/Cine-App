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


@property(nonatomic,strong) UIImageView *userImg;

@property(nonatomic,strong) UILabel *nickName;

@property(nonatomic,strong) UILabel *comment;

@property(nonatomic,strong) UIButton *zambia;

@property(nonatomic,strong) UILabel *time;


@property(nonatomic, strong) CommentModelFrame *modelFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

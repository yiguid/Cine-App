//
//  headView.h
//  cine
//
//  Created by Mac on 15/11/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class headViewModel;
@interface HeadView : UIView

@property(nonatomic,strong) headViewModel *model;

/**
 * 背景图片
 */
@property(nonatomic,strong) UIImageView *backPicture;
/**
 * 头像
 */
@property(nonatomic,strong) UIImageView *userImg;
/**
 * 用户名
 */
@property(nonatomic,strong) UILabel *name;
/**
 * 标示
 */
@property(nonatomic,strong) UILabel *mark;
/**
 * 达人 匠人
 */
@property(nonatomic,strong) UIImageView * certifyimage;

@property(nonatomic,strong) UILabel * certifyname;

/**
 * 添加按钮
 */
@property(nonatomic,strong) UIButton *addBtn;

- (void) setup :(headViewModel *)model;
@end

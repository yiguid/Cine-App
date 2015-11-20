
//  MianMLStatusCell.h
//  cine
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.


#import <UIKit/UIKit.h>
@class MLStatus;
@interface MianMLStatusCell : UITableViewCell
@property(nonatomic, strong) MLStatus *status;

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

- (void) setup :(MLStatus *)status;
@end

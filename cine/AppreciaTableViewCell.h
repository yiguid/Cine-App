//
//  AppreciaTableViewCell.h
//  cine
//
//  Created by wang on 16/1/14.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppreciateModel;

@interface AppreciaTableViewCell : UITableViewCell

@property(nonatomic,strong) AppreciateModel *model;

@property (strong, nonatomic) UIImageView *movieImg;

@property (nonatomic,strong) UILabel * moviename;

//自定义分割线
@property(nonatomic,strong) UIView * carview;

@property (strong, nonatomic) UILabel * nickname;


- (void)setup: (AppreciateModel *)model;



@end

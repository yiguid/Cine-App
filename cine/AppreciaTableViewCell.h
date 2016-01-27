//
//  AppreciaTableViewCell.h
//  cine
//
//  Created by wang on 16/1/14.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RecModel.h"


@interface AppreciaTableViewCell : UITableViewCell

@property(nonatomic,strong) RecModel *model;

@property (strong, nonatomic) UIImageView *movieImg;

@property (nonatomic,strong) UILabel * moviename;

//自定义分割线
@property(nonatomic,strong) UIView * carview;

@property (strong, nonatomic) UILabel * nickname;


- (void)setup: (RecModel *)model;



@end

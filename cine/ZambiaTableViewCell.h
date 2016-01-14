//
//  ZambiaTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZambiaModel;

@interface ZambiaTableViewCell : UITableViewCell

@property(nonatomic,strong) ZambiaModel *model;

@property (strong, nonatomic) UIImageView * movieImg;
@property (strong, nonatomic) UILabel * moviename;
@property (strong, nonatomic) UILabel * nickname;
//自定义分割线
@property(nonatomic,strong) UIView * carview;

@property (strong,nonatomic) UILabel * text;




- (void)setup: (ZambiaModel *)model;




@end

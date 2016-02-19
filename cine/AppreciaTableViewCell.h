//
//  AppreciaTableViewCell.h
//  cine
//
//  Created by wang on 16/1/14.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaluationModel;
@interface AppreciaTableViewCell : UITableViewCell

@property(nonatomic,strong) EvaluationModel *model;

@property (strong, nonatomic) UIImageView *movieImg;

@property (nonatomic,strong) UILabel * moviename;

//自定义分割线
@property(nonatomic,strong) UIView * carview;

@property (strong, nonatomic) UILabel * nickname;


- (void)setup: (EvaluationModel *)model;



@end

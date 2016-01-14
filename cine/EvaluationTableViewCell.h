//
//  EvaluationTableViewCell.h
//  cine
//
//  Created by wang on 16/1/14.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EvaluationModel;

@interface EvaluationTableViewCell : UITableViewCell

@property(nonatomic,strong) EvaluationModel *model;
@property (strong, nonatomic) UILabel * moviename;
@property (strong, nonatomic) UIImageView *movieImg;


@property (strong, nonatomic) UILabel *content;

//自定义分割线
@property(nonatomic,strong) UIView * carview;

- (void)setup: (EvaluationModel *)model;



@end

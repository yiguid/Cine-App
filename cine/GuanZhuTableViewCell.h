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

@property (strong, nonatomic) UIImageView *avatarImg;
@property (strong, nonatomic) UILabel *nickname;
@property (strong, nonatomic) UILabel *content;
@property (strong, nonatomic) UIImageView *rightBtn;
- (void)setup: (GuanZhuModel *)model;

@end

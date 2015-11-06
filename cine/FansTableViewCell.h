//
//  FansTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FansModel;
@interface FansTableViewCell : UITableViewCell

@property(nonatomic,strong) FansModel *model;

@property (strong, nonatomic) UIImageView *avatarImg;
@property (strong, nonatomic) UILabel *nickname;
@property (strong, nonatomic) UILabel *content;
@property (strong, nonatomic) UIImageView *rightBtn;
- (void)setup: (FansModel *)model;


@end

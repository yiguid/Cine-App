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

@property (strong, nonatomic) UIImageView *userImg;
@property (strong, nonatomic) UILabel *alert;
@property (strong, nonatomic) UILabel *content;


- (void)setup: (ZambiaModel *)model;




@end

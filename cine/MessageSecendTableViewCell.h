//
//  FancSecendTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  SecondModel;
@interface MessageSecendTableViewCell : UITableViewCell

@property(nonatomic,strong)SecondModel *model;
//头像
@property(nonatomic,strong)UIImageView * userImg;
//信息
@property(nonatomic,strong)UILabel *message;

- (void)setup: (SecondModel *)model;
@end

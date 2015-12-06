//
//  MLStatusCell.h
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShuoXiModelFrame;

@interface ShuoXiCell : UITableViewCell
@property(nonatomic, strong) ShuoXiModelFrame *modelFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
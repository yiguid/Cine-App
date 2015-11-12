//
//  MLStatusCell.h
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLStatusFrame;

@interface MLStatusCell : UITableViewCell
@property(nonatomic, strong) MLStatusFrame *statusFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
//
//  MyStaticTableViewCell.h
//  cine
//
//  Created by Guyi on 15/11/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStaticTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *counts;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

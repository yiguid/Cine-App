//
//  MessageFirstTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MessageFirstTableViewCell.h"

@implementation MessageFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    CGFloat viewW = self.bounds.size.width;
    
    //定义图标
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 5, 5)];
    img.image = [UIImage imageNamed:@"follow@2x.png"];
    [self.contentView addSubview:img];
    
    //定义标题
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, viewW - 70, 30)];
    title.text = @"";
    [self.contentView addSubview:title];
    
    
    
}

@end

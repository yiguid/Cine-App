//
//  FancSecendTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MessageSecendTableViewCell.h"

@implementation MessageSecendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    CGFloat viewW = self.bounds.size.width;
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 60)];
    img.image = [UIImage imageNamed:@"shuoxiImg.png"];
    [self.contentView addSubview:img];
    
    UILabel *tit = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, viewW - 70, 60)];
    tit.text = @"和哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈和";
    tit.numberOfLines = 0;
    [self.contentView addSubview:tit];
}

@end

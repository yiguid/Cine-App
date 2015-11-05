//
//  FansTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "FansTableViewCell.h"

@implementation FansTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    CGFloat viewW = self.bounds.size.width;
    //   CGFloat viewH = self.bounds.size.height;
    
    //定义头像
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 50, 50)];
    img.image = [UIImage imageNamed:@"avatar@2x.png"];
    [self.contentView addSubview:img];
    //    img.image = [UIImage imageNamed:self.model.img];
    
    //定义用户名
    UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 100, 20)];
    nickName.text = @"嘿嘿嘿";
    nickName.font = [UIFont fontWithName:nil size:18];
    nickName.tintColor = [UIColor blackColor];
    [self.contentView addSubview:nickName];
    
    //定义评论
    UILabel *words = [[UILabel alloc] initWithFrame:CGRectMake(70, 50, viewW - 90, 20)];
    words.text = @"突突突突突";
    words.font = [UIFont fontWithName:nil size:14];
    words.tintColor = [UIColor grayColor];
    [self.contentView addSubview:words];
    
    
    //定义已关注按钮
    UIImageView *rightbtn = [[UIImageView alloc] initWithFrame:CGRectMake(viewW - 30, 20, 20, 40)];
    rightbtn.image = [UIImage imageNamed:@"cine@2x.png"];
    [self.contentView addSubview:rightbtn];

}

@end

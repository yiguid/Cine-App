//
//  GuanZhuFirstTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "GuanZhuTableViewCell.h"

@implementation GuanZhuTableViewCell : UITableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"%f init %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.avatarImg];
        //定义用户名
        self.nickname = [[UILabel alloc] init];
        [self.contentView addSubview:self.nickname];
        //定义评论
        self.content = [[UILabel alloc] init];
        [self.contentView addSubview:self.content];
        //定义已关注按钮
        self.rightBtn = [[UIImageView alloc] init];
        [self.contentView addSubview:self.rightBtn];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"%f select %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    // Configure the view for the selected state
    
    CGFloat viewW = self.bounds.size.width;
    [self.avatarImg setBounds:CGRectMake(10, 20, 50, 50)];
    
    
    [self.nickname setBounds:CGRectMake(70, 20, 100, 20)];
    self.nickname.font = [UIFont fontWithName:@"Helvetica" size:18];
    self.nickname.tintColor = [UIColor blackColor];
    
    
    [self.content setBounds:CGRectMake(70, 50, viewW - 90, 20)];
    self.content.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.content.tintColor = [UIColor grayColor];
    
    
    
    [self.rightBtn setBounds:CGRectMake(viewW - 30, 20, 20, 40)];
    
    self.avatarImg.image = [UIImage imageNamed:@"avatar@2x.png"];
    self.nickname.text = @"嘿嘿嘿";
    self.content.text = @"突突突突突";
    self.rightBtn.image = [UIImage imageNamed:@"cine@2x.png"];
}

- (void)setup: (GuanZhuModel *)model {
    NSLog(@"%f setup %f",self.bounds.size.width, self.window.bounds.size.width,nil);
}

@end

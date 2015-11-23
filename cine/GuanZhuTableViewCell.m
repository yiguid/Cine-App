//
//  GuanZhuFirstTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "GuanZhuTableViewCell.h"
#import "GuanZhuModel.h"

@implementation GuanZhuTableViewCell : UITableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.avatarImg];
        //定义用户名
        self.nickname = [[UILabel alloc] init];
        self.nickname.font = NameFont;
        self.nickname.tintColor = [UIColor blackColor];
        [self.contentView addSubview:self.nickname];
        //定义评论
        self.content = [[UILabel alloc] init];
        self.content.font = TextFont;
        self.content.tintColor = [UIColor grayColor];
        [self.contentView addSubview:self.content];
        //定义已关注按钮
        self.rightBtn = [[UIImageView alloc] init];
        [self.contentView addSubview:self.rightBtn];
    }
    return self;
}

- (void)layoutSubviews {
    
    //NSLog(@"%f layout %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    
    CGFloat viewW = self.bounds.size.width;
    [self.avatarImg setFrame:CGRectMake(10, 20, 50, 50)];
    
    [self.nickname setFrame:CGRectMake(70, 20, 100, 20)];
    
    [self.content setFrame:CGRectMake(70, 50, viewW - 90, 20)];
    
    [self.rightBtn setFrame:CGRectMake(viewW - 30, 20, 20, 20)];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   // NSLog(@"%f select %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    // Configure the view for the selected state
    //NSLog(@"%f:%f",self.bounds.origin.x, self.bounds.origin.y,nil);
    
}

- (void)setup: (GuanZhuModel *)model {
    //NSLog(@"%f setup %f",self.bounds.size.width, self.window.bounds.size.width,nil);
    
    self.avatarImg.image = [UIImage imageNamed:model.avatarImg];
    self.nickname.text = model.nickname;
    self.content.text = model.content;
    self.rightBtn.image = [UIImage imageNamed:model.rightBtn];

 //   self.rightBtn.image = [UIImage imageNamed:model.rightBtn];
}

@end

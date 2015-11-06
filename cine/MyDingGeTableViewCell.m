//
//  MyDingGeTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MyDingGeTableViewCell.h"
#import "DingGeModel.h"

@implementation MyDingGeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         //电影图片
        self.movieImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.movieImg];
        //用户图片
        self.userImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.userImg];
        //用户名
        self.nikeName = [[UILabel alloc]init];
        [self.contentView addSubview:self.nikeName];
        //用户留言
        self.message = [[UILabel alloc]init];
        self.message.numberOfLines = 0;
        [self.contentView addSubview:self.message];
        //用户浏览量
        self.seeBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.seeBtn];
        //赞过按钮
        self.zambiaBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.zambiaBtn];
        //回复按钮
        self.answerBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.answerBtn];
        //筛选按钮
        self.screenBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.screenBtn];
        
     }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = self.bounds.size.width;
    
    CGFloat imgW = (self.bounds.size.width - 35) / 4;
    CGFloat imgH = 20;
    CGFloat imgY = 270;

    [self.movieImg setFrame:CGRectMake(5, 5, viewW - 10, 190)];
    
    [self.userImg setFrame:CGRectMake(10, 170, 60, 60)];
    
    [self.nikeName setFrame:CGRectMake(70, 200, 100, 20)];
    
    [self.message setFrame:CGRectMake(10, 220, viewW - 25, 50)];
    
    [self.seeBtn setFrame:CGRectMake(10, 270, imgW, imgH)];
    
    [self.zambiaBtn setFrame:CGRectMake(15 + imgW, imgY, imgW, imgH)];
    
    [self.answerBtn setFrame:CGRectMake(20 + imgW * 2, imgY, imgW, imgH)];
    
    [self.screenBtn setFrame:CGRectMake(25 + imgW * 3, imgY, imgW, imgH)];
 }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setup: (DingGeModel *)model{
    self.movieImg.image = [UIImage imageNamed:model.movieImg];
    self.userImg.image = [UIImage imageNamed:model.userImg];
    self.nikeName.text = model.nikeName;
    self.message.text = model.message;
    [self.seeBtn setImage:[UIImage imageNamed:model.seeImg] forState:UIControlStateNormal];
    [self.seeBtn setTitle:model.seeCount forState:UIControlStateNormal];
    [self.seeBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.zambiaBtn setImage:[UIImage imageNamed:model.zambiaImg] forState:UIControlStateNormal];
    [self.zambiaBtn setTitle:model.zambiaCount forState:UIControlStateNormal];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];

    [self.answerBtn setImage:[UIImage imageNamed:model.answerImg] forState:UIControlStateNormal];
    [self.answerBtn setTitle:model.answerCount forState:UIControlStateNormal];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];

    [self.screenBtn setImage:[UIImage imageNamed:model.screenImg] forState:UIControlStateNormal];
  }

@end

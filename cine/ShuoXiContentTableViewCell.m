//
//  ShuoXiContentTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ShuoXiContentTableViewCell.h"
#import "ShuoXiContentModel.h"

@implementation ShuoXiContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.movieImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.movieImg];
    
    self.userImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.userImg];
    
    self.nikeName = [[UILabel alloc]init];
    [self.contentView addSubview:self.nikeName];
    
    self.message = [[UILabel alloc]init];
    [self.contentView addSubview:self.message];
    
    self.mark = [[UILabel alloc]init];
    [self.contentView addSubview:self.mark];
    
    self.time = [[UILabel alloc]init];
    [self.contentView addSubview:self.time];
    
    self.daRen = [[UIButton alloc]init];
    [self.contentView addSubview:self.daRen];
    
    self.zambiaBtn = [[UIButton alloc]init];
    [self.contentView addSubview:self.zambiaBtn];
    
    self.answerBtn = [[UIButton alloc]init];
    [self.contentView addSubview:self.answerBtn];
    
    self.screenBtn = [[UIButton alloc]init];
    [self.contentView addSubview:self.screenBtn];
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = self.bounds.size.width;
    
    CGFloat movieImgH = 0;
    
    self.message.numberOfLines = 0;
    
    CGFloat messageH = 100;
    
    [self.message setFrame:CGRectMake(20,0, viewW - 40, messageH)];
    
    
    if (self.movieImg != nil) {
        [self.movieImg setFrame:CGRectMake(20, messageH + 10, viewW - 40, 160)];
        
        movieImgH = 160;
    }
    
    CGFloat userImgH = messageH + movieImgH + 10;
    
    [self.userImg setFrame:CGRectMake(20, userImgH, 40, 40)];
    
    [self.nikeName setFrame:CGRectMake(80, userImgH, 80, 40)];
    
    [self.daRen setFrame:CGRectMake(180, userImgH, 60, 40)];
    
    [self.mark setFrame:CGRectMake(20, userImgH + 10, viewW, 20)];
    
    CGFloat imgW = (self.bounds.size.width - 35) / 4;
    CGFloat imgH = 20;
    CGFloat imgY = userImgH + 20;

    [self.zambiaBtn setFrame:CGRectMake(10, 270, imgW, imgH)];
    
    [self.answerBtn setFrame:CGRectMake(15 + imgW, imgY, imgW, imgH)];
    
    [self.screenBtn setFrame:CGRectMake(20 + imgW * 2, imgY, imgW, imgH)];
    
    [self.time setFrame:CGRectMake(25 + imgW * 3, imgY, imgW, imgH)];

}

- (void) setup:(ShuoXiContentModel *)model{
    self.movieImg.image = [UIImage imageNamed:model.movieImg];
    self.userImg.image = [UIImage imageNamed:model.userImg];
    self.nikeName.text = model.nickName;
    self.message.text = model.message;
 
    
    [self.zambiaBtn setImage:[UIImage imageNamed:model.zambiaImg] forState:UIControlStateNormal];
    [self.zambiaBtn setTitle:model.zambiaCount forState:UIControlStateNormal];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.answerBtn setImage:[UIImage imageNamed:model.answerImg] forState:UIControlStateNormal];
    [self.answerBtn setTitle:model.answerCount forState:UIControlStateNormal];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.screenBtn setImage:[UIImage imageNamed:model.screenImg] forState:UIControlStateNormal];
    
    self.time.text = model.time;
}

@end

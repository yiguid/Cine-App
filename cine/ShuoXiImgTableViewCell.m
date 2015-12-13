//
//  ShuoXiImgTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ShuoXiImgTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ShuoXiImgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.movieImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.movieImg];
    
    self.messageView = [[UIView alloc]init];
    [self.contentView addSubview:self.messageView];
    
    self.message = [[UILabel alloc]init];
    [self.messageView addSubview:self.message];
    [self.message setTextColor:[UIColor whiteColor]];
    [self.message setFont:TextFont];

    self.movieName = [[UILabel alloc]init];
    [self.messageView addSubview:self.movieName];
    [self.movieName setTextColor:[UIColor whiteColor]];
    [self.movieName setFont:NameFont];
    
    self.foortitle = [[UILabel alloc]init];
    [self.foortitle setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.foortitle];
    [self.foortitle setFont:NameFont];
    

    
    return self;
    
}

- (void)layoutSubviews{
    CGFloat viewW = self.bounds.size.width;
    
    CGFloat imgH = 160;
    CGFloat imgW = viewW;
    
    [self.movieImg setFrame:CGRectMake(0, 0, imgW, imgH)];
    [self.messageView setFrame:CGRectMake(0, imgH - 40, imgW, 40)];
    [self.movieName setFrame:CGRectMake(20, 0, imgW, 20)];
    [self.message setFrame:CGRectMake(20, 20, imgW, 20)];
    [self.foortitle setFrame:CGRectMake(0, 165, imgW, 20)];

}

- (void)setup:(ShuoXiModel *)model{
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    
    self.movieName.text = model.movie.title;
    
    self.message.text = model.content;
    
    self.foortitle.text = @"评论列表";
}

@end

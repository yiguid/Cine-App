//
//  ShuoXiImgTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ShuoXiImgTableViewCell.h"
#import "ShuoXiImgModel.h"

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
    [self.message setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];

    self.movieName = [[UILabel alloc]init];
    [self.messageView addSubview:self.movieName];
    [self.movieName setTextColor:[UIColor whiteColor]];
    [self.movieName setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    
    self.foortitle = [[UILabel alloc]init];
    [self.foortitle setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.foortitle];
    [self.message setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    

    
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

- (void)setup:(ShuoXiImgModel *)model{
    self.movieImg.image = [UIImage imageNamed:model.movieImg];
    
    self.movieName.text = model.movieName;
    
    self.message.text = model.message;
    
    self.foortitle.text = model.title;
}

@end

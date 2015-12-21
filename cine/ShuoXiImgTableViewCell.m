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
    [self.message setTextColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0]];
    [self.message setFont:TextFont];

    self.movieName = [[UILabel alloc]init];
    [self.messageView addSubview:self.movieName];
    [self.movieName setTextColor:[UIColor whiteColor]];
    [self.movieName setFont:NameFont];
    
    self.foortitle = [[UILabel alloc]init];
    [self.foortitle setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.foortitle];
    [self.foortitle setFont:NameFont];
    
    
    //赞过按钮
    self.zambiaBtn = [[UIButton alloc]init];
    [self.zambiaBtn setImage:[UIImage imageNamed:@"喜欢@2x.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.zambiaBtn];
    
    
    
    //回复按钮
    self.answerBtn = [[UIButton alloc]init];
    [self.answerBtn setImage:[UIImage imageNamed:@"评论@2x.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.answerBtn];
    //筛选按钮
    self.screenBtn = [[UIButton alloc]init];
    [self.screenBtn setImage:[UIImage imageNamed:@"_..@2x.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.screenBtn];
    
    

    self.time = [[UILabel alloc]init];
    [self.contentView addSubview:self.time];
    


    
    return self;
    
}

- (void)layoutSubviews{
    CGFloat viewW = self.bounds.size.width;
    
    CGFloat imgH = 160;
    CGFloat imgW = viewW;
    
    [self.movieImg setFrame:CGRectMake(0, 0, imgW, imgH+30)];
    [self.messageView setFrame:CGRectMake(0, 2, imgW, 40)];
    [self.movieName setFrame:CGRectMake(240, 170, imgW, 20)];
    [self.message setFrame:CGRectMake(5, 210, imgW, 20)];
    [self.foortitle setFrame:CGRectMake(0, 270, imgW, 20)];
    
    self.time.frame = CGRectMake(viewW-80, 240, 100, 20);
    self.time.textColor = [UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0];

    
    [self.zambiaBtn setFrame:CGRectMake(viewW-400, 240, 100, 20)];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.answerBtn setFrame:CGRectMake(viewW-300, 240, 100, 20)];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.screenBtn setFrame:CGRectMake(viewW-200, 240, 100, 20)];
    [self.screenBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.userImg setFrame:CGRectMake(10, 170, 60, 60)];
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0]};
    CGSize sizeN = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize sizeName = [self.nikeName.text boundingRectWithSize:sizeN options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [self.nikeName setFrame:CGRectMake(75, 200, sizeName.width, sizeName.height)];
    
   
   

}

- (void)setup:(ShuoXiModel *)model{
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    
    self.movieName.text = model.movie.title;
    
    self.message.text = model.content;
    
     self.foortitle.text = @"评论列表";
    [self.zambiaBtn setTitle:@"120" forState:UIControlStateNormal];
    [self.answerBtn setTitle:@"50" forState:UIControlStateNormal];
    
    self.userImg.image = [UIImage imageNamed:@"avatar.png"];
    self.nikeName.text = model.user.nickname;
    self.time.text = @"1天前";

}

@end

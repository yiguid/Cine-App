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
    
    self.userImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.userImg];
    
    self.nikeName = [[UILabel alloc]init];
    [self.contentView addSubview:self.nikeName];
    
    
    self.message = [[UILabel alloc]init];
    [self.contentView addSubview:self.message];
    [self.message setTextColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0]];
    [self.message setFont:TextFont];


//    [self.movieName setTextColor:[UIColor whiteColor]];
//    [self.movieName setFont:NameFont];
    
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
    
    [self.movieImg setFrame:CGRectMake(10,100, imgW-20, imgH+30)];
    [self.message setFrame:CGRectMake(10,40, imgW, 20)];
    [self.foortitle setFrame:CGRectMake(5, 400, imgW, 30)];
    [self.userImg setFrame:CGRectMake(10, 300, 40, 40)];
    [self.nikeName setFrame:CGRectMake(60, 300, 200, 40)];
    
    self.time.frame = CGRectMake(viewW-80, 370, 100, 20);
    self.time.textColor = [UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0];

    
    [self.zambiaBtn setFrame:CGRectMake(viewW-400, 370, 100, 20)];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.answerBtn setFrame:CGRectMake(viewW-300, 370, 100, 20)];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.screenBtn setFrame:CGRectMake(viewW-200, 370, 100, 20)];
    [self.screenBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
//    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0]};
//    CGSize sizeN = CGSizeMake(MAXFLOAT, MAXFLOAT);
//    CGSize sizeName = [self.nikeName.text boundingRectWithSize:sizeN options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
  
    
   
   

}

- (void)setup:(ShuoXiModel *)model{
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    
    self.movieName.text = model.movie.title;
    
    self.message.text = model.content;
    
     self.foortitle.text = @"评论列表";
    //[self.zambiaBtn setTitle:@"%@",model.voteCount forState:UIControlStateNormal];
   
    
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil];
    
    [self.userImg setImage:self.userImg.image];
    //头像圆形
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
    //头像边框
    self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImg.layer.borderWidth = 1.5;

    self.nikeName.text = model.user.nickname;
    NSInteger comments = model.comments.count;
    NSString * com = [NSString stringWithFormat:@"%ld",comments];
    model.answerCount = com;
    
    [self.answerBtn setTitle:com forState:UIControlStateNormal];
    
    self.time.text = model.createdAt;
  

}

@end

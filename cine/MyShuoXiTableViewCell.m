
//  MianMLStatusCell.m
//  cine
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.


#import "MyShuoXiTableViewCell.h"
#import "ShuoXiModel.h"
#import "UIImageView+WebCache.h"
@implementation MyShuoXiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //头像
    self.iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconView];
    
    //昵称
    self.nikeName = [[UILabel alloc]init];
    [self.contentView addSubview:self.nikeName];
    //        self.nameView = nameView;
    self.daRen = [[UIButton alloc]init];
    [self.daRen setImage:[UIImage imageNamed:@"crown@2x.png"] forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.daRen];
    //正文
    UILabel *textView = [[UILabel alloc]init];
    textView.font = TextFont;
    [self.contentView addSubview:self.textView];
    self.textView.textColor = [UIColor whiteColor];
    
    //配图
    UIImageView *pictureView = [[UIImageView alloc]init];
    [self.contentView addSubview:pictureView];
    self.pictureView = pictureView;
    //标示
    UILabel *mark = [[UILabel alloc]init];
    mark.font = MarkFont;
    [self.contentView addSubview:mark];
    self.mark = mark;
    
    self.movieName = [[UILabel alloc]init];
    [self.contentView addSubview:self.movieName];
    
    self.date = [[UILabel alloc]init];
    [self.contentView addSubview:self.date];
    
    
    
    self.time = [[UILabel alloc]init];
    [self.contentView addSubview:self.time];
    
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
    
    
    
    
    return self;
    
}

- (void)layoutSubviews{
    CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;
    //子控件之间的间距
    //   CGFloat padding = 10;
    //配图
    CGFloat pictureX = 5;
    CGFloat pictureY = 5;
    CGFloat pictureW = viewW - 10;
    CGFloat pictureH = 190;
    self.pictureView.frame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
    //正文
    CGFloat textX = 10;
    CGFloat textY = CGRectGetMaxY(self.pictureView.frame);
    self.textView.frame = CGRectMake(10 ,textY, viewW - 10, 30);
    
    //头像
    //   CGFloat iconX = 20;
   
    self.iconView.frame= CGRectMake(10, 220, 40, 40);
    
    //昵称
    //    CGSize nameSize = [self sizeWithText:model.user.nickname font:NameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    //    CGFloat nameW = nameSize.width;
   [self.nikeName setFrame:CGRectMake(90, 220, 200, 40)];
    
    //会员图标
    //    CGFloat vipX = CGRectGetMaxX(self.nameView.frame);
    //    CGFloat vipY = iconY;
    //    CGFloat vipW = 100;
    //    CGFloat vipH = 30;
    //    self.daRen.frame = CGRectMake(vipX, vipY, vipW, vipH);
    //
    //    CGFloat markY = CGRectGetMaxY(self.iconView.frame);
    //
    //    self.mark.frame = CGRectMake(10, markY, viewW - 20, 30);
    self.time.frame = CGRectMake(viewW-80, 270, 100, 20);
    self.time.textColor = [UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0];
    [self.zambiaBtn setFrame:CGRectMake(viewW-400, 270, 100, 20)];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.answerBtn setFrame:CGRectMake(viewW-300, 270, 100, 20)];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.screenBtn setFrame:CGRectMake(viewW-200, 270, 100, 20)];
    [self.screenBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    
    
//        UIView * commentview = [[UIView alloc]initWithFrame:CGRectMake(5,130,viewW-10, 65)];
//        commentview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//        [self.contentView addSubview:commentview];
    
    
    self.movieName.frame = CGRectMake(10, 140,viewW-20, 20);
    self.movieName.textColor = [UIColor whiteColor];
    
    self.date.frame = CGRectMake(10, 160, viewW-20, 30);
    self.date.textColor = [UIColor whiteColor];
   
    
}



- (void)setup: (ShuoXiModel *)model{
    
    
    //用户名
    self.nikeName.text =model.user.nickname;
    //正文
    self.textView.text = model.text;
    //配图
    self.pictureView.image = [UIImage imageNamed:model.picture];
//    self.mark.text = model.mark;
//    [self.daRen setTitle:model.daRenTitle forState:UIControlStateNormal];
//    [self.daRen setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    
    //self.iconView.image = [UIImage imageNamed:model.icon];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil];
    
    [self.iconView setImage:self.iconView.image];
    //头像圆形
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width/2;
    //头像边框
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconView.layer.borderWidth = 1.5;



    NSInteger comments = model.comments.count;
    NSString * com = [NSString stringWithFormat:@"%ld",comments];
    model.answerCount = com;

    [self.answerBtn setTitle:com forState:UIControlStateNormal];
 
    self.time.text = model.createdAt;
    
    self.movieName.text = model.movie.title;
    self.movieName.textColor = [UIColor whiteColor];
    self.date.text = model.movie.initialReleaseDate;
 }


-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end

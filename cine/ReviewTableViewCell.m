//
//  ReviewTableViewCell.m
//  cine
//
//  Created by Guyi on 15/12/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ReviewTableViewCell
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
        //时间
        self.time = [[UIButton alloc]init];
        [self.time setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.time];
        
        self.mianView = [[UIView alloc]init];
        [self.contentView addSubview:self.mianView];
        //电影名
        self.movieName = [[UILabel alloc]init];
        [self.contentView addSubview:self.movieName];
        self.movieName.textAlignment = NSTextAlignmentRight;
        self.movieName.layer.borderWidth = 1;
        [self.movieName.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorWithRed:57.0/255 green:37.0/255 blue:22.0/255 alpha:1.0])];
        self.movieName.font = TextFont;
        
        //评价内容
        self.comment = [[UILabel alloc]init];
        self.comment.numberOfLines = 0;
        self.comment.textColor = [UIColor whiteColor];
        //[self.mianView addSubview:self.comment];
        UIView * commentview = [[UIView alloc]initWithFrame:CGRectMake(5,100,wScreen-10, 95)];
        commentview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.contentView addSubview:commentview];
        [self.contentView addSubview:self.movieName];
        [self.contentView addSubview:self.userImg];
        [commentview addSubview:self.comment];
        
       
        //自定义分割线
        self.carview = [[UIView alloc]init];
        self.carview.backgroundColor = [ UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        [self.contentView addSubview:self.carview];
        
        
        //用户浏览量
        self.seeBtn = [[UIButton alloc]init];
        [self.seeBtn setImage:[UIImage imageNamed:@"看过@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.seeBtn];
        //赞过按钮
        self.zambiaBtn = [[UIButton alloc]init];
        [self.zambiaBtn setImage:[UIImage imageNamed:@"喜欢@2x"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.zambiaBtn];
        //回复按钮
        self.answerBtn = [[UIButton alloc]init];
        [self.answerBtn setImage:[UIImage imageNamed:@"评论@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.answerBtn];
        //筛选按钮
        self.screenBtn = [[UIButton alloc]init];
        [self.screenBtn setImage:[UIImage imageNamed:@"_..@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.screenBtn];
      
        
        //评价好坏
        self.reviewLabel = [[UILabel alloc]init];
        self.reviewLabel.textAlignment = NSTextAlignmentCenter;
        self.reviewLabel.textColor = [UIColor whiteColor];
        [self.mianView addSubview:self.reviewLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    
    [self.movieImg setFrame:CGRectMake(5, 5, viewW - 10, 190)];
    
    [self.userImg setFrame:CGRectMake(20, 180, 40, 40)];
    
    [self.nikeName setFrame:CGRectMake(70, 200, 100, 20)];
    
    [self.time setFrame:CGRectMake(viewW - 100, 200, 100, 20)];
    [self.time setTitleColor:[UIColor colorWithRed:110.0/255 green:110.0/255 blue:93.0/255 alpha:1.0] forState:UIControlStateNormal];
    //[self.time setTitle:model.createdAt forState:UIControlStateNormal];
    self.time.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    [self.movieName setFrame:CGRectMake(5, 175, viewW - 10, 20)];
    
    [self.comment setFrame:CGRectMake(5, 0, viewW - 10, 90)];
    CGFloat titY = CGRectGetMaxY(self.comment.frame) - 145;
    
    
    
    
    [self.reviewLabel setFrame:CGRectMake(10, titY-20, 60, 20)];
    
    [self.mianView setFrame:CGRectMake(5, 100, viewW - 10, 120)];
    
    [self.carview setFrame:CGRectMake(20, 230, wScreen-40, 1)];
    
    
    CGFloat imgW = (viewW - 35) / 4;
    
    [self.seeBtn setFrame:CGRectMake(0, 240, 100, 20)];
    [self.seeBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.seeBtn.titleLabel.font  = [UIFont systemFontOfSize: 13];
    self.seeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    
    [self.zambiaBtn setFrame:CGRectMake(10 + imgW, 240, 100, 20)];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.zambiaBtn.titleLabel.font  = [UIFont systemFontOfSize: 13];
    self.zambiaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    [self.answerBtn setFrame:CGRectMake(20 + imgW*2, 240, 100, 20)];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.answerBtn.titleLabel.font  = [UIFont systemFontOfSize: 13];
    self.answerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    [self.screenBtn setFrame:CGRectMake(30 + imgW*3, 240, 100, 20)];
    [self.screenBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    [super setSelected:selected animated:animated];
    
}

- (void)setup: (ReviewModel *)model{
    
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil];
    
    [self.userImg setImage:self.userImg.image];
    //头像圆形
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
    //头像边框
    self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImg.layer.borderWidth = 1.5;

    self.nikeName.text = model.user.nickname;
    [self.time setTitle:model.createdAt forState:UIControlStateNormal];
    if ([model.good isEqual:@"1"]) {
         self.reviewLabel.text = @"好评";
        self.reviewLabel.backgroundColor = [UIColor colorWithRed:244/255.0 green:132.0/255.0 blue:0 alpha:1.0];
    }else{
         self.reviewLabel.text = @"差评";
        self.reviewLabel.backgroundColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0];
        }
    
    
    [self.time setTitle:model.createdAt forState:UIControlStateNormal];
    self.time.titleLabel.font = [UIFont systemFontOfSize:15.0f];

    self.comment.text = model.content;
    self.movieName.text = [NSString stringWithFormat:@"《%@》",model.movie.title];
    self.movieName.textColor = [UIColor orangeColor];
    
    [self.zambiaBtn setTitle:model.voteCount forState:UIControlStateNormal];
    [self.seeBtn setTitle:model.viewCount forState:UIControlStateNormal];
    NSInteger comments = model.comments.count;
    NSString * com = [NSString stringWithFormat:@"%ld",comments];
    [self.answerBtn setTitle:com forState:UIControlStateNormal];
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end

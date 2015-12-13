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
        self.movieName.textColor = [UIColor grayColor];
        self.movieName.textAlignment = NSTextAlignmentRight;
        self.movieName.layer.borderWidth = 1;
        [self.movieName.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorWithRed:57.0/255 green:37.0/255 blue:22.0/255 alpha:1.0])];
        
        //评价内容
        self.comment = [[UILabel alloc]init];
        self.comment.numberOfLines = 0;
        self.comment.textColor = [UIColor whiteColor];
        [self.mianView addSubview:self.comment];
        
        //评价好坏
        self.reviewLabel = [[UILabel alloc]init];
        self.reviewLabel.layer.borderWidth = 1;
        self.reviewLabel.backgroundColor = [UIColor colorWithRed:111.0/255 green:115.0/255 blue:114.0/255 alpha:1.0];
        self.reviewLabel.textAlignment = NSTextAlignmentCenter;
        self.reviewLabel.layer.masksToBounds = YES;
        self.reviewLabel.layer.cornerRadius = 3.0;
        [self.mianView addSubview:self.reviewLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    
    [self.movieImg setFrame:CGRectMake(5, 5, viewW - 10, 190)];
    
    [self.userImg setFrame:CGRectMake(10, 180, 40, 40)];
    
    [self.nikeName setFrame:CGRectMake(70, 200, 100, 20)];
    
    [self.time setFrame:CGRectMake(viewW - 100, 200, 100, 20)];
    [self.time setTitleColor:[UIColor colorWithRed:110.0/255 green:110.0/255 blue:93.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.movieName setFrame:CGRectMake(5, 175, viewW - 10, 20)];
    
    [self.comment setFrame:CGRectMake(5, 0, viewW - 10, 60)];
    CGFloat titY = CGRectGetMaxY(self.comment.frame) - 10;
    
    [self.reviewLabel setFrame:CGRectMake(5, titY, 60, 20)];
    
    [self.mianView setFrame:CGRectMake(5, 100, viewW - 10, 120)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    [super setSelected:selected animated:animated];
    
}

- (void)setup: (ReviewModel *)model{
    
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.userImg.image = [UIImage imageNamed:@"avatar.png"];
    self.nikeName.text = model.user.nickname;
    [self.time setTitle:model.createdAt forState:UIControlStateNormal];
    self.reviewLabel.text = @"好评";
    self.comment.text = model.content;
    self.movieName.text = model.movie.title;
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end

//
//  RecMovieTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "RecMovieTableViewCell.h"
#import "RecModel.h"
#import "UIImageView+WebCache.h"

@implementation RecMovieTableViewCell

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

        //感谢
        self.appBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.appBtn];
        [self.appBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.appBtn setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];

        //筛选按钮
        self.screenBtn = [[UIButton alloc]init];
        [self.screenBtn setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.screenBtn];
        
        self.mianView = [[UIView alloc]init];
        [self.contentView addSubview:self.mianView];
        //电影名
        self.movieName = [[UILabel alloc]init];
        [self.contentView addSubview:self.movieName];
        self.movieName.textColor = [UIColor grayColor];
        self.movieName.textAlignment = NSTextAlignmentRight;
        self.movieName.layer.borderWidth = 1;
        [self.movieName.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorWithRed:57.0/255 green:37.0/255 blue:22.0/255 alpha:1.0])];

        //电影内容
        self.text = [[UILabel alloc]init];
        self.text.numberOfLines = 0;
        self.text.textColor = [UIColor whiteColor];
        [self.mianView addSubview:self.text];
        //电影标签
        self.title = [[UILabel alloc]init];
        self.title.layer.borderWidth = 1;
        self.title.backgroundColor = [UIColor colorWithRed:111.0/255 green:115.0/255 blue:114.0/255 alpha:1.0];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.layer.masksToBounds = YES;
        self.title.layer.cornerRadius = 3.0;
        [self.mianView addSubview:self.title];
    }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imgH = 20;
    CGFloat imgY = 240;
    
    [self.movieImg setFrame:CGRectMake(5, 5, viewW - 10, 190)];
    
    [self.userImg setFrame:CGRectMake(10, 180, 40, 40)];
    
    [self.nikeName setFrame:CGRectMake(70, 200, 100, 20)];
    
    [self.time setFrame:CGRectMake(viewW - 100, 200, 100, 20)];
    [self.time setTitleColor:[UIColor colorWithRed:110.0/255 green:110.0/255 blue:93.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.appBtn setFrame:CGRectMake(10, imgY, 150, imgH)];
    
    [self.screenBtn setFrame:CGRectMake(viewW - 160, imgY, 150, imgH)];
    
    [self.movieName setFrame:CGRectMake(5, 175, viewW - 10, 20)];
    
    [self.text setFrame:CGRectMake(5, 0, viewW - 10, 60)];
    CGFloat titY = CGRectGetMaxY(self.text.frame) - 10;
    
    [self.title setFrame:CGRectMake(5, titY, 60, 20)];
    
    [self.mianView setFrame:CGRectMake(5, 100, viewW - 10, 120)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    [super setSelected:selected animated:animated];
    
}

- (void)setup: (RecModel *)model{
    
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.userImg.image = [UIImage imageNamed:@"avatar.png"];
    self.nikeName.text = model.user.nickname;
    [self.time setTitle:model.createdAt forState:UIControlStateNormal];
    [self.appBtn setTitle:@"1000人 感谢" forState:UIControlStateNormal];
    self.title.text = @"视觉好";
    self.text.text = model.content;
    self.movieName.text = model.movie.title;
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end

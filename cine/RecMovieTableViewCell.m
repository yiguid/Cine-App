//
//  RecMovieTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "RecMovieTableViewCell.h"
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
        self.nikeName.font = NameFont;
        [self.contentView addSubview:self.nikeName];
        //时间
        self.time = [[UIButton alloc]init];
        [self.time setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];

        [self.contentView addSubview:self.time];
        

        //感谢
        self.appBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.appBtn];
        [self.appBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.appBtn setImage:[UIImage imageNamed:@"zan@2x.png"] forState:UIControlStateNormal];

        //筛选按钮
        self.screenBtn = [[UIButton alloc]init];
        [self.screenBtn setImage:[UIImage imageNamed:@"_..@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.screenBtn];
        
        
        UIView * commentview = [[UIView alloc]initWithFrame:CGRectMake(5,100,wScreen-10, 95)];
        commentview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.contentView addSubview:commentview];
        [self.contentView addSubview:self.movieName];
        [self.contentView addSubview:self.userImg];
        
        
        //电影内容
        self.text = [[UILabel alloc]init];
        self.text.numberOfLines = 0;
        self.text.textColor = [UIColor whiteColor];
        self.text.font = TextFont;
        [commentview addSubview:self.text];
        
        //电影名
        self.movieName = [[UILabel alloc]init];
        self.movieName.textAlignment = NSTextAlignmentRight;
        self.movieName.layer.borderWidth = 1;
        [self.movieName.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorWithRed:234/255.0 green:153/255.0 blue:0/255.0 alpha:1.0])];
        self.movieName.font = TextFont;
        [commentview addSubview:self.movieName];
        
       
        //自定义分割线
        self.carview = [[UIView alloc]init];
        self.carview.backgroundColor = [ UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        [self.contentView addSubview:self.carview];

        
        
        //电影推荐
        self.recommend = [[UILabel alloc]init];
        self.recommend.backgroundColor = [UIColor colorWithRed:241/255.0 green:86/255.0 blue:0 alpha:1.0];
        self.recommend.textColor = [UIColor whiteColor];
        self.recommend.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.recommend];
        [self.movieImg bringSubviewToFront:self.recommend];
    }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imgH = 20;
    CGFloat imgY = 240;
    
    [self.movieImg setFrame:CGRectMake(10, 5, viewW - 20, 190)];
    
    [self.userImg setFrame:CGRectMake(20, 180, 40, 40)];
    
    [self.nikeName setFrame:CGRectMake(70, 200, 200, 20)];
    
    [self.time setFrame:CGRectMake(viewW - 100, 200, 100, 20)];
    [self.time setTitleColor:[UIColor colorWithRed:110.0/255 green:110.0/255 blue:93.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.carview setFrame:CGRectMake(20,imgY, wScreen-40, 1)];
    
    [self.appBtn setFrame:CGRectMake(10, imgY+10, 100, imgH)];
    
    [self.screenBtn setFrame:CGRectMake(viewW - 130, imgY+10, 150, imgH)];
    
    [self.movieName setFrame:CGRectMake(10,70, viewW - 20, 20)];
    
    [self.text setFrame:CGRectMake(5, 0, viewW - 10, 60)];
    //CGFloat titY = CGRectGetMaxY(self.text.frame)-10;
    
    [self.recommend setFrame:CGRectMake(20,20, 80, 20)];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    [super setSelected:selected animated:animated];
    
}

- (void)setup: (RecModel *)model{
    
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.movie.cover] placeholderImage:nil];
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
    self.time.titleLabel.font  = [UIFont systemFontOfSize: 13];
    self.time.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    
    
    if (model.thankCount == nil) {
        [self.appBtn setTitle:[NSString stringWithFormat:@"0人 感谢"] forState:UIControlStateNormal];
    }
    
    [self.appBtn setTitle:[NSString stringWithFormat:@"%@人 感谢",model.thankCount] forState:UIControlStateNormal];
    self.appBtn.titleLabel.font = TextFont;
    self.appBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    self.recommend.text = @"推荐电影";
    self.text.text = model.content;
    
      for (NSDictionary * dic in model.tags) {
        NSString * key = dic[@"name"];
        
            self.title.text =key;
    }
    
    
    
    self.movieName.text = [NSString stringWithFormat:@"《%@》",model.movie.title];
    self.movieName.textColor = [UIColor colorWithRed:234/255.0 green:153/255.0 blue:0/255.0 alpha:1.0];
    self.movieName.font = TextFont;
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end

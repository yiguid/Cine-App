//
//  RecMovieTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "RecMovieTableViewCell.h"
#import "RecModel.h"

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
        [self.nikeName setTextColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0]];
        //时间
        self.time = [[UILabel alloc]init];
        [self.contentView addSubview:self.time];
        [self.time setTextColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0]];
        //感谢
        self.appBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.appBtn];
        [self.appBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //筛选按钮
        self.screenBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.screenBtn];
        
    }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = self.bounds.size.width;
    
    CGFloat imgH = 20;
    CGFloat imgY = 270;
    
    [self.movieImg setFrame:CGRectMake(5, 5, viewW - 10, 190)];
    
    [self.userImg setFrame:CGRectMake(10, 170, 60, 60)];
    
    [self.nikeName setFrame:CGRectMake(70, 200, 100, 20)];
    
    [self.time setFrame:CGRectMake(viewW - 100, 200, 80, 20)];
    
    [self.appBtn setFrame:CGRectMake(10, 270, 150, imgH)];
    
    [self.screenBtn setFrame:CGRectMake(viewW - 160, imgY, 150, imgH)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setup: (RecModel *)model{
    self.movieImg.image = [UIImage imageNamed:model.movieImg];
    self.userImg.image = [UIImage imageNamed:model.userImg];
    self.nikeName.text = model.nikeName;
    self.time.text = model.time;
    
    [self.appBtn setImage:[UIImage imageNamed:model.appImg] forState:UIControlStateNormal];
    [self.appBtn setTitle:model.appCount forState:UIControlStateNormal];
    
    [self.screenBtn setImage:[UIImage imageNamed:model.screenImg] forState:UIControlStateNormal];
}

@end

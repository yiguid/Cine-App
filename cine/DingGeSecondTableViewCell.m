//
//  DingGeSecondTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "DingGeSecondTableViewCell.h"
#import "DingGeSecondModel.h"


@implementation DingGeSecondTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
        self.time = [[UILabel alloc]init];
        self.time.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.time];
        
        [self.time setTextColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0]];
        //时间图片
        self.timeImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.timeImg];
        
        self.comment = [[UILabel alloc]init];
        self.comment.numberOfLines = 0;
        [self.contentView addSubview:self.comment];
        
        
        self.foortitle = [[UILabel alloc]init];
        [self.contentView addSubview:self.foortitle];
    }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = self.bounds.size.width;
    
    CGFloat imgH = 20;
    CGFloat imgY = 270;
    
    [self.movieImg setFrame:CGRectMake(5, 5, viewW - 10, 190)];
    
    [self.userImg setFrame:CGRectMake(10, 170, 60, 60)];
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0]};
    CGSize sizeN = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize sizeName = [self.nikeName.text boundingRectWithSize:sizeN options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [self.nikeName setFrame:CGRectMake(70, 200, sizeName.width, sizeName.height)];
    
    [self.time setFrame:CGRectMake(viewW - 70, 200, 60, 20)];
    [self.timeImg setFrame:CGRectMake(viewW - 90, 200, 20, 20)];
    
    CGSize sizeM = CGSizeMake(viewW - 15, MAXFLOAT);
    CGSize sizeComment = [self.comment.text boundingRectWithSize:sizeM options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [self.comment setFrame:CGRectMake(10, 250, sizeComment.width, sizeComment.height)];
    
    [self.foortitle setTextColor:[UIColor grayColor]];

    [self.foortitle setFrame:CGRectMake(10, sizeComment.height + 260, viewW, 20)];
    
    
    
}

- (void)setup: (DingGeSecondModel *)model{
    self.movieImg.image = [UIImage imageNamed:model.movieImg];
    self.userImg.image = [UIImage imageNamed:model.userImg];
    self.nikeName.text = model.nikeName;
    self.time.text = model.time;
    self.timeImg.image = [UIImage imageNamed:model.timeImg];
    self.comment.text = model.comment;
    self.foortitle.text = model.title;
}


@end
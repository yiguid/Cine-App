//
//  ActivityTableViewCell.m
//  cine
//
//  Created by Guyi on 15/12/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ActivityTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //电影图片
        self.movieImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.movieImg];
        //用户图片
        self.userImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.userImg];
        
        self.certifyimage = [[UIImageView alloc]init];
        [self.contentView addSubview:self.certifyimage];
        
        self.certifyname = [[UILabel alloc]init];
        [self.contentView addSubview:self.certifyname];
        
        
        self.tiaoshi = [[UILabel alloc]init];
        [self.contentView addSubview:self.tiaoshi];
        
        
        //用户名
        self.nikeName = [[UILabel alloc]init];
        [self.contentView addSubview:self.nikeName];
        
        //电影名
        self.movieName = [[UILabel alloc]init];
        [self.contentView addSubview:self.movieName];
        self.movieName.textAlignment = UIAlertActionStyleCancel;
        self.movieName.layer.borderWidth = 1;
        [self.movieName.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorWithRed:57.0/255 green:37.0/255 blue:22.0/255 alpha:1.0])];
        
        //评价内容
        self.comment = [[UILabel alloc]init];
        //self.comment.numberOfLines = 0;
        [self.contentView addSubview:self.comment];
        UIView * commentview = [[UIView alloc]initWithFrame:CGRectMake(80,100,wScreen/2+20, 20)];
        self.number = [[UILabel alloc]initWithFrame:CGRectMake(80, 100, wScreen/2+20, 20)];
        self.number.text = @"有5位匠人,52位达人参加";
        self.number.font = TextFont;
        self.number.textAlignment = UIAlertActionStyleCancel;
        commentview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.contentView addSubview:self.number];
        [commentview bringSubviewToFront:self.number];

        [self.contentView addSubview:commentview];
        [self.contentView addSubview:self.movieName];
        [self.contentView addSubview:self.userImg];
        [commentview bringSubviewToFront:self.movieName];
      
    }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    
    [self.movieImg setFrame:CGRectMake(0, 0, viewW, 190)];
    
    [self.userImg setFrame:CGRectMake(20, 240, 40, 40)];
    
    [self.tiaoshi setFrame:CGRectMake(20, 290, 200, 20)];
    
    
    
    CGSize nameSize = [self sizeWithText:self.model.user.nickname font:NameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    
    [self.nikeName setFrame:CGRectMake(80, 245,CGRectGetMaxX(self.nikeName.frame),30)];
    
    
    [self.certifyimage setFrame:CGRectMake(CGRectGetMaxX(self.nikeName.frame)+10, 255, 15, 15)];
    
    [self.certifyname setFrame:CGRectMake(CGRectGetMaxX(self.nikeName.frame)+30, 255, 100, 15)];
    
    
    [self.movieName setFrame:CGRectMake(viewW/4,80, viewW/2, 20)];
    
    [self.comment setFrame:CGRectMake(20, 200,nameSize.width,nameSize.height)];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    [super setSelected:selected animated:animated];
    
}

- (void)setup: (ActivityModel *)model{
    
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil];
    
    [self.userImg setImage:self.userImg.image];
    //头像圆形
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
    //头像边框
    self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImg.layer.borderWidth = 1.5;
    
    
    self.tiaoshi.text = @"(著名编剧、导演、影视投资人)";
    self.tiaoshi.font = TextFont;
    self.tiaoshi.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1.0];
    
    

    if([model.user.catalog isEqual:@"1"]){
    
        self.certifyimage.image = [UIImage imageNamed:@"yingjiang@2x.png"];
        self.certifyname.text = @"匠人";
        self.certifyname.textColor = [UIColor colorWithRed:255/255.0 green:194/255.0 blue:62/255.0 alpha:1.0];
    
    }else if ([model.user.catalog isEqual:@"2"]){
    
        
        self.certifyimage.image = [UIImage imageNamed:@"daren@2x.png"];
        self.certifyname.text = @"达人";
        self.certifyname.textColor = [UIColor colorWithRed:87/255.0 green:153/255.0 blue:248/255.0 alpha:1.0];
    
    }else{
        
    
        
    }
    
    
    
    
    
    self.nikeName.text = model.user.nickname;
    self.comment.text =model.professionals;
    self.comment.textColor = [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1.0];
    self.movieName.text = model.content;
    self.movieName.textColor = [UIColor whiteColor];
    self.number.textColor = [UIColor whiteColor];
    
 

}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end

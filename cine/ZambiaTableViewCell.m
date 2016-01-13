//
//  ZambiaTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ZambiaTableViewCell.h"
#import "ZambiaModel.h"
#import "UIImageView+WebCache.h"
@implementation ZambiaTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //   NSLog(@"%f init %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.userImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.userImg];
        //定义用户名
        self.alert = [[UILabel alloc] init];
        self.alert.font = [UIFont fontWithName:@"Helvetica" size:18];
        self.alert.tintColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
        [self.contentView addSubview:self.alert];
        //消息评论
        self.content = [[UILabel alloc] init];
        self.content.font = [UIFont fontWithName:@"Helvetica" size:14];
        self.content.tintColor = [UIColor grayColor];
        [self.contentView addSubview:self.content];
     }
    return self;
}

- (void)layoutSubviews {
    
    //   NSLog(@"%f layout %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    
    CGFloat viewW = self.bounds.size.width;
    [self.userImg setFrame:CGRectMake(10, 5, 70, 70)];
    
    [self.alert setFrame:CGRectMake(100, 5, 100, 20)];
    
    [self.content setFrame:CGRectMake(100, 35, viewW - 90, 20)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //   NSLog(@"%f select %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    // Configure the view for the selected state
    //   NSLog(@"%f:%f",self.bounds.origin.x, self.bounds.origin.y,nil);
    
}

- (void)setup: (ZambiaModel *)model {
    //  NSLog(@"%f setup %f",self.bounds.size.width, self.window.bounds.size.width,nil);
    
//    self.movieImg.image = [UIImage imageNamed:model.movieImg];
//    self.alert.text = model.alert;
    
    self.content.text = model.content;
    
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.userImg setImage:self.userImg.image];
        //头像圆形
        self.userImg.layer.masksToBounds = YES;
        self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
        //头像边框
        self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userImg.layer.borderWidth = 1.5;
    }];
    
    
    
}


@end

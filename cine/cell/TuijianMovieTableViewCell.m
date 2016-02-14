//
//  TuijianMovieTableViewCell.m
//  cine
//
//  Created by Guyi on 16/1/29.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "TuijianMovieTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation TuijianMovieTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //用户图片
        self.userImg = [[UIImageView alloc]init];
        
        [self.contentView addSubview:self.userImg];
        //用户名
        self.nickName = [[UILabel alloc]init];
        [self.contentView addSubview:self.nickName];
        
        self.userType = [[UIButton alloc]init];
        [self.contentView addSubview:self.userType];
        
        self.userDesc = [[UILabel alloc]init];
        [self.contentView addSubview:self.userDesc];
        
        
        //时间
        self.time = [[UIButton alloc]init];
        [self.time setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.time];
        
        //内容
        self.comment = [[UILabel alloc]init];
        self.comment.numberOfLines = 0;
        self.comment.textColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.0];
        [self.contentView addSubview:self.comment];
        
        //感谢
        self.appBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.appBtn];
        [self.appBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.appBtn setImage:[UIImage imageNamed:@"zan_n@2x.png"] forState:UIControlStateNormal];
        
        self.tag1 = [[UILabel alloc]initWithFrame:CGRectMake(70,64, 60, 20)];
        self.tag2 = [[UILabel alloc]initWithFrame:CGRectMake(70+70,64, 60, 20)];
        self.tag3 = [[UILabel alloc]initWithFrame:CGRectMake(70+140,64, 60, 20)];
        self.tag4 = [[UILabel alloc]initWithFrame:CGRectMake(70+210,64, 60, 20)];
        
        self.tag1.textAlignment = NSTextAlignmentCenter;
        self.tag1.layer.borderWidth = 1;
        self.tag1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.tag1.textColor = [UIColor lightGrayColor];
        self.tag1.font = TextFont;
//        [self.contentView addSubview:self.tag1];
        
        self.tag2.textAlignment = NSTextAlignmentCenter;
        self.tag2.layer.borderWidth = 1;
        self.tag2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.tag2.textColor = [UIColor lightGrayColor];
        self.tag2.font = TextFont;
//        [self.contentView addSubview:self.tag2];
        
        self.tag3.textAlignment = NSTextAlignmentCenter;
        self.tag3.layer.borderWidth = 1;
        self.tag3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.tag3.textColor = [UIColor lightGrayColor];
        self.tag3.font = TextFont;
//        [self.contentView addSubview:self.tag3];
        
        self.tag4.textAlignment = NSTextAlignmentCenter;
        self.tag4.layer.borderWidth = 1;
        self.tag4.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.tag4.textColor = [UIColor lightGrayColor];
        self.tag4.font = TextFont;
//        [self.contentView addSubview:self.tag4];
    }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    
    CGSize textSize = [self sizeWithText:self.comment.text font:TextFont maxSize:CGSizeMake(viewW - 90, MAXFLOAT)];
    [self.comment setFrame:CGRectMake(20+40+10,90, viewW - 90, textSize.height)]; //110
    self.comment.font = TextFont;
    
    CGFloat heightComment = CGRectGetMaxY(self.comment.frame);
    
    
    
    
    [self.nickName setFrame:CGRectMake(70,20, 80, 20)];
    
    [self.userType setFrame:CGRectMake(CGRectGetMaxX(self.nickName.frame), 20, 100, 20)];
    
    [self.userDesc setFrame:CGRectMake(70, 40, 200, 20)];
    
    
    [self.userImg setFrame:CGRectMake(20, 20, 40, 40)];
    
    //头像圆形
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
    //头像边框
    self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImg.layer.borderWidth = 1.5;
    
    
    [self.appBtn setFrame:CGRectMake(60, heightComment+20, 100, 20)];
    [self.time setFrame:CGRectMake(wScreen - 110, heightComment + 20, 100, 20)];
    [self.time setTitleColor:[UIColor colorWithRed:110.0/255 green:110.0/255 blue:93.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.time.titleLabel.font  = [UIFont systemFontOfSize: 12];
    self.time.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    self.cellHeight = heightComment + 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    [super setSelected:selected animated:animated];
    
}

- (void)setup: (RecModel *)model{
    
    //头像
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.userImg setImage:self.userImg.image];
    }];
    
    
    self.nickName.text = model.user.nickname;
    
    self.userDesc.text = model.user.promoteMessage;
    self.userDesc.font = NameFont;
    self.userType.titleLabel.text = model.user.catalog;
    self.userType.titleLabel.font = NameFont;
    
    if([model.user.catalog isEqual:@"1"]){
        
        [self.userType setImage:[UIImage imageNamed:@"yingjiang@2x.png"] forState:UIControlStateNormal];
        [self.userType setTitle:@"匠人" forState:UIControlStateNormal];
        
        self.userType.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:194/255.0 blue:62/255.0 alpha:1.0];
        [self.userType setTitleColor:[UIColor colorWithRed:255/255.0 green:194/255.0 blue:62/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.userDesc.textColor = [UIColor colorWithRed:255/255.0 green:194/255.0 blue:62/255.0 alpha:1.0];
        
    }else if ([model.user.catalog isEqual:@"2"]){
        [self.userType setImage:[UIImage imageNamed:@"daren@2x.png"] forState:UIControlStateNormal];
        [self.userType setTitle:@"达人" forState:UIControlStateNormal];
        self.userType.titleLabel.textColor = [UIColor colorWithRed:87/255.0 green:153/255.0 blue:248/255.0 alpha:1.0];
        [self.userType setTitleColor:[UIColor colorWithRed:87/255.0 green:153/255.0 blue:248/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.userDesc.textColor = [UIColor colorWithRed:87/255.0 green:153/255.0 blue:248/255.0 alpha:1.0];
        
    }else{
    }
    
    NSInteger j = 0;
    
    
    for (NSDictionary * dic in model.tags) {
        
        //根据value从大到小排序
        
        if (j<4) {
            switch (j) {
                case 0:
                    self.tag1.text = dic[@"name"];
                    [self.contentView addSubview:self.tag1];
                    break;
                case 1:
                    self.tag2.text = dic[@"name"];
                    [self.contentView addSubview:self.tag2];
                    break;
                case 2:
                    self.tag3.text = dic[@"name"];
                    [self.contentView addSubview:self.tag3];
                    break;
                case 3:
                    self.tag4.text = dic[@"name"];
                    [self.contentView addSubview:self.tag4];
                    break;
                default:
                    break;
            }
            
            j++;
        }
        
    }
    
    self.appBtn.titleLabel.font = NameFont;
    [self.appBtn setTitle:[NSString stringWithFormat:@" 感谢TA"] forState:UIControlStateNormal];
    
    [self.time setTitle:model.createdAt forState:UIControlStateNormal];
    
    
    self.comment.text = model.content;
    
    
    [self.time setTitle:model.createdAt forState:UIControlStateNormal];
    
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end

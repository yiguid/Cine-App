//
//  ShuoXiImgTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ShuoXiImgTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ShuoXiImgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.movieImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.movieImg];
    
    self.userImg = [[UIImageView alloc]init];
    
    
    self.nikeName = [[UILabel alloc]init];
    self.nikeName.font = Name2Font;
    
    
    self.certifyimage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.certifyimage];
    
    self.certifyname = [[UILabel alloc]init];
    self.certifyname.font = NameFont;
    [self.contentView addSubview:self.certifyname];
    
    self.tiaoshi = [[UILabel alloc]init];
    [self.contentView addSubview:self.tiaoshi];
    


    
    
    self.message = [[UILabel alloc]init];
    [self.contentView addSubview:self.message];
    [self.message setTextColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0]];
    [self.message setFont:TextFont];


//    [self.movieName setTextColor:[UIColor whiteColor]];
//    [self.movieName setFont:NameFont];
    
    self.foortitle = [[UILabel alloc]init];
    [self.foortitle setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.foortitle];
    [self.foortitle setFont:NameFont];
    
    
    //赞过按钮
    self.zambiaBtn = [[UIButton alloc]init];
    [self.zambiaBtn setImage:[UIImage imageNamed:@"zan@2x.png"] forState:UIControlStateNormal];
       [self.zambiaBtn setImage:[UIImage imageNamed:@"zan-2@2x.png"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.zambiaBtn];
    
    
    
    //回复按钮
    self.answerBtn = [[UIButton alloc]init];
    [self.answerBtn setImage:[UIImage imageNamed:@"评论@2x.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.answerBtn];
    //筛选按钮
    self.screenBtn = [[UIButton alloc]init];
    [self.screenBtn setImage:[UIImage imageNamed:@"_..@2x.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.screenBtn];
    
    
    //自定义分割线
    self.carview = [[UIView alloc]init];
    self.carview.backgroundColor = [ UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    [self.contentView addSubview:self.carview];
    

    self.time = [[UILabel alloc]init];
    [self.contentView addSubview:self.time];
    
    [self.contentView addSubview:self.userImg];
    [self.contentView addSubview:self.nikeName];

    
    return self;
    
}

- (void)layoutSubviews{
    CGFloat viewW = self.bounds.size.width;
    
    CGFloat imgH = 160;
    CGFloat imgW = viewW;
    
    [self.movieImg setFrame:CGRectMake(10,80, imgW-20, imgH+30)];
    [self.message setFrame:CGRectMake(20,40, imgW, 20)];
    [self.foortitle setFrame:CGRectMake(5, 400, imgW, 30)];
    [self.userImg setFrame:CGRectMake(20, 280, 40, 40)];
    [self.tiaoshi setFrame:CGRectMake(20, 320, 200, 20)];
    [self.certifyimage setFrame:CGRectMake(130, 295, 15, 15)];
    [self.certifyname setFrame:CGRectMake(150, 295, 100, 15)];
    
    
    [self.nikeName setFrame:CGRectMake(70, 280, 200, 40)];
    
    [self.carview setFrame:CGRectMake(10, 350, wScreen-20, 1)];
    
    
    CGFloat imw = (viewW - 30)/4;
    
    self.time.frame = CGRectMake(imw*3+50, 370, 100, 20);
    self.time.textColor = [UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0];
    self.time.font  = [UIFont systemFontOfSize: 13];
    
    [self.zambiaBtn setFrame:CGRectMake(20, 370, 40, 20)];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:177/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateSelected];
    self.zambiaBtn.titleLabel.font  = [UIFont systemFontOfSize: 13];
    self.zambiaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    
    [self.answerBtn setFrame:CGRectMake(imw+30, 370, 40, 20)];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.answerBtn.titleLabel.font  = [UIFont systemFontOfSize: 13];
    self.answerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    
    
    [self.screenBtn setFrame:CGRectMake(imw*2+40, 370, 40, 20)];
    [self.screenBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    
    
    
    
//    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0]};
//    CGSize sizeN = CGSizeMake(MAXFLOAT, MAXFLOAT);
//    CGSize sizeName = [self.nikeName.text boundingRectWithSize:sizeN options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
  
    
   
   

}

- (void)setup:(ShuoXiModel *)model{
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [userDef stringForKey:@"userID"];
    
    self.zambiaBtn.selected = NO;
    
    self.zambiaBtn.selected = NO;
    for (NSDictionary * dict in model.voteBy) {
        if ([dict[@"id"] isEqual:userId]) {
            self.zambiaBtn.selected = YES;
            break;
        }
    }

    
    
    
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    
    self.movieName.text = model.movie.title;
    
    self.message.text = model.content;
    
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
    
    
    self.tiaoshi.text = @"(著名编剧、导演、影视投资人)";
    self.tiaoshi.font = TextFont;
    self.tiaoshi.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1.0];
    

        
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil];
    
//    [self.userImg setImage:[UIImage imageNamed:@"avatar.png"]];
    //头像圆形
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
    //头像边框
    self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImg.layer.borderWidth = 1.5;

    self.nikeName.text = model.user.nickname;
    NSInteger comments = model.comments.count;
    NSString * com = [NSString stringWithFormat:@"%ld",comments];
    model.answerCount = com;
    
    [self.answerBtn setTitle:com forState:UIControlStateNormal];
    
    self.time.text = model.createdAt;
  

}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}




@end

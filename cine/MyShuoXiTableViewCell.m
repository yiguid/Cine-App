
//  MianMLStatusCell.m
//  cine
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.


#import "MyShuoXiTableViewCell.h"
#import "ShuoXiModel.h"
#import "ShuoXiModelFrame.h"
#import "UIImageView+WebCache.h"
@implementation MyShuoXiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //自定义cell,一定要把子控件添加到contentView中
        //只添加所有子控件(不设置数据和frame)
        //头像
        UIImageView *iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        //昵称
        UILabel *nameView = [[UILabel alloc]init];
        nameView.font = NameFont;
        [self.contentView addSubview:nameView];
        self.nameView = nameView;
        self.daRen = [[UIButton alloc]init];
        [self.daRen setImage:[UIImage imageNamed:@"crown@2x.png"] forState:UIControlStateNormal];

        [self.contentView addSubview:self.daRen];
        //正文
        UILabel *textView = [[UILabel alloc]init];
        textView.font = TextFont;
        [self.contentView addSubview:textView];
        self.textView.textColor = [UIColor whiteColor];
        self.textView = textView;
        //配图
        UIImageView *pictureView = [[UIImageView alloc]init];
        [self.contentView addSubview:pictureView];
        self.pictureView = pictureView;
        //标示
        UILabel *mark = [[UILabel alloc]init];
        mark.font = MarkFont;
        [self.contentView addSubview:mark];
        self.mark = mark;
        
        self.movieName = [[UILabel alloc]init];
        [self.contentView addSubview:self.movieName];
        
        self.date = [[UILabel alloc]init];
        [self.contentView addSubview:self.date];
        
        
        
        self.time = [[UILabel alloc]init];
        [self.contentView addSubview:self.time];
        
        //赞过按钮
        self.zambiaBtn = [[UIButton alloc]init];
        [self.zambiaBtn setImage:[UIImage imageNamed:@"喜欢@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.zambiaBtn];
        
        
        
        //回复按钮
        self.answerBtn = [[UIButton alloc]init];
        [self.answerBtn setImage:[UIImage imageNamed:@"评论@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.answerBtn];
        //筛选按钮
        self.screenBtn = [[UIButton alloc]init];
        [self.screenBtn setImage:[UIImage imageNamed:@"_..@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.screenBtn];
        
        
       
    }
    return self;
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setup: (ShuoXiModel *)model{
    
    self.model = model;
    
    CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;
    //子控件之间的间距
 //   CGFloat padding = 10;
    //配图
    CGFloat pictureX = 5;
    CGFloat pictureY = 5;
    CGFloat pictureW = viewW - 10;
    CGFloat pictureH = 190;
    self.pictureView.frame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
    //正文
    CGFloat textX = 10;
    CGFloat textY = CGRectGetMaxY(self.pictureView.frame);
    self.textView.frame = CGRectMake(10 ,textY, viewW - 10, 30);
    
    //头像
 //   CGFloat iconX = 20;
    CGFloat iconY = CGRectGetMaxY( self.textView.frame);
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    //成员是readonly属性,也就相当于没有setter方法,不能用.语法方法,只能通过_方式来访问
    self.iconView.frame= CGRectMake(textX, iconY, iconW, iconH);
    
    //昵称
//    CGSize nameSize = [self sizeWithText:model.user.nickname font:NameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    CGFloat nameW = nameSize.width;
    self.nameView.frame = CGRectMake(textX+50, iconY+20, 80, 20);
    
    //会员图标
    CGFloat vipX = CGRectGetMaxX(self.nameView.frame);
    CGFloat vipY = iconY;
    CGFloat vipW = 100;
    CGFloat vipH = 30;
    self.daRen.frame = CGRectMake(vipX, vipY, vipW, vipH);
    
    CGFloat markY = CGRectGetMaxY(self.iconView.frame);
    
    self.mark.frame = CGRectMake(10, markY, viewW - 20, 30);
    self.time.frame = CGRectMake(viewW-80, 270, 100, 20);
    self.time.textColor = [UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0];
    [self.zambiaBtn setFrame:CGRectMake(viewW-400, 270, 100, 20)];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.answerBtn setFrame:CGRectMake(viewW-300, 270, 100, 20)];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.screenBtn setFrame:CGRectMake(viewW-200, 270, 100, 20)];
    [self.screenBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];

    
    
//    UIView * commentview = [[UIView alloc]initWithFrame:CGRectMake(5,130,viewW-10, 65)];
//    commentview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    [self.contentView addSubview:commentview];
    
    
    self.movieName.frame = CGRectMake(10, 140,viewW-20, 20);
    self.movieName.textColor = [UIColor whiteColor];

    self.date.frame = CGRectMake(10, 160, viewW-20, 30);
    self.date.textColor = [UIColor whiteColor];
    
   //头像
    self.iconView.image = [UIImage imageNamed:model.icon];
    //昵称
    self.nameView.text =model.user.nickname;
    //正文
    self.textView.text = model.text;
    //配图
    self.pictureView.image = [UIImage imageNamed:model.picture];
    self.mark.text = model.mark;
    [self.daRen setTitle:model.daRenTitle forState:UIControlStateNormal];
    [self.daRen setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    
    //self.iconView.image = [UIImage imageNamed:model.icon];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.iconView.image = [UIImage imageNamed:@"avatar.png"];
        
//    [self.zambiaBtn setTitle:@"120" forState:UIControlStateNormal];
    NSInteger comments = model.comments.count;
    NSString * com = [NSString stringWithFormat:@"%ld",comments];
    model.answerCount = com;

    [self.answerBtn setTitle:com forState:UIControlStateNormal];
 
    self.time.text = model.createdAt;
    
    self.movieName.text = model.movie.title;
    self.movieName.textColor = [UIColor whiteColor];
    self.date.text = model.movie.initialReleaseDate;
 }




@end

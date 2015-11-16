//
//  MianMLStatusCell.m
//  cine
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MianMLStatusCell.h"
#import "MLStatus.h"
#import "MianStatusFrame.h"

@implementation MianMLStatusCell

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
        //只添所有加子控件(不设置数据和frame)
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
    }
    return self;
}

//- (void)layoutSubviews{
//    CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;
//    //子控件之间的间距
//    CGFloat padding = 10;
//    //配图
//    CGFloat pictureX = 5;
//    CGFloat pictureY = 5;
//    CGFloat pictureW = viewW - 10;
//    CGFloat pictureH = 190;
//    self.pictureView.frame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
//    //正文
//    CGFloat textX = 10;
//    CGFloat textY = CGRectGetMaxY(self.pictureView.frame) + 10;
//    CGSize textSize = [self sizeWithText:self.status.text font:MLTextFont maxSize:CGSizeMake(viewW - 10, MAXFLOAT)];
//    self.textView.frame = CGRectMake(textX ,textY, viewW - 10, 30);
//    
//    //头像
//    CGFloat iconX = 20;
//    CGFloat iconY = CGRectGetMaxY( self.textView.frame);
//    CGFloat iconW = 40;
//    CGFloat iconH = 40;
//    //成员是readonly属性,也就相当于没有setter方法,不能用.语法方法,只能通过_方式来访问
//    self.iconView.frame= CGRectMake(textX, iconY, iconW, iconH);
//    
//    //昵称
//    CGSize nameSize = [self sizeWithText:self.status.name font:MLNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    CGFloat nameW = nameSize.width;
//    self.nameView.frame = CGRectMake(60, iconY, nameW, 30);
//    
//    //会员图标
//    CGFloat vipX = CGRectGetMaxX(self.nameView.frame) + padding;
//    CGFloat vipY = iconY;
//    CGFloat vipW = 100;
//    CGFloat vipH = 30;
//    self.daRen.frame = CGRectMake(vipX, vipY, vipW, vipH);
//    
//    CGFloat markY = CGRectGetMaxY(self.iconView.frame);
//    
//    self.mark.frame = CGRectMake(10, markY, viewW - 20, 30);
//
//}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setup: (MLStatus *)status{
    
    self.status = status;
    
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
    self.textView.frame = CGRectMake(textX ,textY, viewW - 10, 30);
    
    //头像
 //   CGFloat iconX = 20;
    CGFloat iconY = CGRectGetMaxY( self.textView.frame);
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    //成员是readonly属性,也就相当于没有setter方法,不能用.语法方法,只能通过_方式来访问
    self.iconView.frame= CGRectMake(textX, iconY, iconW, iconH);
    
    //昵称
    CGSize nameSize = [self sizeWithText:self.status.name font:NameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat nameW = nameSize.width;
    self.nameView.frame = CGRectMake(60, iconY, nameW, 30);
    
    //会员图标
    CGFloat vipX = CGRectGetMaxX(self.nameView.frame);
    CGFloat vipY = iconY;
    CGFloat vipW = 100;
    CGFloat vipH = 30;
    self.daRen.frame = CGRectMake(vipX, vipY, vipW, vipH);
    
    CGFloat markY = CGRectGetMaxY(self.iconView.frame);
    
    self.mark.frame = CGRectMake(10, markY, viewW - 20, 30);

   // MLStatus *status = self.status;
    //头像
    self.iconView.image = [UIImage imageNamed:status.icon];
    //昵称
    self.nameView.text = status.name;
    //正文
    self.textView.text = status.text;
    //配图
    self.pictureView.image = [UIImage imageNamed:status.picture];
    self.mark.text = status.mark;
    [self.daRen setTitle:status.daRenTitle forState:UIControlStateNormal];
    [self.daRen setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];

 }

@end


//
//  MianStatusFrame.m
//  cine
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

//#import "MianStatusFrame.h"
//#import "MLStatus.h"
////昵称的字体
//#define MLNameFont [UIFont systemFontOfSize:14]
////正文的字体
//#define MLTextFont [UIFont systemFontOfSize:15]
//
//@implementation MianStatusFrame
//
////重写set方法
//-(void)setStatus:(MLStatus *)status{
//    _status = status;
//    CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;
//    //子控件之间的间距
//    CGFloat padding = 10;
//       //配图
//    CGFloat pictureX = 5;
//    CGFloat pictureY = 5;
//    CGFloat pictureW = viewW - 10;
//    CGFloat pictureH = 160;
//    _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
//    //正文
//    CGFloat textX = 10;
//    CGFloat textY = CGRectGetMaxY(_pictureF) + 10;
//    CGSize textSize = [self sizeWithText:self.status.text font:MLTextFont maxSize:CGSizeMake(viewW - 10, MAXFLOAT)];
//    _textF = CGRectMake(textX ,textY, viewW - 10, textSize.height);
//
//    //头像
//    CGFloat iconX = 20;
//    CGFloat iconY = CGRectGetMaxY(_textF) + 10;
//    CGFloat iconW = 30;
//    CGFloat iconH = 30;
//    //成员是readonly属性,也就相当于没有setter方法,不能用.语法方法,只能通过_方式来访问
//    _iconF= CGRectMake(iconX, iconY, iconW, iconH);
//   
//    //昵称
//    CGSize nameSize = [self sizeWithText:self.status.name font:MLNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    _nameF = CGRectMake(70, iconY, nameSize.width, nameSize.height);
//    
//    //会员图标
//    CGFloat vipX = CGRectGetMaxX(_nameF) + padding;
//    CGFloat vipY = iconY;
//    CGFloat vipW = 60;
//    CGFloat vipH = 30;
//    _vipF = CGRectMake(vipX, vipY, vipW, vipH);
//    
//    CGFloat markY = CGRectGetMaxY(_nameF) + padding;
//    
//    _markF = CGRectMake(10, markY, viewW - 20, 30);
//    
//    _cellHeight = CGRectGetMaxY(_markF) + padding;
//    
//    
//    
//}
//-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
//    NSDictionary *attrs = @{NSFontAttributeName : font};
//    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//}
//
//
//@end

//
//  MLStatusFrame.m
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MLStatusFrame.h"
#import "MLStatus.h"
//昵称的字体
#define MLNameFont [UIFont systemFontOfSize:14]
//正文的字体
#define MLTextFont [UIFont systemFontOfSize:15]
@implementation MLStatusFrame
//重写set方法
-(void)setStatus:(MLStatus *)status{
    _status = status;
    //子控件之间的间距
    CGFloat padding = 10;
    //头像
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = 30;
    CGFloat iconH = 30;
    //成员是readonly属性,也就相当于没有setter方法,不能用.语法方法,只能通过_方式来访问
    _iconF= CGRectMake(iconX, iconY, iconW, iconH);
    //昵称
    CGSize nameSize = [self sizeWithText:self.status.name font:MLNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat nameX = CGRectGetMaxX(_iconF) +padding;
    CGFloat nameY = iconY + (iconH - nameSize.height) * 0.5;
    _nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    //会员图标
    CGFloat vipX = CGRectGetMaxX(_nameF) + padding;
    CGFloat vipY = nameY;
    CGFloat vipW = 14;
    CGFloat vipH = 14;
    _vipF = CGRectMake(vipX, vipY, vipW, vipH);
    //正文
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(_iconF) + padding;
    CGSize textSize = [self sizeWithText:self.status.text font:MLTextFont maxSize:CGSizeMake(300, MAXFLOAT)];
    _textF = CGRectMake(textX ,textY, textSize.width, textSize.height);
    //配图
    if (self.status.picture) {
        CGFloat pictureX = textX;
        CGFloat pictureY = CGRectGetMaxY(_textF) + padding;
        CGFloat pictureW = 100;
        CGFloat pictureH = 100;
        _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
        _cellHeight = CGRectGetMaxY(_pictureF) + padding;
    }else{
        _cellHeight = CGRectGetMaxY(_textF) + padding;
    }
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end

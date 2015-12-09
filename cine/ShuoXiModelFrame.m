//
//  ShuoXiModelFrame.m
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ShuoXiModelFrame.h"
#import "ShuoXiModel.h"
@implementation ShuoXiModelFrame
//重写set方法
-(void)setModel:(ShuoXiModel *)model{
    _model = model;
    CGFloat viewW = wScreen;
  
    //子控件之间的间距
    CGFloat padding = 10;
    //头像
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = 30;
    CGFloat iconH = 30;
    //成员是readonly属性,也就相当于没有setter方法,不能用.语法方法,只能通过_方式来访问
    _iconF= CGRectMake(iconX, iconY, iconW, iconH);
     //正文
    CGFloat textX = 10;
    CGFloat textY = 5;
    CGSize textSize = [self sizeWithText:self.model.text font:TextFont maxSize:CGSizeMake(viewW - 20, MAXFLOAT)];
    _textF = CGRectMake(textX ,textY, textSize.width, textSize.height);
    //配图
    CGFloat pictureImgY = textSize.height + 10;

    if (self.model.picture) {
        CGFloat pictureX = 10;
        CGFloat pictureY = pictureImgY;
        CGFloat pictureW = viewW - 20;
        CGFloat pictureH = 160;
        _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
        _cellHeight = CGRectGetMaxY(_pictureF) + padding;
    }
    else{
        _cellHeight = CGRectGetMaxY(_textF) + padding;
    }
    CGFloat iconImgY = _cellHeight;

     //昵称
    CGSize nameSize = [self sizeWithText:self.model.name font:NameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat nameY = iconY + (iconH - nameSize.height) * 0.5;
    _nameF = CGRectMake(80, iconImgY + 10, nameSize.width, nameSize.height);

    _iconF = CGRectMake(10, iconImgY, 40, 40);
    
    //会员图标
    CGFloat vipX = CGRectGetMaxX(_nameF) + padding;
    CGFloat vipY = nameY;
    CGFloat vipW = 60;
    CGFloat vipH = 30;
    _vipF = CGRectMake(vipX, vipY, vipW, vipH);

    CGFloat markY = iconImgY + nameSize.height + 20;
    
    _markF = CGRectMake(10, markY, viewW - 20, 30);
    
    CGFloat imgW = (viewW - 35) / 4;
    CGFloat imgH = 20;
    CGFloat imgY = markY + 40;
    
    _zambiaF = CGRectMake(10, imgY, imgW, imgH);
    _answerF = CGRectMake(15 + imgW, imgY, imgW, imgH);
    _screenF = CGRectMake(20 + imgW * 2, imgY, imgW, imgH);
    _timeF = CGRectMake(25 + imgW * 3, imgY, imgW, imgH);
    
    _cellHeight = CGRectGetMaxY(_timeF) + padding;

}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end

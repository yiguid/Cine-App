//
//  CommentModelFrame.m
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CommentModelFrame.h"
#import "CommentModel.h"

@implementation CommentModelFrame

-(void)setModel:(CommentModel *)model{
    
    _model = model;
    
    CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;
    //子控件之间的间距
    CGFloat padding = 10;
    //头像
    CGFloat iconX = 10;
    CGFloat iconY = padding;
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    //成员是readonly属性,也就相当于没有setter方法,不能用.语法方法,只能通过_方式来访问
    _iconF= CGRectMake(iconX, iconY, iconW, iconH);
    
   
    
    //昵称
    CGSize nameSize = [self sizeWithText:self.model.nickName font:NameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
     _nameF = CGRectMake(60, iconY, nameSize.width + 30, nameSize.height);
    
    _zambiaF = CGRectMake(viewW - 80, iconY, 70, 60);
    _timeF = CGRectMake(60, nameSize.height + iconY, 80, 20);


    //评论
    CGFloat textX = 10;
    CGSize textSize = [self sizeWithText:self.model.comment font:TextFont maxSize:CGSizeMake(viewW - 20, MAXFLOAT)];
    _commentF = CGRectMake(60 ,CGRectGetMaxY(_timeF), textSize.width, textSize.height + 40);
    
    _cellHeight = CGRectGetMaxY(_commentF)+ padding;

}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end

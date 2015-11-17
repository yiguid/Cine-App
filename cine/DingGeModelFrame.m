//
//  DingGeModelFrame.m
//  cine
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "DingGeModelFrame.h"
#import "DingGeModel.h"

@implementation DingGeModelFrame

-(void)setModel:(DingGeModel *)model{
    
    _model = model;
    //子控件之间的间距
    CGFloat padding = 10;

    CGFloat viewW = wScreen;
    
    _pictureF = CGRectMake(5, 5, viewW - 10, 190);
    
    _iconF = CGRectMake(10, 180, 40, 40);
    
    _nameF = CGRectMake(60, 200, 100, 20);
    
    //正文
    CGFloat textX = 10;
    CGSize textSize = [self sizeWithText:self.model.message font:TextFont maxSize:CGSizeMake(viewW - 20, MAXFLOAT)];
    _textF = CGRectMake(textX ,CGRectGetMaxY(_iconF), viewW - 20, textSize.height + 20);
    
    
    CGFloat imgW = (viewW - 35) / 4;
    CGFloat imgH = 20;
    CGFloat imgY = CGRectGetMaxY(_textF ) + padding;

    _timeF = CGRectMake(viewW - 120, 200, 120, 20);
    
    _movieNameF = CGRectMake(5, CGRectGetMaxY(_pictureF) - 40, viewW - 10, 40);

    _seenF = CGRectMake(10, imgY, imgW, imgH);
    _zambiaF = CGRectMake(15 + imgW, imgY, imgW, imgH);
    _answerF = CGRectMake(20 + imgW * 2, imgY, imgW, imgH);
     _screenF = CGRectMake(25 + imgW * 3, imgY, imgW, imgH);

    _cellHeight = CGRectGetMaxY(_seenF) + padding;

    
    
}


-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end

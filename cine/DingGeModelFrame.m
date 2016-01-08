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
    
    _iconF = CGRectMake(20, 180, 40, 40);
    
    _nameF = CGRectMake(65, 200, 200, 20);
    
    //正文
    CGFloat textX = 20;
    CGSize textSize = [self sizeWithText:self.model.message font:TextFont maxSize:CGSizeMake(viewW - 20, MAXFLOAT)];
    _textF = CGRectMake(textX ,CGRectGetMaxY(_iconF), viewW - 20, textSize.height + 20);
    
    
    CGFloat imgW = (viewW - 35) / 4;
    CGFloat imgH = 20;
    CGFloat imgY = CGRectGetMaxY(_textF ) + padding;

    _timeF = CGRectMake(viewW - 100, 200, 100,15);
    
    _movieNameF = CGRectMake(65,2, viewW - 20, 25);

    _seenF = CGRectMake(5, imgY, imgW, imgH);
    _zambiaF = CGRectMake(20 + imgW, imgY, imgW-10, imgH);
    _answerF = CGRectMake(25 + imgW * 2, imgY, imgW-10, imgH);
     _screenF = CGRectMake(30 + imgW * 3, imgY, imgW-10, imgH);
    

    _cellHeight = CGRectGetMaxY(_seenF) + padding+20;

    
    
}


-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end

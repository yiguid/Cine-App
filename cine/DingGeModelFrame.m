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

//-(void)setModel:(DingGeModel *)model{
//    
//    _model = model;
//    //子控件之间的间距
//    CGFloat padding = 10;
//
//    CGFloat viewW = wScreen;
//    _imageHeight = 260;
//    
////    CGFloat imgHeight = model
//    _pictureF = CGRectMake(5, 5, viewW - 10, _imageHeight); //190
//    
//    _iconF = CGRectMake(20, _imageHeight-10, 40, 40); //180
//    
//    _nameF = CGRectMake(65, _imageHeight+10, 200, 20); //200
//    
//    //正文
//    CGFloat textX = 20;
//    CGSize textSize = [self sizeWithText:self.model.message font:TextFont maxSize:CGSizeMake(viewW - 20, MAXFLOAT)];
//    _textF = CGRectMake(textX ,CGRectGetMaxY(_iconF)+10, viewW - 20, textSize.height + 20);
//    
//    _carviewF = CGRectMake(20, CGRectGetMaxY(_textF)+10,wScreen-40, 1);
//    
//    CGFloat imgW = (viewW - 35) / 4;
//    CGFloat imgH = 20;
//    CGFloat imgY = CGRectGetMaxY(_textF ) + padding+20;
//
//    _timeF = CGRectMake(viewW - 100, _imageHeight + 10, 100,15);
//    
//    _movieNameF = CGRectMake(15,2, viewW - 30, 20);
//
//    _seenF = CGRectMake(5, imgY, imgW, imgH);
//    _zambiaF = CGRectMake(20 + imgW, imgY, imgW-10, imgH);
//    _answerF = CGRectMake(25 + imgW * 2, imgY, imgW-10, imgH);
//     _screenF = CGRectMake(30 + imgW * 3, imgY, imgW-10, imgH);
//    
//
//    _cellHeight = CGRectGetMaxY(_seenF) + padding+20;
//    
//}



-(CGFloat)getHeight: (DingGeModel *)model{
    _model = model;
    //子控件之间的间距
    CGFloat padding = 10;
    
    CGFloat viewW = wScreen;
    
    //    CGFloat imgHeight = model
    _pictureF = CGRectMake(5, 5, viewW - 10, _imageHeight); //190
    
    _iconF = CGRectMake(20, _imageHeight-10, 40, 40); //180
    
    _nameF = CGRectMake(65, _imageHeight+10, 200, 20); //200
    
    
   
    
    //正文
    CGFloat textX = 20;
    CGSize textSize = [self sizeWithText:self.model.message font:TextFont maxSize:CGSizeMake(viewW - 20, MAXFLOAT)];
    
    
    _textF = CGRectMake(textX ,_imageHeight+40,wScreen-40, textSize.height + 20);
    
    _carviewF = CGRectMake(20,CGRectGetMaxY(_textF)+10,wScreen-40, 1);
    
    CGFloat imgW = (viewW - 35) / 4;
    CGFloat imgH = 20;
    CGFloat imgY = CGRectGetMaxY(_textF ) + padding+20;
    
    _timeF = CGRectMake(viewW - 105, _imageHeight + 15, 100,15);
    
    _movieNameF = CGRectMake(15,2, viewW - 30, 20);
    
    _seenF = CGRectMake(5, imgY, imgW, imgH);
    _zambiaF = CGRectMake(20 + imgW, imgY, imgW-10, imgH);
    _answerF = CGRectMake(25 + imgW * 2, imgY, imgW-10, imgH);
    _screenF = CGRectMake(30 + imgW * 3, imgY, imgW-10, imgH);
    
    
    _cellHeight = CGRectGetMaxY(_seenF) + padding+20;
    return _cellHeight;
}


-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end

//
//  MianDingGeModelFrame.m
//  cine
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

//#import "MianDingGeModelFrame.h"
//#import "DingGeModel.h"
//
////昵称的字体
//#define MLNameFont [UIFont systemFontOfSize:14]
////正文的字体
//#define MLTextFont [UIFont systemFontOfSize:15]
//
//
//@implementation MianDingGeModelFrame
//
//- (void)setModel:(DingGeModel *)model{
//   
//    _model = model;
//    //子控件之间的间距
//    CGFloat padding = 10;
//    
//    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
//    
//    _pictureF = CGRectMake(5, 5, viewW - 10, 190);
//    
//    _iconF = CGRectMake(10, 170, 60, 60);
//    
//    _nameF = CGRectMake(70, 200, 100, 20);
//    
//    _timeF = CGRectMake(viewW - 120, 200, 120, 20);
//    
//    _movieNameF = CGRectMake(5, CGRectGetMaxY(_pictureF) - 40, viewW - 10, 40);
//    //正文
//    CGFloat textX = 10;
//    CGSize textSize = [self sizeWithText:self.model.message font:MLTextFont maxSize:CGSizeMake(viewW - 20, MAXFLOAT)];
//    _textF = CGRectMake(textX ,CGRectGetMaxY(_iconF), viewW - 20, textSize.height + 20);
//    
//    _cellHeight = CGRectGetMaxY(_textF) + padding;
//}
//
//-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
//    NSDictionary *attrs = @{NSFontAttributeName : font};
//    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//}

//@end

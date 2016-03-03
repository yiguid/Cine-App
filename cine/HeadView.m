//
//  headView.m
//  cine
//
//  Created by Mac on 15/11/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "HeadView.h"
#import "headViewModel.h"
#import "UIImageView+WebCache.h"
@interface HeadView()



@end

@implementation HeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    CGRect frameRect = CGRectMake(0, 0, wScreen, 240);
    self = [self initWithFrame:frameRect];
    if (self)
    {
        NSLog(@"Init called");
    }
    return self;
}
//- (void)setModel:(headViewModel *)model{
//    self.model = model;
//    self.backPicture.image = [UIImage imageNamed:model.backPicture];
//    self.userImg.image = [UIImage imageNamed:model.userImg];
//    self.name.text = model.name;
//    self.mark.text = model.mark;
//}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSLog(@"initWithFrame------%@",self.model);
        
        
//        self.backPicture.contentMode =  UIViewContentModeCenter;
//        self.backPicture.clipsToBounds  = YES;
        self.backPicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wScreen, 160)];
        [self addSubview:self.backPicture];
    
        self.userImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 140, 40, 40)];
        [self addSubview:self.userImg];
        
        
        
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(60, 130,100, 30)];
        [self.name setTextColor:[UIColor whiteColor]];
        self.name.font = NameFont;
        self.mark = [[UILabel alloc]initWithFrame:CGRectMake(60, 160, 300, 25)];
        self.mark.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        self.mark.font = TextFont;
        [self addSubview:self.name];
        [self addSubview:self.mark];
//      self.vip = [[UIButton alloc]initWithFrame:CGRectMake(130, 130, 80, 30)];
        
        
        self.certifyimage = [[UIImageView alloc]initWithFrame:CGRectMake(130, 135,15,15)];
        [self addSubview:self.certifyimage];
        
        
        self.certifyname = [[UILabel alloc]initWithFrame:CGRectMake(150, 130,100,30)];
        self.certifyname.font = NameFont;
        [self addSubview:self.certifyname];
        
        
        self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(wScreen - 40, 155,40,40)];
        [self.addBtn setImage:[UIImage imageNamed:@"follow-mark.png"] forState:UIControlStateNormal];
        [self addSubview:self.addBtn];
    }
    return self;
}

//- (void)layoutSubviews{
//    
// //   [self setup:self.model];
//    self.backPicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wScreen, 160)];
//    
//    self.userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 40, 40)];
//    
//    self.name = [[UILabel alloc]initWithFrame:CGRectMake(80, 140, 80, 20)];
//    self.mark = [[UILabel alloc]initWithFrame:CGRectMake(80, 170, 200, 20)];
//    
//    self.vip = [[UIButton alloc]initWithFrame:CGRectMake(200, 140, 80, 20)];
//   
//    self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(wScreen - 30, 170, 20, 20)];
//    
////NSLog(@"layoutSubviews--------%@",self.backPicture.frame);
//
//}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setup :(headViewModel *)model{
    self.model = model;
    
    
    
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:nil];
    
    [self.userImg setImage:self.userImg.image];
    
    self.backPicture.contentMode =  UIViewContentModeScaleAspectFill;
    self.backPicture.clipsToBounds  = YES;
    [self.backPicture sd_setImageWithURL:[NSURL URLWithString:model.backPicture] placeholderImage:[UIImage imageNamed:@"myBackImg@2x.png"]];
    
    [self.backPicture setImage:self.backPicture.image];
    
    
    
    //头像圆形
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
    //头像边框
    self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImg.layer.borderWidth = 1.5;
    
    self.name.text = model.name;
    self.mark.text = model.mark;
    [self.addBtn setImage:[UIImage imageNamed:model.addBtnImg] forState:UIControlStateNormal];
    


    
    
    if([model.catalog isEqual:@"1"]){
        
        self.certifyimage.image = [UIImage imageNamed:@"yingjiang@2x.png"];
        self.certifyname.text = @"匠人";
        self.certifyname.textColor = [UIColor colorWithRed:255/255.0 green:194/255.0 blue:62/255.0 alpha:1.0];
        
    }else if ([model.catalog isEqual:@"2"]){
        
        
        self.certifyimage.image = [UIImage imageNamed:@"daren@2x.png"];
        self.certifyname.text = @"达人";
        self.certifyname.textColor = [UIColor colorWithRed:87/255.0 green:153/255.0 blue:248/255.0 alpha:1.0];
        
    }else{
        
        
        
    }
    
}




@end

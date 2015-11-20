//
//  headView.m
//  cine
//
//  Created by Mac on 15/11/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "HeadView.h"
#import "headViewModel.h"
@interface HeadView()
/**
 * 背景图片
 */
@property(nonatomic,strong) UIImageView *backPicture;
/**
 * 头像
 */
@property(nonatomic,strong) UIImageView *userImg;
/**
 * 用户名
 */
@property(nonatomic,strong) UILabel *name;
/**
 * 标示
 */
@property(nonatomic,strong) UILabel *mark;
/**
 * 达人
 */
@property(nonatomic,strong) UIButton *vip;

/**
 * 添加按钮
 */
@property(nonatomic,strong) UIButton *addBtn;


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
    CGRect frameRect = CGRectMake(0, 0, wScreen, 220);
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
        self.backPicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wScreen, 160)];
        [self addSubview:self.backPicture];
    
        self.userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 40, 40)];
        [self addSubview:self.userImg];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(80, 140, 80, 20)];
        [self.name setTextColor:[UIColor whiteColor]];
        self.mark = [[UILabel alloc]initWithFrame:CGRectMake(80, 160, 200, 20)];
        
        self.vip = [[UIButton alloc]initWithFrame:CGRectMake(200, 140, 80, 20)];
        
        self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(wScreen - 30, 160, 15, 15)];

        [self addSubview:self.name];
        [self addSubview:self.mark];
        [self.vip setTitle:@"达人" forState:UIControlStateNormal];
        [self.vip setImage:[UIImage imageNamed:@"crown@2x.png"] forState:UIControlStateNormal];
        [self addSubview:self.vip];
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
    
    self.backPicture.image = [UIImage imageNamed:model.backPicture];
    self.userImg.image = [UIImage imageNamed:model.userImg];
    self.name.text = model.name;
    self.mark.text = model.mark;
    [self.addBtn setImage:[UIImage imageNamed:model.addBtnImg] forState:UIControlStateNormal];
    
}
@end

//
//  GuanZhuFirstTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "GuanZhuTableViewCell.h"
#import "GuanZhuModel.h"
#import "UIImageView+WebCache.h"
@implementation GuanZhuTableViewCell : UITableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImg = [[UIImageView alloc]init];
        
        [self.contentView addSubview:self.avatarImg];
        //定义用户名
        self.nickname = [[UILabel alloc] init];
        self.nickname.font = NameFont;
        self.nickname.tintColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
        [self.contentView addSubview:self.nickname];
        //定义评论
        self.content = [[UILabel alloc] init];
        self.content.font = TextFont;
        self.content.tintColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        [self.contentView addSubview:self.content];
        //定义关注按钮
        self.rightBtn = [[UIButton alloc] init];
    
        [self.rightBtn.layer setMasksToBounds:YES];
        [self.rightBtn.layer setCornerRadius:3.0]; //设置矩圆角半径
        [self.rightBtn.layer setBorderWidth:0.6];   //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){254/255.0 ,153/255.0,0/255.0,1.0});
        [self.rightBtn.layer setBorderColor:colorref];//边框颜色
        self.rightBtn.backgroundColor = [UIColor clearColor];
        [self.rightBtn setImage:[UIImage imageNamed:@"follow-mark@2x.png"] forState:UIControlStateNormal];
        [self.rightBtn setTitle:@" 关注" forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = NameFont;
        [self.rightBtn setTitleColor:[UIColor colorWithRed:254/255.0 green:153/255.0 blue:0/255.0 alpha:1.0] forState: UIControlStateNormal];

        [self.contentView addSubview:self.rightBtn];
        
        //自定义分割线
        self.carview = [[UIView alloc]init];
        self.carview.backgroundColor = [ UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        [self.contentView addSubview:self.carview];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    
    //NSLog(@"%f layout %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    
    CGFloat viewW = self.bounds.size.width;
    [self.avatarImg setFrame:CGRectMake(10, 20, 50, 50)];
    //头像圆形
    self.avatarImg.layer.masksToBounds = YES;
    self.avatarImg.layer.cornerRadius = self.avatarImg.frame.size.width/2;
    //头像边框
    self.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImg.layer.borderWidth = 1.5;

    
    [self.nickname setFrame:CGRectMake(70, 20, 200, 20)];
    
    [self.content setFrame:CGRectMake(70, 50, viewW - 90, 20)];
    
    [self.rightBtn setFrame:CGRectMake(viewW - 80,35, 70, 25)];
    
    [self.carview setFrame:CGRectMake(0,80, viewW, 1)];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   // NSLog(@"%f select %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    // Configure the view for the selected state
    //NSLog(@"%f:%f",self.bounds.origin.x, self.bounds.origin.y,nil);
    
}

- (void)setup: (GuanZhuModel *)model {
    //NSLog(@"%f setup %f",self.bounds.size.width, self.window.bounds.size.width,nil);
    
    //头像
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.avatarImg setImage:self.avatarImg.image];
        //头像圆形
        self.avatarImg.layer.masksToBounds = YES;
        self.avatarImg.layer.cornerRadius = self.avatarImg.frame.size.width/2;
        //头像边框
        self.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
        self.avatarImg.layer.borderWidth = 1.5;
    }];
    

    self.nickname.text = model.nickname;
    self.content.text = model.content;
//    self.rightBtn.image = [UIImage imageNamed:model.rightBtn];

}

@end

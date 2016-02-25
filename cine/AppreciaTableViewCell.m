//
//  AppreciaTableViewCell.m
//  cine
//
//  Created by wang on 16/1/14.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "AppreciaTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "EvaluationModel.h"
@implementation AppreciaTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //   NSLog(@"%f init %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.movieImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.movieImg];
        
        self.moviename = [[UILabel alloc]init];
        self.moviename.font = NameFont;
        self.moviename.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];

        
        [self.contentView addSubview:self.moviename];
        
    
        
        self.nickname = [[UILabel alloc]init];
        self.nickname.font = TextFont;
        self.nickname.textColor = [UIColor colorWithRed:58/255.0 green:141/255.0 blue:220/255.0 alpha:1.0];
        [self.contentView addSubview:self.nickname];
        
        //自定义分割线
        self.carview = [[UIView alloc]init];
        self.carview.backgroundColor = [ UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:self.carview];
        
        

           }
    return self;
}

- (void)layoutSubviews {
    
    //   NSLog(@"%f layout %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    
    CGFloat viewW = self.bounds.size.width;
    [self.carview setFrame:CGRectMake(10,84, viewW, 1)];
    [self.movieImg setFrame:CGRectMake(10,10, viewW/4, viewW/6)];
    
    [self.nickname setFrame:CGRectMake(viewW/4+20, 10,100, 20)];
    [self.moviename setFrame:CGRectMake(viewW/4+20,30, viewW - 20 - viewW/4,30)];
   
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setup: (EvaluationModel *)model {

    //  NSLog(@"%f setup %f",self.bounds.size.width, self.window.bounds.size.width,nil);
    
    self.nickname.text =[NSString stringWithFormat:@"@%@",model.to[@"nickname"]];
    
    self.moviename.text =[NSString stringWithFormat:@"对我推荐的电影《%@》表示了感谢",model.recommend.movie.title];
    
    
//    
//
    self.movieImg.contentMode = UIViewContentModeScaleAspectFill;
    self.movieImg.clipsToBounds  = YES;
    
     [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.recommend.movie.cover] placeholderImage:[UIImage imageNamed:@"movieCover.png"]];
    
}

@end

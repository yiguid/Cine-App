//
//  ZambiaTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ZambiaTableViewCell.h"
#import "EvaluationModel.h"
#import "UIImageView+WebCache.h"
@implementation ZambiaTableViewCell

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
        
   
        
        self.text = [[UILabel alloc]init];
        self.text.font = MarkFont;
        self.text.textColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];
        [self.contentView addSubview:self.text];
        
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
    [self.moviename setFrame:CGRectMake(viewW/4+20, 10, viewW, 30)];
    [self.text setFrame:CGRectMake(viewW/4+20,50,viewW/4, 20)];
    [self.nickname setFrame:CGRectMake(viewW/2+20, 50,100, 20)];
    
    
    
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //   NSLog(@"%f select %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    // Configure the view for the selected state
    //   NSLog(@"%f:%f",self.bounds.origin.x, self.bounds.origin.y,nil);
    
}

- (void)setup: (EvaluationModel *)model {
    //  NSLog(@"%f setup %f",self.bounds.size.width, self.window.bounds.size.width,nil);
    
    
    
    if ([model.comment.commentType isEqual:@"0"]) {
        
        self.moviename.text =[NSString stringWithFormat:@"说戏被赞了"];
        
        
    }else if ([model.comment.commentType isEqual:@"1"]){
        
        
        self.moviename.text =[NSString stringWithFormat:@"定格被赞了"];
        
    }else{
        self.moviename.text =[NSString stringWithFormat:@"影评被赞了"];
        
        
    }

    

    self.nickname.text =[NSString stringWithFormat:@"@%@",model.who_vote[@"nickname"]];
    
    self.text.text = @"最新赞的用户";
    
        
    
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.post.image] placeholderImage:[UIImage imageNamed:@"movieCover.png"]];
    
    
    
}


@end

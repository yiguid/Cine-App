//
//  EvaluationTableViewCell.m
//  cine
//
//  Created by wang on 16/1/14.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "EvaluationTableViewCell.h"
#import "EvaluationModel.h"
#import "UIImageView+WebCache.h"
@implementation EvaluationTableViewCell

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
        
        
        //自定义分割线
        self.carview = [[UIView alloc]init];
        self.carview.backgroundColor = [ UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:self.carview];

      
        //消息评论
        self.content = [[UILabel alloc] init];
        self.content.font = TextFont;
        self.content.textColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];

        [self.contentView addSubview:self.content];
    }
    return self;
}

- (void)layoutSubviews {
    
    //   NSLog(@"%f layout %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    
    CGFloat viewW = self.bounds.size.width;
    [self.carview setFrame:CGRectMake(10,84, viewW, 1)];
    [self.movieImg setFrame:CGRectMake(10,10, viewW/4, viewW/6)];
    [self.moviename setFrame:CGRectMake(viewW/4+20, 10, viewW, 30)];
    
    [self.content setFrame:CGRectMake(viewW/4+20,50,viewW/4-20, 20)];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup: (EvaluationModel *)model {
    //  NSLog(@"%f setup %f",self.bounds.size.width, self.window.bounds.size.width,nil);
    
    
//    if ([model.comment.commentType isEqual:@"0"]) {
//        
//         self.moviename.text =[NSString stringWithFormat:@"%@  说戏被评论",model.movie.title];
//        
//        
//    }else if ([model.comment.commentType isEqual:@"1"]){
//    
//        
//         self.moviename.text =[NSString stringWithFormat:@"%@  定格被评论",model.movie.title];
//    
//    }else{
//        self.moviename.text =[NSString stringWithFormat:@"%@  定格被评论",model.movie.title];
//
//    
//    }
    
    self.moviename.text =[NSString stringWithFormat:@"%@  定格被评论",model.movie.title];
    
    
   
    
    self.content.text = model.content;
    
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.post.image] placeholderImage:[UIImage imageNamed:@"movieCover.png"]];
    
    
    
}

@end

//
//  FancSecendTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MessageSecendTableViewCell.h"
#import "SecondModel.h"

@implementation MessageSecendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //   NSLog(@"%f init %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.img = [[UIImageView alloc]init];
        [self.contentView addSubview:self.img];
        //定义用户名
        self.message = [[UILabel alloc] init];
        self.message.font = NameFont;
        self.message.tintColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
        self.message.numberOfLines = 0;
        [self.contentView addSubview:self.message];
    }
    return self;
}

- (void)layoutSubviews {
    
    //   NSLog(@"%f layout %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    
    [self.img setFrame:CGRectMake(10, 5, 80, 70)];
    
    [self.message setFrame:CGRectMake(100, 5, 100, 70)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //   NSLog(@"%f select %f",self.bounds.size.width,self.window.bounds.size.width,nil);
    // Configure the view for the selected state
    //   NSLog(@"%f:%f",self.bounds.origin.x, self.bounds.origin.y,nil);
    
}

- (void)setup: (SecondModel *)model {
    //  NSLog(@"%f setup %f",self.bounds.size.width, self.window.bounds.size.width,nil);
    
    self.img.image = [UIImage imageNamed:model.img];
    self.message.text = model.message;
}

@end

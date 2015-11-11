//
//  CommentTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.userImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.userImg];

    
    self.comment = [[UILabel alloc]init];
    self.comment.numberOfLines = 0;
    [self.contentView addSubview:self.comment];
    
    self.nickName = [[UILabel alloc]init];
    [self.contentView addSubview:self.nickName];
    
    self.time = [[UILabel alloc]init];
    [self.time setFont:[UIFont systemFontOfSize:14.0]];
    self.time.textColor = [UIColor colorWithRed:218.0/255 green:218.0/255 blue:218.0/255 alpha:1.0];
    [self.contentView addSubview:self.time];
    
    self.zambia = [[UIButton alloc]init];
    [self.contentView addSubview:self.zambia];
    
    return self;
}

- (void)layoutSubviews{
    
    CGFloat viewW = self.bounds.size.width;
    CGFloat userY = 10;
    CGFloat userX = 60;
    //间隙
    CGFloat paddingY = 10;
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
    CGSize sizeM = CGSizeMake(viewW - 20, MAXFLOAT);
    CGSize commentSize =  [self.comment.text boundingRectWithSize:sizeM options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    NSLog(@"%f",commentSize.height);
    [self.comment setFrame:CGRectMake(userX,70, viewW - 10 - userX, commentSize.height + 40)];
    
    [self.userImg setFrame:CGRectMake(10, userY, 40, 40)];
    
    CGSize sizeN = CGSizeMake(MAXFLOAT, MAXFLOAT);
    NSDictionary *dictN = @{NSFontAttributeName : [UIFont systemFontOfSize:20.0]};
    CGSize sizeName = [self.nickName.text boundingRectWithSize:sizeN options:NSStringDrawingUsesLineFragmentOrigin attributes:dictN context:nil].size;
    
    [self.nickName setFrame:CGRectMake(userX, userY, sizeName.width, sizeName.height)];
   
    [self.time setFrame:CGRectMake(userX,   sizeName.height + userY, 80, 30)];
    
    [self.zambia setFrame:CGRectMake(viewW - 80, userY, 70, 60)];

}

- (void) setup:(CommentModel *)model{
    self.userImg.image = [UIImage imageNamed:model.userImg];
    self.nickName.text = model.nickName;
    self.comment.text = model.comment;
    
    [self.zambia setImage:[UIImage imageNamed:model.zambiaImg] forState:UIControlStateNormal];
    [self.zambia setTitle:model.zambiaCounts forState:UIControlStateNormal];
    [self.zambia setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    self.time.text = model.time;
}


@end

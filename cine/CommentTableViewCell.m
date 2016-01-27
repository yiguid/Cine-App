//
//  CommentTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "UIImageView+WebCache.h"
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
    self.comment.font = TextFont;
    self.comment.textColor = [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0];
    [self.contentView addSubview:self.comment];
    
    self.nickName = [[UILabel alloc]init];
    [self.nickName setFont:NameFont];
      [self.contentView addSubview:self.nickName];
    
    self.time = [[UILabel alloc]init];
    [self.time setFont:TimeFont];
    self.time.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];

    [self.contentView addSubview:self.time];
    
    self.zambia = [[UIButton alloc]init];
    [self.zambia setImage:[UIImage imageNamed:@"zan_n@2x.png"] forState:UIControlStateNormal];
    self.zambia.selected = NO;
    [self.zambia setImage:[UIImage imageNamed:@"zan_p@2x.png"] forState:UIControlStateSelected];
    
    
    [self.contentView addSubview:self.zambia];
    
    
    //自定义分割线
    self.carview = [[UIView alloc]init];
    self.carview.backgroundColor = [ UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0];
    [self.contentView addSubview:self.carview];
    
    

    
    return self;
}

//在这个方法中设置子控件的frame和显示数据.

- (void)setModelFrame:(CommentModelFrame *)modelFrame{
    _modelFrame = modelFrame;
    //给子控件设置数据
    [self settingData];
    //给子控件设置frame
    [self settingFrame];

}

-(void) layoutSubviews{
    
    //头像圆形
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
    //头像边框
    self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImg.layer.borderWidth = 1.5;
}

//设置数据
-(void)settingData{
    //微博数据
    CommentModel *model = self.modelFrame.model;
    //头像
    
    //头像
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.userImg setImage:self.userImg.image];
        //头像圆形
        self.userImg.layer.masksToBounds = YES;
        self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
        //头像边框
        self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userImg.layer.borderWidth = 1.5;
    }];

    //昵称
    self.nickName.text = model.user.nickname;;
    //评论
    self.comment.text = model.content;
    //点赞
    [self.zambia setTitle:model.voteCount forState:UIControlStateNormal];
    [self.zambia setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.zambia.titleLabel.font  = [UIFont systemFontOfSize: 13];
    self.zambia.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    //时间
    self.time.text = model.createdAt;
    

    
    
    
    
    
       
}

//设置frame
-(void)settingFrame{
    //头像
    self.userImg.frame = self.modelFrame.iconF;
    //昵称
    self.nickName.frame = self.modelFrame.nameF;
    //评论
    self.comment.frame = self.modelFrame.commentF;
    //时间
    self.time.frame = self.modelFrame.timeF;
    //点赞
    self.zambia.frame = self.modelFrame.zambiaF;
    
    self.carview.frame = self.modelFrame.carviewF;
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"model";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

@end

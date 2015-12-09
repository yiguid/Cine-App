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
    [self.contentView addSubview:self.comment];
    
    self.nickName = [[UILabel alloc]init];
    [self.contentView addSubview:self.nickName];
    
    self.time = [[UILabel alloc]init];
    [self.time setFont:TimeFont];
    self.time.textColor = [UIColor colorWithRed:218.0/255 green:218.0/255 blue:218.0/255 alpha:1.0];

    [self.contentView addSubview:self.time];
    
    self.zambia = [[UIButton alloc]init];
    [self.zambia setImage:[UIImage imageNamed:@"thumbsup.png"] forState:UIControlStateNormal];

    [self.contentView addSubview:self.zambia];

    
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

//设置数据
-(void)settingData{
    //微博数据
    CommentModel *model = self.modelFrame.model;
    //头像
    self.userImg.image = [UIImage imageNamed:model.userImg];
    //昵称
    self.nickName.text = model.nickName;
    //评论
    self.comment.text = model.comment;
    //点赞
    [self.zambia setTitle:model.zambiaCounts forState:UIControlStateNormal];
    [self.zambia setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    //时间
    self.time.text = model.time;
    
\
    
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

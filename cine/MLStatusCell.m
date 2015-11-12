//
//  MLStatusCell.m
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MLStatusCell.h"
#import "MLStatus.h"
#import "MLStatusFrame.h"
//昵称的字体
#define MLNameFont [UIFont systemFontOfSize:14]
//正文的字体
#define MLTextFont [UIFont systemFontOfSize:15]
@interface MLStatusCell()
//头像
@property(nonatomic, weak) UIImageView *iconView;
//昵称
@property(nonatomic, weak) UILabel *nameView;
//达人
@property(nonatomic, weak) UIImageView *vipView;
//正文
@property(nonatomic, weak) UILabel *textView;
//配图
@property(nonatomic, weak) UIImageView *pictureView;
//标示
@property(nonatomic,strong) UILabel *mark;
//达人
@property(nonatomic,strong) UIButton *daRen;

//时间
@property(nonatomic,strong) UILabel *time;
//赞过按钮
@property(nonatomic,strong) UIButton *zambia;
//回复按钮
@property(nonatomic,strong) UIButton *answer;
//筛选按钮
@property(nonatomic,strong) UIButton *screen;

@end
@implementation MLStatusCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //自定义cell,一定要把子控件添加到contentView中
        //只添所有加子控件(不设置数据和frame)
        //头像
        UIImageView *iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        //昵称
        UILabel *nameView = [[UILabel alloc]init];
        nameView.font = MLNameFont;
        [self.contentView addSubview:nameView];
        self.nameView = nameView;
        //会员图标
        UIImageView *vipView = [[UIImageView alloc]init];
        vipView.image = [UIImage imageNamed:@"vip"];
        [self.contentView addSubview:vipView];
        self.vipView = vipView;
        //正文
        UILabel *textView = [[UILabel alloc]init];
        textView.font = MLTextFont;
        textView.numberOfLines = 0;
        [self.contentView addSubview:textView];
        self.textView = textView;
        //配图
        UIImageView *pictureView = [[UIImageView alloc]init];
        [self.contentView addSubview:pictureView];
        self.pictureView = pictureView;
        //标示
        UILabel *mark = [[UILabel alloc]init];
        [self.contentView addSubview:mark];
        self.mark = mark;
        //时间
        UILabel *time = [[UILabel alloc]init];
        [self.contentView addSubview:time];
        self.time = time;
        //赞过按钮
        UIButton *zambia = [[UIButton alloc]init];
        [self.contentView addSubview:zambia];
        self.zambia = zambia;
        //回复按钮
        UIButton *answer = [[UIButton alloc]init];
        [self.contentView addSubview:answer];
        self.answer = answer;
        //筛选按钮
        UIButton *screen = [[UIButton alloc]init];
        [self.contentView addSubview:screen];
        self.screen = screen;
        
    }
    return self;
}
//在这个方法中设置子控件的frame和显示数据.
-(void) setStatusFrame:(MLStatusFrame *)statusFrame{
    _statusFrame = statusFrame;
    //给子控件设置数据
    [self settingData];
    //给子控件设置frame
    [self settingFrame];
}
//设置数据
-(void)settingData{
    //微博数据
    MLStatus *status = self.statusFrame.status;
    //头像
    self.iconView.image = [UIImage imageNamed:status.icon];
    //昵称
    self.nameView.text = status.name;
    //会员
    if (status.vip) {
        self.vipView.hidden = NO;
        self.nameView.textColor = [UIColor redColor];
    }else{
        self.vipView.hidden = YES;
        self.nameView.textColor = [UIColor blackColor];
    }
    //正文
    self.textView.text = status.text;
    //配图
    if(status.picture){
        self.pictureView.hidden = NO;
        self.pictureView.image = [UIImage imageNamed:status.picture];
    }else{
        self.pictureView.hidden = YES;
    }
    self.mark.text = status.mark;
    [self.daRen setImage:[UIImage imageNamed:status.daRenImg] forState:UIControlStateNormal];
    [self.daRen setTitle:status.daRenTitle forState:UIControlStateNormal];
    [self.daRen setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.zambia setImage:[UIImage imageNamed:status.zambiaImg] forState:UIControlStateNormal];
    [self.zambia setTitle:status.zambiaCount forState:UIControlStateNormal];
    [self.zambia setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.answer setImage:[UIImage imageNamed:status.answerImg] forState:UIControlStateNormal];
    [self.answer setTitle:status.answerCount forState:UIControlStateNormal];
    [self.answer setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.screen setImage:[UIImage imageNamed:status.screenImg] forState:UIControlStateNormal];
    
    self.time.text = status.time;

    
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
//设置frame
-(void)settingFrame{
    //头像
    self.iconView.frame = self.statusFrame.iconF;
    //昵称
    self.nameView.frame = self.statusFrame.nameF;
    //会员图标
    self.vipView.frame = self.statusFrame.vipF;
    //正文
    self.textView.frame = self.statusFrame.textF;
    //配图
    if(self.statusFrame.status.picture){
        self.pictureView.frame = self.statusFrame.pictureF;
    }
    self.mark.frame = self.statusFrame.markF;
    self.time.frame = self.statusFrame.timeF;
    self.daRen.frame = self.statusFrame.vipF;
    self.zambia.frame = self.statusFrame.zambiaF;
    self.answer.frame = self.statusFrame.answerF;
    self.screen.frame = self.statusFrame.screenF;

}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    MLStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MLStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
@end
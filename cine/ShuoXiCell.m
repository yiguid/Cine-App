//
//  MLStatusCell.m
//  cine
//
//  Created by Mac on 15/11/12.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ShuoXiCell.h"
#import "ShuoXiModel.h"
#import "ShuoXiModelFrame.h"
@interface ShuoXiCell()
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
@implementation ShuoXiCell
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
        nameView.font = NameFont;
        [self.contentView addSubview:nameView];
        self.nameView = nameView;
        //会员图标
        UIImageView *vipView = [[UIImageView alloc]init];
        vipView.image = [UIImage imageNamed:@"vip"];
        [self.contentView addSubview:vipView];
        self.vipView = vipView;
        //正文
        UILabel *textView = [[UILabel alloc]init];
        textView.font = TextFont;
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
        //达人
        self.daRen = [[UIButton alloc]init];
         [self.daRen setImage:[UIImage imageNamed:@"crown@2x.png"] forState:UIControlStateNormal];
        //时间
        UILabel *time = [[UILabel alloc]init];
        [self.contentView addSubview:time];
        self.time = time;
        //赞过按钮
        self.zambia = [[UIButton alloc]init];
        [self.zambia setImage:[UIImage imageNamed:@"thumbsup.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.zambia];
        //回复按钮
        self.answer = [[UIButton alloc]init];
        [self.answer setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.answer];
        //筛选按钮
        UIButton *screen = [[UIButton alloc]init];
        [self.screen setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];

        [self.contentView addSubview:screen];
        self.screen = screen;
        
    }
    return self;
}
//在这个方法中设置子控件的frame和显示数据.
-(void) setModelFrame:(ShuoXiModelFrame *)modelFrame{
    _modelFrame = modelFrame;
    //给子控件设置数据
    [self settingData];
    //给子控件设置frame
    [self settingFrame];
}
//设置数据
-(void)settingData{

    ShuoXiModel *model = self.modelFrame.model;
    //头像
    self.iconView.image = [UIImage imageNamed:model.icon];
    //昵称
    self.nameView.text = model.name;
    //会员
    if (model.vip) {
        self.vipView.hidden = NO;
        self.nameView.textColor = [UIColor redColor];
    }else{
        self.vipView.hidden = YES;
        self.nameView.textColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
    }
    //正文
    self.textView.text = model.text;
    //配图
    if(model.picture){
        self.pictureView.hidden = NO;
        self.pictureView.image = [UIImage imageNamed:model.picture];
    }else{
        self.pictureView.hidden = YES;
    }
    self.mark.text = model.mark;
    [self.daRen setTitle:model.daRenTitle forState:UIControlStateNormal];
    [self.daRen setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
 
    [self.zambia setTitle:model.zambiaCount forState:UIControlStateNormal];
    [self.zambia setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.answer setTitle:model.answerCount forState:UIControlStateNormal];
    [self.answer setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
        
    self.time.text = model.time;

    
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
//设置frame
-(void)settingFrame{
    //头像
    self.iconView.frame = self.modelFrame.iconF;
    //昵称
    self.nameView.frame = self.modelFrame.nameF;
    //会员图标
    self.vipView.frame = self.modelFrame.vipF;
    //正文
    self.textView.frame = self.modelFrame.textF;
    //配图
    if(self.modelFrame.model.picture){
        self.pictureView.frame = self.modelFrame.pictureF;
    }
    self.mark.frame = self.modelFrame.markF;
    self.time.frame = self.modelFrame.timeF;
    self.daRen.frame = self.modelFrame.vipF;
    self.zambia.frame = self.modelFrame.zambiaF;
    self.answer.frame = self.modelFrame.answerF;
    self.screen.frame = self.modelFrame.screenF;

}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    ShuoXiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ShuoXiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
@end
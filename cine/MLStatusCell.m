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
@property(nonatomic, weak) UIImageView *iconView;
@property(nonatomic, weak) UILabel *nameView;
@property(nonatomic, weak) UIImageView *vipView;
@property(nonatomic, weak) UILabel *textView;
@property(nonatomic, weak) UIImageView *pictureView;
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
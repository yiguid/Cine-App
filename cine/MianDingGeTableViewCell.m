////
////  MianDingGeTableViewCell.m
////  cine
////
////  Created by Mac on 15/11/13.
////  Copyright © 2015年 yiguid. All rights reserved.
////
//
//#import "MianDingGeTableViewCell.h"
//#import "DingGeModel.h"
//#import "MianDingGeModelFrame.h"
//
//
//@implementation MianDingGeTableViewCell
//
//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        //电影图片
//        self.movieImg = [[UIImageView alloc]init];
//        [self.contentView addSubview:self.movieImg];
//        //电影名
//        self.movieName = [[UILabel alloc]init];
//        self.movieName.textColor = [UIColor colorWithRed:237.0/255 green:142.0/255 blue:0.0/255 alpha:1.0];
//        self.movieName.textAlignment = NSTextAlignmentRight;
//        self.movieName.layer.borderWidth = 1;
//        [self.movieName.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorWithRed:57.0/255 green:37.0/255 blue:22.0/255 alpha:1.0])];
//        [self.contentView addSubview:self.movieName];
//        //用户图片
//        self.userImg = [[UIImageView alloc]init];
//        [self.contentView addSubview:self.userImg];
//        //用户名
//        self.nikeName = [[UILabel alloc]init];
//        [self.contentView addSubview:self.nikeName];
//        //用户留言
//        self.message = [[UILabel alloc]init];
//        self.message.numberOfLines = 0;
//        [self.contentView addSubview:self.message];
//        //时间
//        self.timeBtn = [[UIButton alloc]init];
//        [self.contentView addSubview:self.timeBtn];
//  
//    }
//    
//    return self;
//}
//- (void)setModelFrame:(MianDingGeModelFrame *)modelFrame{
//    _modelFrame = modelFrame;
//    //给子控件设置数据
//    [self settingData];
//    //给子控件设置frame
//    [self settingFrame];
//}
//
////设置数据
//-(void)settingData{
//    
//    DingGeModel *model = self.modelFrame.model;
//    //头像
//    self.userImg.image = [UIImage imageNamed:model.userImg];
//    //昵称
//    self.nikeName.text = model.nikeName;
//    //正文
//    self.message.text = model.message;
//    
//    //配图
//    self.movieImg.image = [UIImage imageNamed:model.movieImg];
//    
//    [self.timeBtn setImage:[UIImage imageNamed:model.timeImg] forState:UIControlStateNormal];
//    [self.timeBtn setTitle:model.time forState:UIControlStateNormal];
//    [self.timeBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
//    self.movieName.text = model.movieName;
//}
//
////设置frame
//-(void)settingFrame{
//    //电影
//    self.movieImg.frame = self.modelFrame.iconF;
//    //昵称
//    self.nikeName.frame = self.modelFrame.nameF;
//    //头像
//    self.userImg.frame = self.modelFrame.iconF;
//    //正文
//    self.message.frame = self.modelFrame.textF;
//    //配图
//    self.movieImg.frame = self.modelFrame.pictureF;
//    self.timeBtn.frame = self.modelFrame.timeF;
//    self.movieName.frame = self.modelFrame.movieNameF;
//}
//
//+ (instancetype)cellWithTableView:(UITableView *)tableView
//{
//    static NSString *ID = @"status";
//    MianDingGeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[MianDingGeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    return cell;
//}
//
//
//@end

//
//  DingGeSecondTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DingGeModel.h"
#import "YXLTagEditorImageView.h"
@interface DingGeSecondTableViewCell : UITableViewCell

@property(nonatomic,strong)DingGeModel *model;
@property(nonatomic,strong) YXLTagEditorImageView *tagEditorImageView;
@property(nonatomic,strong) NSMutableArray *tagsArray;
@property(nonatomic,strong) NSMutableArray *coordinateArray;
//电影图片
@property(nonatomic,strong) UIImageView *movieImg;

//用户图片
@property(nonatomic,strong) UIImageView *userImg;

//用户名
@property(nonatomic,strong) UILabel *nikeName;


//电影名
@property(nonatomic,strong) UILabel *movieName;

//时间图片
@property(nonatomic,strong) UIImageView *timeImg;

@property(nonatomic,strong) UILabel *comment;
//浏览量按钮
@property(nonatomic,strong) UIButton *seeBtn;
//赞过按钮
@property(nonatomic,strong) UIButton *zambiaBtn;
//回复按钮
@property(nonatomic,strong) UIButton *answerBtn;
//筛选按钮
@property(nonatomic,strong) UIButton *screenBtn;

//时间按钮
@property(nonatomic,strong) UIButton *timeBtn;

//自定义线条
@property (strong, nonatomic) UIView * carview;

@property (strong, nonatomic) UIView * commentview;

//image的高度
@property(nonatomic,assign) CGFloat imageHeight;

@property(nonatomic,assign) CGFloat cellHeight;

- (void)setup :(DingGeModel *)model;


@end

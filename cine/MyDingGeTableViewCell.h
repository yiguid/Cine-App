//
//  MyDingGeTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXLTagEditorImageView.h"

@class DingGeModelFrame;
@interface MyDingGeTableViewCell : UITableViewCell

//电影图片
@property(nonatomic,strong) UIImageView *movieImg;

@property(nonatomic,strong) YXLTagEditorImageView *tagEditorImageView;
@property(nonatomic,strong) NSMutableArray *tagsArray;
@property(nonatomic,strong) NSMutableArray *coordinateArray;

//用户图片
@property(nonatomic,strong) UIImageView *userImg;

//用户名
@property(nonatomic,strong) UILabel *nikeName;

//用户留言
@property(nonatomic,strong) UILabel *message;

//浏览量按钮
@property(nonatomic,strong) UIButton *seeBtn;
//赞过按钮
@property(nonatomic,strong) UIButton *zambiaBtn;
//回复按钮
@property(nonatomic,strong) UIButton *answerBtn;
//筛选按钮
@property(nonatomic,strong) UIButton *screenBtn;
//电影名
@property(nonatomic,strong) UILabel *movieName;

//时间按钮
@property(nonatomic,strong) UIButton *timeBtn;

//自定义线条
@property (strong, nonatomic) UIView * carview;

//玻璃页面（放置电影名）
@property(nonatomic,strong) UIView * commentview;

@property(nonatomic, strong) DingGeModelFrame *modelFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setTags;
@property(nonatomic, assign)CGFloat ratio;



@end



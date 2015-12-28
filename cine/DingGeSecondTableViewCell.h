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

//时间
@property(nonatomic,strong) UILabel *time;
//电影名
@property(nonatomic,strong) UILabel *movieName;

//时间图片
@property(nonatomic,strong) UIImageView *timeImg;

@property(nonatomic,strong) UILabel *comment;

@property(nonatomic,strong) UILabel *foortitle;

- (void)setup :(DingGeModel *)model;


@end

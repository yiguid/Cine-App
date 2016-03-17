//
//  MyDingGeTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MyDingGeTableViewCell.h"
#import "DingGeModel.h"
#import "DingGeModelFrame.h"
#import "UIImageView+WebCache.h"
#import "cine.pch"
@implementation MyDingGeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         //电影图片
        self.movieImg = [[UIImageView alloc]init];
//        [self.contentView addSubview:self.movieImg];
        
        //用户图片
        self.userImg = [[UIImageView alloc]init];
        
        //用户名
        self.nikeName = [[UILabel alloc]init];
        self.nikeName.font = NameFont;
        [self.contentView addSubview:self.nikeName];
        //电影名
        self.movieName = [[UILabel alloc]init];
        self.movieName.textColor = [UIColor colorWithRed:232.0/255 green:152.0/255 blue:0.0/255 alpha:1.0];
        self.movieName.textAlignment = NSTextAlignmentRight;
        self.movieName.layer.borderWidth = 1;
        self.movieName.font = TextFont;
        [self.movieName.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorWithRed:235.0/255 green:155.0/255 blue:0/255 alpha:1.0])];
        
        self.movieName.userInteractionEnabled = YES;

        //时间
        self.timeBtn = [[UIButton alloc]init];
        [self.timeBtn setImage:[UIImage imageNamed:@"time@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.timeBtn];

        //用户留言
        self.message = [[UILabel alloc]init];
        self.message.numberOfLines = 0;
        self.message.font = NameFont;
        self.message.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
        
        
        
        
        
        [self.contentView addSubview:self.message];
        //用户浏览量
        self.seeBtn = [[UIButton alloc]init];
        [self.seeBtn setImage:[UIImage imageNamed:@"看过@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.seeBtn];
        
        
        
        
        
        //赞过按钮
        self.zambiaBtn = [[UIButton alloc]init];
        [self.zambiaBtn setImage:[UIImage imageNamed:@"zan@2x.png"] forState:UIControlStateNormal];

        [self.zambiaBtn setImage:[UIImage imageNamed:@"zan-2@2x.png"] forState:UIControlStateSelected];
        

        
        [self.contentView addSubview:self.zambiaBtn];
        
        
        
        //回复按钮
        self.answerBtn = [[UIButton alloc]init];
        [self.answerBtn setImage:[UIImage imageNamed:@"评论@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.answerBtn];
        //筛选按钮
        self.screenBtn = [[UIButton alloc]init];
        [self.screenBtn setImage:[UIImage imageNamed:@"_..@2x.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.screenBtn];
        
        
        //自定义分割线
        self.carview = [[UIView alloc]init];
        self.carview.backgroundColor = [ UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        [self.contentView addSubview:self.carview];
        
//        self.tagEditorImageView = [[YXLTagEditorImageView alloc]initWithImage:[UIImage imageNamed:@"myBackImg.png"] imageEvent:ImageHaveNoEvent];
//        self.tagEditorImageView.userInteractionEnabled=YES;
        self.tagsArray = [[NSMutableArray alloc] init];
        self.coordinateArray = [[NSMutableArray alloc] init];
//        self.tagEditorImageView.frame = CGRectMake(5, 5, wScreen-10, 260); //190
//        self.tagEditorImageView.imagePreviews.frame = CGRectMake(5, 5, wScreen-20, 260);
//        
//        
//        
//        //    [self.contentView bringSubviewToFront:self.tagEditorImageView];
//        
//        //    [self.contentView addSubview:self.movieName];
//        self.commentview = [[UIView alloc]initWithFrame:CGRectMake(5,235,wScreen-20, 30)]; //165
//        self.commentview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//        [self.commentview addSubview:self.movieName];
//        [self.tagEditorImageView addSubview:self.commentview];
//        [self.contentView addSubview:self.tagEditorImageView];
//        
//        //头像在上
//        [self.contentView addSubview:self.userImg];
     }
    
    return self;
}
//在这个方法中设置子控件的frame和显示数据.
- (void)setModelFrame:(DingGeModelFrame *)modelFrame{
    _modelFrame = modelFrame;
    //给子控件设置数据
    [self settingData];
    //给子控件设置frame
    [self settingFrame];

}

//设置数据
-(void)settingData{

    DingGeModel *model = self.modelFrame.model;
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [userDef stringForKey:@"userID"];
    
     self.zambiaBtn.selected = NO;

    for (NSDictionary * dict in model.voteBy) {
        if ([dict[@"id"] isEqual:userId]) {
            self.zambiaBtn.selected = YES;
            break;
        }
    }

    
    
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
    self.nikeName.text = model.nikeName;
    //正文
    self.message.text = model.message;
    
    //配图
//    self.movieImg.image = [UIImage imageNamed:model.movieImg];
    
//    UIImageView *image = [[UIImageView alloc] init];
//    [image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"myBackImg.png"]];
//    [image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"myBackImg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        NSLog(@"Dingge Image Size: %f",image.size.height,nil);
//        //self.tagEditorImageView.frame.size.height = image.size.height;
//    }];
   
    
    
//    [self.tagEditorImageView addSubview:self.userImg];
//    [commentview addSubview:self.movieName];
    
//    UIView * anniuview = [[UIView alloc]initWithFrame:CGRectMake(10, 190, wScreen-20, 100)];
//    anniuview.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:anniuview];
   
    
    
//    UITableView *tableview = (UITableView *)self.superview.superview;
//    self.tagEditorImageView.viewC = (UIViewController *)tableview.delegate;
//    for (UIView* next = [self superview]; next; next = next.superview) {
//        if ([next isKindOfClass:[UITableView class]]) {
//            UITableView *tableview = (UITableView *)next;
//            self.tagEditorImageView.viewC = (UIViewController *)tableview.delegate;
//            break;
//        }
//    }
    
    self.tagsArray = model.tags;
    self.coordinateArray = model.coordinates;
    
    [self.timeBtn setTitle:model.createdAt forState:UIControlStateNormal];
    self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    //计算比例
//    float height = self.tagEditorImageView.imagePreviews.image.size.height;
    //可以从imagePreviews.image.size，看到设置的是190/280，在没有编辑的时候
//    float alpha = 1;
//    self.tagEditorImageView
    
    [self.tagEditorImageView removeFromSuperview];
    self.tagEditorImageView = nil;
    
    self.tagEditorImageView = [[YXLTagEditorImageView alloc]initWithImage:[UIImage imageNamed:@"myBackImg.png"] imageEvent:ImageHaveNoEvent];
    self.tagEditorImageView.userInteractionEnabled=YES;
    self.tagEditorImageView.frame = CGRectMake(5, 5, wScreen-10, 260); //190
    self.tagEditorImageView.imagePreviews.frame = CGRectMake(5, 5, wScreen-20, 260);
    
    self.commentview = [[UIView alloc]initWithFrame:CGRectMake(5,235,wScreen-20, 30)]; //165
    self.commentview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.commentview addSubview:self.movieName];
    [self.tagEditorImageView addSubview:self.commentview];
    [self.contentView addSubview:self.tagEditorImageView];
    
    //头像在上
    [self.contentView addSubview:self.userImg];
    
    
    [self.seeBtn setTitle:model.seeCount forState:UIControlStateNormal];
    [self.seeBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.seeBtn.titleLabel.font  = [UIFont systemFontOfSize: 13];
    self.seeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    
    [self.zambiaBtn setTitle:model.zambiaCount forState:UIControlStateNormal];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
     [self.zambiaBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:177/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateSelected];
    self.zambiaBtn.titleLabel.font  = [UIFont systemFontOfSize: 13];
    self.zambiaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    
    [self.answerBtn setTitle:model.answerCount forState:UIControlStateNormal];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    self.answerBtn.titleLabel.font  = [UIFont systemFontOfSize: 13];
    self.answerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    [self.timeBtn setTitle:model.time forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    self.timeBtn.titleLabel.font  = TimeFont;
    self.timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    

    self.movieName.text = model.movieName;
 
}

- (void)setTags{
    
    for (NSInteger i = 0; i < [self.tagsArray count];i++) {
        NSDictionary *tag = [self.tagsArray objectAtIndex:i];
        NSDictionary *coordinate = [self.coordinateArray objectAtIndex:i];
        float pointX = [coordinate[@"x"] floatValue] * self.ratio;
        float pointY = [coordinate[@"y"] floatValue] * self.ratio;
        NSString *textString = tag[@"name"];
        NSString *directionString = coordinate[@"direction"];
        if([directionString isEqualToString:@"left"])
        {
            [self.tagEditorImageView addTagViewText:textString Location:CGPointMake(pointX,pointY) isPositiveAndNegative:YES];
        }
        else
        {
            [self.tagEditorImageView addTagViewText:textString Location:CGPointMake(pointX,pointY) isPositiveAndNegative:NO];
        }
        
    }
}


- (void)layoutSubviews{
    //电影
    self.movieImg.frame = self.modelFrame.iconF;
    //昵称
    self.nikeName.frame = self.modelFrame.nameF;
    //头像
    self.userImg.frame = self.modelFrame.iconF;
    //头像圆形
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
    //头像边框
    self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImg.layer.borderWidth = 1.5;
    //会员图标
    //   self.vipView.frame = self.modelFrame.vipF;
    //正文
    self.message.frame = self.modelFrame.textF;
    //配图
    self.movieImg.frame = self.modelFrame.pictureF;
    self.seeBtn.frame = self.modelFrame.seenF;
    self.zambiaBtn.frame = self.modelFrame.zambiaF;
    self.answerBtn.frame = self.modelFrame.answerF;
    self.screenBtn.frame = self.modelFrame.screenF;
    self.timeBtn.frame = self.modelFrame.timeF;
    self.movieName.frame = self.modelFrame.movieNameF;
    self.carview.frame = self.modelFrame.carviewF;
    
}


//设置frame
-(void)settingFrame{
    //电影
    self.movieImg.frame = self.modelFrame.iconF;
    //昵称
    self.nikeName.frame = self.modelFrame.nameF;
    //头像
    self.userImg.frame = self.modelFrame.iconF;
    //会员图标
 //   self.vipView.frame = self.modelFrame.vipF;
    //正文
    self.message.frame = self.modelFrame.textF;
    //配图
    self.movieImg.frame = self.modelFrame.pictureF;
    self.seeBtn.frame = self.modelFrame.seenF;
    self.zambiaBtn.frame = self.modelFrame.zambiaF;
    self.answerBtn.frame = self.modelFrame.answerF;
    self.screenBtn.frame = self.modelFrame.screenF;
    self.timeBtn.frame = self.modelFrame.timeF;
    self.movieName.frame = self.modelFrame.movieNameF;
    self.carview.frame = self.modelFrame.carviewF;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    MyDingGeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MyDingGeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}



@end

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

@implementation MyDingGeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) viewWillAppear:(BOOL)animated{
    
    //获取服务器数据
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
     NSString *url = @"http://fl.limijiaoyin.com:1337/post";
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"----1--2---3--%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         //电影图片
        self.movieImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.movieImg];
        //用户图片
        self.userImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.userImg];
        //用户名
        self.nikeName = [[UILabel alloc]init];
        self.nikeName.font = NameFont;
        [self.contentView addSubview:self.nikeName];
        //电影名
        self.movieName = [[UILabel alloc]init];
        self.movieName.textColor = [UIColor colorWithRed:237.0/255 green:142.0/255 blue:0.0/255 alpha:1.0];
        self.movieName.textAlignment = NSTextAlignmentRight;
        self.movieName.layer.borderWidth = 1;
        [self.movieName.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorWithRed:57.0/255 green:37.0/255 blue:22.0/255 alpha:1.0])];
        [self.contentView addSubview:self.movieName];

        //时间
        self.timeBtn = [[UIButton alloc]init];
        [self.timeBtn setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.timeBtn];

        //用户留言
        self.message = [[UILabel alloc]init];
        self.message.numberOfLines = 0;
        self.message.font = TextFont;
        [self.contentView addSubview:self.message];
        //用户浏览量
        self.seeBtn = [[UIButton alloc]init];
        [self.seeBtn setImage:[UIImage imageNamed:@"views.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.seeBtn];
        //赞过按钮
        self.zambiaBtn = [[UIButton alloc]init];
        [self.zambiaBtn setImage:[UIImage imageNamed:@"thumbsup.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.zambiaBtn];
        //回复按钮
        self.answerBtn = [[UIButton alloc]init];
        [self.answerBtn setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.answerBtn];
        //筛选按钮
        self.screenBtn = [[UIButton alloc]init];
        [self.screenBtn setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.screenBtn];
        
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
    //头像
    self.userImg.image = [UIImage imageNamed:model.userImg];
    //昵称
    self.nikeName.text = model.nikeName;
    //正文
    self.message.text = model.message;
    
    //配图
    self.movieImg.image = [UIImage imageNamed:model.movieImg];
    [self.seeBtn setTitle:model.seeCount forState:UIControlStateNormal];
    [self.seeBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    

    [self.zambiaBtn setTitle:model.zambiaCount forState:UIControlStateNormal];
    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.answerBtn setTitle:model.answerCount forState:UIControlStateNormal];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [self.timeBtn setTitle:model.time forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    self.movieName.text = model.movieName;

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

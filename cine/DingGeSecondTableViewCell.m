//
//  DingGeSecondTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "DingGeSecondTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "cine.pch"

@implementation DingGeSecondTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageHeight = 190;
        //电影图片
        self.movieImg = [[UIImageView alloc]init];
//        [self.contentView addSubview:self.movieImg];
        //用户图片
        self.userImg = [[UIImageView alloc]init];

        //用户名
        self.nikeName = [[UILabel alloc]init];
        [self.contentView addSubview:self.nikeName];
        
        //电影名
        
        //电影名
        self.movieName = [[UILabel alloc]init];
        self.movieName.textColor = [UIColor colorWithRed:237.0/255 green:142.0/255 blue:0.0/255 alpha:1.0];
        self.movieName.textAlignment = NSTextAlignmentRight;
        self.movieName.layer.borderWidth = 1;
        [self.movieName.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorWithRed:57.0/255 green:37.0/255 blue:22.0/255 alpha:1.0])];

  
        self.comment = [[UILabel alloc]init];
        self.comment.numberOfLines = 0;
        self.comment.font = TextFont;
        self.comment.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [self.contentView addSubview:self.comment];
        
        
        //时间
        self.timeBtn = [[UIButton alloc]init];
        [self.timeBtn setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.timeBtn];
        
        
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
        
    }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = self.bounds.size.width;
  
    NSLog(@"%f",self.imageHeight,nil);
    
//    [self.movieImg setFrame:CGRectMake(5, 5, viewW - 10, 170)];
    
    [self.userImg setFrame:CGRectMake(10, 10, 40, 40)];
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0]};
    CGSize sizeN = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize sizeName = [self.nikeName.text boundingRectWithSize:sizeN options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [self.nikeName setFrame:CGRectMake(55,self.imageHeight, sizeName.width, sizeName.height)];
    
    
    
    CGSize sizeComment = [self sizeWithText:self.comment.text font:TextFont maxSize:CGSizeMake(viewW - 20, MAXFLOAT)];
    [self.comment setFrame:CGRectMake(10, self.imageHeight + 30, sizeComment.width, sizeComment.height)];
    [self.movieName setFrame:CGRectMake(10,2, wScreen-20, 25)];
    self.movieName.font = TextFont;
    
    
    CGFloat imgW = (viewW - 30)/4;
    
    [self.timeBtn setFrame:CGRectMake(viewW - 105, self.imageHeight,100, 20)];
    [self.carview setFrame:CGRectMake(10, CGRectGetMaxY(self.comment.frame)+10, wScreen-20, 1)];
    [self.seeBtn setFrame:CGRectMake(20, CGRectGetMaxY(self.comment.frame) + 20, 40, 20)];
    [self.zambiaBtn setFrame:CGRectMake(imgW+30, CGRectGetMaxY(self.comment.frame) + 20, 40, 20)];
    [self.answerBtn setFrame:CGRectMake(imgW*2+40, CGRectGetMaxY(self.comment.frame) + 20, 40, 20)];
    [self.screenBtn setFrame:CGRectMake(imgW*3+50, CGRectGetMaxY(self.comment.frame) + 20, 40, 20)];
    [self.commentview setFrame:CGRectMake(0,self.imageHeight - 30,wScreen, 30)];
    self.cellHeight = CGRectGetMaxY(self.zambiaBtn.frame) + 20;
    
}

-(CGFloat)getHeight
{
    CGFloat viewW = self.bounds.size.width;
    
    NSLog(@"%f",self.imageHeight,nil);
    
    //    [self.movieImg setFrame:CGRectMake(5, 5, viewW - 10, 170)];
    
    [self.userImg setFrame:CGRectMake(10, 10, 40, 40)];
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0]};
    CGSize sizeN = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize sizeName = [self.nikeName.text boundingRectWithSize:sizeN options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [self.nikeName setFrame:CGRectMake(55,self.imageHeight, sizeName.width, sizeName.height)];
    
    
    
    CGSize sizeComment = [self sizeWithText:self.comment.text font:TextFont maxSize:CGSizeMake(viewW - 20, MAXFLOAT)];
    [self.comment setFrame:CGRectMake(10, self.imageHeight + 30, sizeComment.width, sizeComment.height)];
    [self.movieName setFrame:CGRectMake(10,2, wScreen-20, 25)];
    self.movieName.font = TextFont;
    
    
    CGFloat imgW = (viewW - 30)/4;
    
    [self.timeBtn setFrame:CGRectMake(viewW - 105, self.imageHeight, 100, 20)];
    [self.carview setFrame:CGRectMake(10, CGRectGetMaxY(self.comment.frame)+10, wScreen-20, 1)];
    [self.seeBtn setFrame:CGRectMake(20, CGRectGetMaxY(self.comment.frame) + 20, 40, 20)];
    [self.zambiaBtn setFrame:CGRectMake(imgW+30, CGRectGetMaxY(self.comment.frame) + 20, 40, 20)];
    [self.answerBtn setFrame:CGRectMake(imgW*2+40, CGRectGetMaxY(self.comment.frame) + 20, 40, 20)];
    [self.screenBtn setFrame:CGRectMake(imgW*3+50, CGRectGetMaxY(self.comment.frame) + 20, 40, 20)];
    [self.commentview setFrame:CGRectMake(0,self.imageHeight - 30,wScreen, 30)];
    CGFloat cellHeight = CGRectGetMaxY(self.zambiaBtn.frame) + 20;
    return cellHeight;
}

- (void)setup: (DingGeModel *)model{

    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [userDef stringForKey:@"userID"];
    
    self.zambiaBtn.selected = NO;
  
    for (NSDictionary * dict in model.voteBy) {
        if ([dict[@"id"] isEqual:userId]) {
            self.zambiaBtn.selected = YES;
            break;
        }
    }

    
    
    
    self.tagEditorImageView = [[YXLTagEditorImageView alloc]initWithImage:[UIImage imageNamed:@"myBackImg.png"] imageEvent:ImageHaveNoEvent];
    UITableView *tableview = (UITableView *)self.superview;
    self.tagEditorImageView.viewC = (UIViewController *)tableview.delegate;
    self.tagEditorImageView.userInteractionEnabled=YES;
    self.tagsArray = [[NSMutableArray alloc] init];
    self.coordinateArray = [[NSMutableArray alloc] init];
    self.tagsArray = model.tags;
    self.coordinateArray = model.coordinates;
    
//    [self.timeBtn setTitle:model.createdAt forState:UIControlStateNormal];
//    self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    //计算比例
    //    float height = self.tagEditorImageView.imagePreviews.image.size.height;
    //可以从imagePreviews.image.size，看到设置的是280，在没有编辑的时候
//    float alpha = 1;
//    for (NSInteger i = 0; i < [self.tagsArray count];i++) {
//        NSDictionary *tag = [self.tagsArray objectAtIndex:i];
//        NSDictionary *coordinate = [self.coordinateArray objectAtIndex:i];
//        float pointX = [coordinate[@"x"] floatValue];
//        float pointY = [coordinate[@"y"] floatValue] * alpha;
//        NSString *textString = tag[@"name"];
//        NSString *directionString = coordinate[@"direction"];
//        if([directionString isEqualToString:@"left"])
//        {
//            [self.tagEditorImageView addTagViewText:textString Location:CGPointMake(pointX,pointY) isPositiveAndNegative:YES];
//        }
//        else
//        {
//            [self.tagEditorImageView addTagViewText:textString Location:CGPointMake(pointX,pointY) isPositiveAndNegative:NO];
//        }
//        
//    }
    
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.userImg setImage:self.userImg.image];
        //头像圆形
        self.userImg.layer.masksToBounds = YES;
        self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2;
        //头像边框
        self.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userImg.layer.borderWidth = 1.5;
    }];
    
    
    self.tagEditorImageView.frame = CGRectMake(0, 0, wScreen, self.imageHeight);
    self.tagEditorImageView.imagePreviews.frame = CGRectMake(0, 0, wScreen, self.imageHeight);
    
    
    
    [self.contentView addSubview:self.tagEditorImageView];
  

    
//    self.commentview = [[UIView alloc]initWithFrame:CGRectMake(0,self.imageHeight - 30,wScreen, 30)];
    self.commentview = [[UIView alloc] init];
    self.commentview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.contentView addSubview:self.commentview];
    
    
    [self.commentview addSubview:self.userImg];
    [self.commentview addSubview:self.movieName];
    
    
    
    
    
    [self.timeBtn setTitle:model.time forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    self.timeBtn.titleLabel.font  = TimeFont;
    self.timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);

    
    
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
    
    
    self.movieName.text =[NSString stringWithFormat:@"《%@》",model.movie.title];
    
    
    self.nikeName.text = model.user.nickname;
    self.comment.text = model.content;
 
}

- (void)setTags{
    
    for (NSInteger i = 0; i < [self.tagsArray count];i++) {
        NSDictionary *tag = [self.tagsArray objectAtIndex:i];
        NSDictionary *coordinate = [self.coordinateArray objectAtIndex:i];
        float pointX = [coordinate[@"x"] floatValue] * self.ratio;
        float pointY = [coordinate[@"y"] floatValue] * self.ratio;
        NSLog(@"wScreen: %f",wScreen,nil);
        NSLog(@"ratio: %f",self.ratio,nil);
        NSLog(@"picw: %f",self.tagEditorImageView.imagePreviews.image.size.width,nil);
        NSLog(@"pich: %f",self.tagEditorImageView.imagePreviews.image.size.height,nil);
        
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

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end

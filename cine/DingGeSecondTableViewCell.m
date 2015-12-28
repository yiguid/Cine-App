//
//  DingGeSecondTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "DingGeSecondTableViewCell.h"
#import "UIImageView+WebCache.h"


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
        //电影图片
        self.movieImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.movieImg];
        //用户图片
        self.userImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.userImg];
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
        [self.contentView addSubview:self.movieName];

  
      

        
        //时间
        self.time = [[UILabel alloc]init];
        self.time.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.time];
        
        [self.time setTextColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0]];
        //时间图片
        self.timeImg = [[UIImageView alloc]init];
        self.timeImg.image = [UIImage imageNamed:@"时间2x.png"];
        [self.contentView addSubview:self.timeImg];
        
        self.comment = [[UILabel alloc]init];
        self.comment.numberOfLines = 0;
        self.comment.textColor = [UIColor colorWithRed:143/255.0 green:139/255.0 blue:136/255.0 alpha:1];
        [self.contentView addSubview:self.comment];
        
        
        
        
        self.foortitle = [[UILabel alloc]init];
        [self.contentView addSubview:self.foortitle];
        
        
        
    }
    
    return self;
}

- (void)layoutSubviews{
    CGFloat viewW = self.bounds.size.width;
  
   
    
    [self.movieImg setFrame:CGRectMake(5, 5, viewW - 10, 170)];
    
    [self.userImg setFrame:CGRectMake(10, 170, 60, 60)];
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0]};
    CGSize sizeN = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize sizeName = [self.nikeName.text boundingRectWithSize:sizeN options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [self.nikeName setFrame:CGRectMake(75, 200, sizeName.width, sizeName.height)];
    
    [self.time setFrame:CGRectMake(viewW - 70, 200, 60, 20)];
    [self.timeImg setFrame:CGRectMake(viewW - 90, 200, 20, 20)];
    
    
    CGSize sizeM = CGSizeMake(viewW - 15, MAXFLOAT);
    CGSize sizeComment = [self.comment.text boundingRectWithSize:sizeM options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [self.comment setFrame:CGRectMake(10, 250, sizeComment.width, sizeComment.height)];
    
    [self.foortitle setTextColor:[UIColor colorWithRed:110/255.0 green:108/255.0 blue:106/255.0 alpha:1]];

    [self.foortitle setFrame:CGRectMake(10, sizeComment.height + 260, viewW, 20)];
    [self.movieName setFrame:CGRectMake(5,2, 300, 25)];
    
    
}

- (void)setup: (DingGeModel *)model{
    [self.movieImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@""]];
    self.userImg.image = [UIImage imageNamed:@"avatar.png"];
    
    
   
    
    //
    //     DingGeModel *model = self.modelFrame.model;
    
    //配图
    self.movieImg.image = [UIImage imageNamed:model.movieImg];
    
    UIImageView *image = [[UIImageView alloc] init];
    [image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"myBackImg.png"]];
    self.tagEditorImageView = [[YXLTagEditorImageView alloc]initWithImage:image.image imageEvent:ImageHaveNoEvent];
    UITableView *tableview = (UITableView *)self.superview;
    self.tagEditorImageView.viewC = (UIViewController *)tableview.delegate;
    self.tagEditorImageView.userInteractionEnabled=YES;
    self.tagsArray = [[NSMutableArray alloc] init];
    self.coordinateArray = [[NSMutableArray alloc] init];
    self.tagsArray = model.tags;
    self.coordinateArray = model.coordinates;
    
//        [self.timeBtn setTitle:model.createdAt forState:UIControlStateNormal];
//        self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    //计算比例
    //    float height = self.tagEditorImageView.imagePreviews.image.size.height;
    //可以从imagePreviews.image.size，看到设置的是280，在没有编辑的时候
    float alpha = 190.0 / 280.0;
    for (NSInteger i = 0; i < [self.tagsArray count];i++) {
        NSDictionary *tag = [self.tagsArray objectAtIndex:i];
        NSDictionary *coordinate = [self.coordinateArray objectAtIndex:i];
        float pointX = [coordinate[@"x"] floatValue];
        float pointY = [coordinate[@"y"] floatValue] * alpha;
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
    
    self.tagEditorImageView.frame = CGRectMake(0, 0, wScreen, 190);
    self.tagEditorImageView.imagePreviews.frame = CGRectMake(0, 0, wScreen, 190);
    
    [self.contentView addSubview:self.tagEditorImageView];
    //    [self.contentView bringSubviewToFront:self.tagEditorImageView];
    //头像在上
    [self.contentView addSubview:self.userImg];
    
    
    
    self.tagEditorImageView.frame = CGRectMake(0, 0, wScreen, 190);
    self.tagEditorImageView.imagePreviews.frame = CGRectMake(0, 0, wScreen, 190);
    
    
    [self.contentView addSubview:self.tagEditorImageView];
    [self.contentView bringSubviewToFront:self.tagEditorImageView];
      //头像在上
    [self.contentView addSubview:self.userImg];
    
//       UIView * commentview = [[UIView alloc]initWithFrame:CGRectMake(0,160,wScreen, 30)];
//    commentview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    [self.tagEditorImageView addSubview:commentview];
//    //    [self.tagEditorImageView addSubview:self.userImg];
//    [commentview addSubview:self.movieName];
// 
    
    
    
    
    
    
   
    
    
    
    self.movieName.text = model.movie.title;
    self.nikeName.text = model.user.nickname;
    self.time.text = model.createdAt;
    self.comment.text = model.content;
    self.foortitle.text = @"评论列表";
}


@end

//
//  ShuoXiContentTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

//#import "ShuoXiContentTableViewCell.h"
//#import "ShuoXiContentModel.h"
//
//@implementation ShuoXiContentTableViewCell
//
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
//
//
//
//- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    
//    self.movieImg = [[UIImageView alloc]init];
//    [self.contentView addSubview:self.movieImg];
//    
//    self.userImg = [[UIImageView alloc]init];
//    [self.contentView addSubview:self.userImg];
//    
//    self.nikeName = [[UILabel alloc]init];
//    [self.contentView addSubview:self.nikeName];
//    
//    self.message = [[UILabel alloc]init];
//    self.message.numberOfLines = 0;
//    [self.contentView addSubview:self.message];
//    
//    self.mark = [[UILabel alloc]init];
//    [self.contentView addSubview:self.mark];
//    
//    self.time = [[UILabel alloc]init];
//    [self.contentView addSubview:self.time];
//    
//    self.daRen = [[UIButton alloc]init];
//    [self.daRen.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [self.contentView addSubview:self.daRen];
//    
//    self.zambiaBtn = [[UIButton alloc]init];
//    [self.contentView addSubview:self.zambiaBtn];
//    
//    self.answerBtn = [[UIButton alloc]init];
//    [self.contentView addSubview:self.answerBtn];
//    
//    self.screenBtn = [[UIButton alloc]init];
//    [self.contentView addSubview:self.screenBtn];
//    
//    return self;
//}
//
//- (void)layoutSubviews{
//    CGFloat viewW = self.bounds.size.width;
//    
//    
//    
//    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
//    
//    CGSize sizeM = CGSizeMake(viewW - 20, MAXFLOAT);
//    
//    CGSize messageSize =  [self.message.text boundingRectWithSize:sizeM options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
//    NSLog(@"%f",messageSize.height);
//    [self.message setFrame:CGRectMake(10,5, viewW - 20, messageSize.height + 40 )];
//    
//    CGFloat movieImgY = messageSize.height + 40;
//    CGFloat movieImgH = 0;
//    
//    if (self.model.movieImg) {
//        
//        movieImgH = 160;
//        
//        [self.movieImg setFrame:CGRectMake(10, movieImgY, viewW - 20, movieImgH)];
//        
//        self.movieImg.hidden = NO;
//    }
//    else{
//        self.movieImg.hidden = YES;
//    }
//  //  [self.movieImg setFrame:CGRectMake(10, movieImH, viewW - 20, 160)];
//    
//    
//    CGFloat userImgH = movieImgH + movieImgY + 10;
//    
//    [self.userImg setFrame:CGRectMake(10, userImgH, 40, 40)];
//    
//    CGSize sizeN = CGSizeMake(MAXFLOAT, MAXFLOAT);
//    NSDictionary *dictN = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0]};
//    CGSize sizeName = [self.nikeName.text boundingRectWithSize:sizeN options:NSStringDrawingUsesLineFragmentOrigin attributes:dictN context:nil].size;
//    
//    [self.nikeName setFrame:CGRectMake(80, userImgH + 10, sizeName.width, sizeName.height)];
//    if (self.model.daRen != nil) {
//        self.daRen.hidden = NO;
//        [self.daRen setFrame:CGRectMake(sizeName.width + 90, userImgH + 5, 60, 30)];
//        [self.daRen setFrame:CGRectMake(sizeName.width + 90, userImgH + 5, 60, 30)];
//    }
//    else{
//        self.daRen.hidden = YES;
//    }
//    
//    CGFloat markY = userImgH + sizeName.height + 20;
//    
//    [self.mark setFrame:CGRectMake(10, markY, viewW - 20, 30)];
//    
//    CGFloat imgW = (self.bounds.size.width - 35) / 4;
//    CGFloat imgH = 20;
//    CGFloat imgY = markY + 50;
//
//    [self.zambiaBtn setFrame:CGRectMake(10, imgY, imgW, imgH)];
//    
//    [self.answerBtn setFrame:CGRectMake(15 + imgW, imgY, imgW, imgH)];
//    
//    [self.screenBtn setFrame:CGRectMake(20 + imgW * 2, imgY, imgW, imgH)];
//    
//    [self.time setFrame:CGRectMake(25 + imgW * 3, imgY, imgW, imgH)];
//
//    NSLog(@"layoutSubviews");
//
//}
//
//
//- (void) setup:(ShuoXiContentModel *)model{
//    
//    self.model = model;
//    
//    NSLog(@"setup");
//    
//    self.movieImg.image = [UIImage imageNamed:model.movieImg];
//    self.userImg.image = [UIImage imageNamed:model.userImg];
//    self.nikeName.text = model.nickName;
//    self.message.text = model.message;
//    self.mark.text = model.mark;
//    [self.daRen setImage:[UIImage imageNamed:model.daRenImg] forState:UIControlStateNormal];
//    [self.daRen setTitle:model.daRen forState:UIControlStateNormal];
//    [self.daRen setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
//    
//    [self.zambiaBtn setImage:[UIImage imageNamed:model.zambiaImg] forState:UIControlStateNormal];
//    [self.zambiaBtn setTitle:model.zambiaCount forState:UIControlStateNormal];
//    [self.zambiaBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
//    
//    [self.answerBtn setImage:[UIImage imageNamed:model.answerImg] forState:UIControlStateNormal];
//    [self.answerBtn setTitle:model.answerCount forState:UIControlStateNormal];
//    [self.answerBtn setTitleColor:[UIColor colorWithRed:184.0/255 green:188.0/255 blue:194.0/255 alpha:1.0] forState:UIControlStateNormal];
//    
//    [self.screenBtn setImage:[UIImage imageNamed:model.screenImg] forState:UIControlStateNormal];
//    
//    self.time.text = model.time;
//}
//
//@end

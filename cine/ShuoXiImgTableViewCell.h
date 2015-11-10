//
//  ShuoXiImgTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShuoXiImgModel;

@interface ShuoXiImgTableViewCell : UITableViewCell

@property(nonatomic,strong) ShuoXiImgModel *model;

@property(nonatomic,strong) UIImageView *movieImg;
@property(nonatomic,strong) UIView *messageView;
@property(nonatomic,strong) UILabel *message;
@property(nonatomic,strong) UILabel *movieName;
@property(nonatomic,strong) UILabel *foortitle;

-(void) setup :(ShuoXiImgModel *)model;



@end

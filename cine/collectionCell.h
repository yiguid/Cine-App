//
//  collectionCell.h
//  cine
//
//  Created by Mac on 15/11/20.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Model;
@interface collectionCell : UICollectionViewCell
@property(nonatomic,strong) Model *model;
@property(nonatomic,strong) UIImageView *imageview;
@property(nonatomic,strong) UILabel *title;
@end

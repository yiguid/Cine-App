//
//  CollectionCellView.h
//  cine
//
//  Created by Mac on 15/11/23.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionModel;
@interface CollectionCellView : UICollectionViewCell

@property(nonatomic,strong) CollectionModel *model;
@property(nonatomic,strong) UIImageView *img;
@property(nonatomic,strong) UILabel *name;

- (void)setup :(CollectionModel *)model;

@end

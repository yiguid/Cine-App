//
//  PhotoAlbumCollectionViewCell.h
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAlbumCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *phoneImageView;
@property(nonatomic,strong)UIImageView *chooseImageView;

@property(nonatomic,strong)NSString *urlString;

@end

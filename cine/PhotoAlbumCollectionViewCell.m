//
//  PhotoAlbumCollectionViewCell.m
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "PhotoAlbumCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PhotoAlbumCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if(self != nil)
    {
        [self _initView] ;
    }
    return self ;
}

- (void)_initView
{
    _phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, (wScreen-20)/3.0, (wScreen-20)/3.0)] ;
    _phoneImageView.contentMode = UIViewContentModeScaleAspectFit ;
    [self.contentView addSubview:_phoneImageView] ;
}

- (void)layoutSubviews
{
    if([self.urlString isEqualToString:@"2011102267331457.jpg"])
    {
        _phoneImageView.image = [UIImage imageNamed:@"2011102267331457.jpg"] ;
        
    }
    else
    {
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        NSURL *url=[NSURL URLWithString:self.urlString];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
            
            CGImageRef ref = [[asset  defaultRepresentation]fullScreenImage];
            
            UIImage *image=[UIImage imageWithCGImage:ref];
            _phoneImageView.image=image;
            
        }failureBlock:^(NSError *error) {
            NSLog(@"error=%@",error);
        }];
    }
}

@end

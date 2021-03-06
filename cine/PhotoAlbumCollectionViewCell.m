//
//  PhotoAlbumCollectionViewCell.m
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "PhotoAlbumCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"

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
    _phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (wScreen)/3.0, (wScreen)/3.0)] ;
    _phoneImageView.contentMode = UIViewContentModeScaleToFill ;
    _phoneImageView.backgroundColor = [UIColor clearColor] ;
    [self.contentView addSubview:_phoneImageView] ;
    
    _chooseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(wScreen/3.0 - 30, 10, 20, 20)];
    _chooseImageView.image = [UIImage imageNamed:@"image_not_choose.png"];
    _chooseImageView.highlightedImage = [UIImage imageNamed:@"image_choose.png"];
    [self.contentView addSubview:_chooseImageView];
}

- (void)layoutSubviews
{
    if([self.urlString isEqualToString:@"fabuCamera.jpg"])
    {
        _phoneImageView.image = [UIImage imageNamed:@"fabuCamera.jpg"] ;
    }
    else if([self.urlString containsString:@"http://"]){
        [_phoneImageView sd_setImageWithURL:[NSURL URLWithString:self.urlString] placeholderImage:nil];
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

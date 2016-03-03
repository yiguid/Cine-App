//
//  PublishViewController.h
//  cine
//
//  Created by Deluan on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"
#import "MyDropdown.h"
#import "HMSegmentedControl.h"
#import "PECropView.h"
#import "PECropViewController.h"
#import "RecommendPublishViewController.h"

@interface PublishViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PECropViewControllerDelegate>

{
    UIImageView *_bgviewImage;
//    UILabel *_albumLabel;
//    UILabel *_gallerylabel;
    UICollectionView *_collectionView;
    
}

@property (nonatomic, copy) void (^popBlock)(NSString *string);


// 获取相册图片的参数
// 装图片地址的数组
@property(nonatomic,strong)NSMutableArray *images;

@property(nonatomic,strong)PECropView *cropView;

@property(nonatomic,strong)NSString *urlString;

@property(nonatomic,strong)MovieModel *movie;

@property(nonatomic,strong)MyDropdown *dd;

@property(nonatomic,strong)HMSegmentedControl *segmentedControl;

@property(nonatomic,strong)NSString *publishType;

@property(nonatomic,strong)NSString *activityId;

@property(nonatomic,strong)UIImagePickerController *imagePickerVC;

@property(nonatomic,strong)RecommendPublishViewController *recPublishVC;

@property(nonatomic,strong)NSString *moviestring;


@end

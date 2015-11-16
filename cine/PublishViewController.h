//
//  PublishViewController.h
//  cine
//
//  Created by Deluan on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishViewController : UIViewController<UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

{
    UIImageView *_bgviewImage ;
//    UILabel *_albumLabel ;
//    UILabel *_gallerylabel ;
    UICollectionView *_collectionView ;
    
}

@property (nonatomic, copy) void (^popBlock)(NSString *string);


// 获取相册图片的参数
// 装图片地址的数组
@property(nonatomic,strong)NSMutableArray *images ;

@end

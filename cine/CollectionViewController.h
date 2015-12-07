//
//  CollectionViewController.h
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@end

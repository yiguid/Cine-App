//
//  CollectionViewController.h
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface CollectionViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, weak) SDRefreshFooterView * refreshFooter;
@property (nonatomic, strong)UIImageView *noDataImageView;
@property (nonatomic, strong)UILabel * noDataLabel;
@end

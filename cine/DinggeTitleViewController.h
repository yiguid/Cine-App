//
//  DinggeTitleViewController.h
//  cine
//
//  Created by wang on 15/12/14.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface DinggeTitleViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>;


@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic, weak) SDRefreshFooterView * refreshFooter;
@property (nonatomic,strong)NSString * firstdingge;

@property (nonatomic,strong)NSString * tagTitle;
@property (nonatomic,strong)NSString * tagId;

@end

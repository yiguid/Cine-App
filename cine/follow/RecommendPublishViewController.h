//
//  RecommendPublishViewController.h
//  cine
//
//  Created by Guyi on 15/12/14.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface RecommendPublishViewController : UIViewController<UITextViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate>

// 传进来的图片
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)NSString *imageQiniuUrl;
// 图片的地址
@property(nonatomic,strong)NSString *urlString ;

@property(nonatomic,strong)MovieModel *movie;

@property(nonatomic,strong)UIImageView *bgImageView;

@property(nonatomic,strong) MBProgressHUD *hud;

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *movieName;

@property (strong, nonatomic) UICollectionView *recommendTagCollectionView;
// 存放tagID的数组
@property(nonatomic,strong)NSMutableArray *recommendTagIDArray;
@property(nonatomic,strong)NSMutableArray *dataSource;


//// 图片的路径
//@property(nonatomic,strong)NSString *imageQiniuUrl;

@property(nonatomic,strong)NSString *publishType;

@property(nonatomic,strong)NSString *activityId;



@end

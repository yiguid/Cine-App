//
//  CollectionViewController.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "MovieSecondViewController.h"
#import "MovieModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "RestAPI.h"



@interface CollectionViewController (){

     NSString * str;
}
@property UIScrollView *_scrollView;
@property NSMutableArray *dataSource;
@property MBProgressHUD *hud;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    str = [[NSString alloc]init];
    str = @"12";
    
   
    
    self.title = @"我的收藏";
//    self.view.backgroundColor = [UIColor whiteColor];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.collectionView addSubview:self.hud];
    _hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    self.hud.labelText = @"获取电影数据";
    [self.hud show:YES];
 //   [self createCollectionView];
    
    //   self.dataSource = [[NSMutableArray alloc]init];
    [MovieModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    [self loadMovieData];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, wScreen, hScreen - 44) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(wScreen/2-50,wScreen/4,100, 100)];
    self.noDataImageView.image=[UIImage imageNamed:@"图层-13@2x.png"];
    [self.collectionView addSubview:self.noDataImageView];
    
    self.noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,110+wScreen/4,wScreen-40, 30)];
    self.noDataLabel.text = @"暂时还没有收藏消息哦";
    self.noDataLabel.font = NameFont;
    self.noDataLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    self.noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self.collectionView addSubview:self.noDataLabel];

    
    
    [self setupHeader];
    [self setupFooter];
}

-(void)loadMovieData{
    NSLog(@"loadMovieData",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    ///auth/:authId/favroiteMovies
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":str};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/favoriteMovies",USER_AUTH_API, userId];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求返回,%@",responseObject);
        __weak CollectionViewController *weakSelf = self;
        NSArray *arrModel = [MovieModel mj_objectArrayWithKeyValuesArray:responseObject];
        weakSelf.dataSource = [arrModel mutableCopy];
        
        if (weakSelf.dataSource.count==0) {
            self.noDataImageView.hidden = NO;
            self.noDataLabel.hidden = NO;
            
        }
        else{
            self.noDataImageView.hidden = YES;
            self.noDataLabel.hidden = YES;
        
        }
        

        
        
        
        [weakSelf.collectionView reloadData];
        //        [self.hud hide:YES afterDelay:1];
        [weakSelf.hud hide:YES];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell sizeToFit];
    MovieModel *movie = self.dataSource[indexPath.row];
    cell.layer.borderColor=[UIColor grayColor].CGColor;
    cell.layer.borderWidth=0.3;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:movie.cover] placeholderImage:[UIImage imageNamed:@"movieCover.png"]];
    cell.title.text = movie.title;
    
    
//    if (self.dataSource.count==0) {
//        
//        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3@2x.png"]];
//        [collectionView setBackgroundView:backgroundView];
//    }
    

    
    return cell;
}

//定义每个UICollectionView 的大小（返回CGSize：宽度和高度）
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((wScreen - 80)/3,hScreen/4);
    
}
//定义每个UICollectionView 的间距（返回UIEdgeInsets：上、左、下、右）
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(20,20,20, 20);
    
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Movie Collection Cell Clicked %ld", indexPath.row);
    MovieSecondViewController *movieController = [[MovieSecondViewController alloc]init];
    
    MovieModel *movie = self.dataSource[indexPath.row];
    movieController.name = movie.title;
    movieController.ID = movie.ID;
    
    movieController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:movieController animated:YES];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = YES;
    
}






- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.collectionView];
    
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self loadMovieData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    
}


- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.collectionView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh
{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        NSInteger a = [str intValue];
        a = a + a;
        str = [NSString stringWithFormat:@"%ld",a];
        

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        ///auth/:authId/favroiteMovies
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        NSString *userId = [userDef stringForKey:@"userID"];
        NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":str};
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/favoriteMovies",USER_AUTH_API, userId];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求返回,%@",responseObject);
            __weak CollectionViewController *weakSelf = self;
            NSArray *arrModel = [MovieModel mj_objectArrayWithKeyValuesArray:responseObject];
            weakSelf.dataSource = [arrModel mutableCopy];
            [weakSelf.collectionView reloadData];
            //        [self.hud hide:YES afterDelay:1];
            [weakSelf.hud hide:YES];
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"请求失败,%@",error);
             }];

        
        [self.collectionView reloadData];
        
        [self.refreshFooter endRefreshing];
        
        
        
    });
}





@end

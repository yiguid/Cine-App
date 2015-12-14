//
//  DinggeTitleViewController.m
//  cine
//
//  Created by wang on 15/12/14.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "DinggeTitleViewController.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "RestAPI.h"
#import "DingGeModel.h"
#import "DingGeModelFrame.h"
#import "DinggeSecondViewController.h"
#import "DingGeSecondTableViewCell.h"
#import "MovieCollectionViewCell.h"
#import "MovieViewController.h"
#import "MovieTableViewController.h"
@interface DinggeTitleViewController ()


@property UIScrollView * scrollView;
@property NSMutableArray * dataSource;

@end

@implementation DinggeTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.title = @"标签";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    imageView.image = [UIImage imageNamed:@"backimg.png"];
    [self.view addSubview:imageView];
    
    UIButton *guanzhuBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, 50, 240, 30)];
    guanzhuBtn.backgroundColor = [UIColor colorWithRed:36/255.0 green:131/255.0 blue:254/255.0 alpha:1.0];
    //[guanzhuBtn addTarget:self action:@selector(guanzhubtn:) forControlEvents:UIControlEventTouchUpInside];
     [guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    [guanzhuBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [self.view addSubview:guanzhuBtn];
   
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, wScreen, hScreen) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];


    
    [self viewDidLoadData];
   
}

-(void)viewDidLoadData{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];

    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    
    [manager GET:DINGGE_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求返回,%@",responseObject);
        __weak DinggeTitleViewController *weakSelf = self;
        NSArray *arrModel = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
        weakSelf.dataSource = [arrModel mutableCopy];
        [weakSelf.collectionView reloadData];
        //        [self.hud hide:YES afterDelay:1];
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    

    
    
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    DingGeModel *model = self.dataSource[indexPath.row];
    cell.layer.borderColor=[UIColor grayColor].CGColor;
    cell.layer.borderWidth=0.3;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"movieCover.png"]];
    
    cell.title.text = model.movie.title;
    
    
  
    
    return cell;
}

//定义每个UICollectionView 的大小（返回CGSize：宽度和高度）
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((wScreen - 80)/2, 160);
    
}
//定义每个UICollectionView 的间距（返回UIEdgeInsets：上、左、下、右）
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(20, 20, 20, 20);
    
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    DingGeModel *model = self.dataSource[indexPath.row];
    dingge.dingimage = model.image;
    dingge.DingID = model.ID;
    
   
    
    [self.navigationController pushViewController:dingge animated:YES];
    
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

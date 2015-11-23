//
//  CollectionViewController.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CollectionViewController.h"


@interface CollectionViewController ()
@property UIScrollView *_scrollView;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //显示图片方法
    [self showPicWithCount:20];
 //   [self createCollectionView];
    
 //   self.dataSource = [[NSMutableArray alloc]init];
 //   [self loadData];

   
}

- (void)showPicWithCount :(int) count{
    
    
    CGFloat viewW = self.view.frame.size.width;
    CGFloat picW = (viewW - 80) / 3;
    CGFloat picH = 150;
    //间隙距离
    CGFloat space = 20;
    
    int n = 20;
    
    int modle = n % 3;
    
    int column = n / 3;
    if (modle != 0 ) {
        column += 1;
    }
    
    
    UIScrollView *scrollview = [[UIScrollView alloc]init];
    scrollview.frame = CGRectMake(0, 0, viewW, self.view.frame.size.height);
    [self.view addSubview:scrollview];
    scrollview.contentSize =CGSizeMake(0, (column + 1) * (space + picH) +space);
    
    for (int i = 0; i < column; i++) {
        if (i == column - 1) {
            for (int j = 0; j < modle; j++) {
                UIImageView *pic = [[UIImageView alloc]initWithFrame:CGRectMake(space + (picW + space) * j, space + (picH + space) * i, picW, picH)];
                pic.image = [UIImage imageNamed:@"shuoxiImg.png"];
                
                [scrollview addSubview:pic];
            }
        }
        else{
            for (int j = 0; j < 3; j++) {
                UIImageView *pic = [[UIImageView alloc]initWithFrame:CGRectMake(space + (picW + space) * j, space + (picH + space) * i, picW, picH)];
                pic.image = [UIImage imageNamed:@"shuoxiImg.png"];
                [scrollview addSubview:pic];
                
            }
            
        }
    }
    
    __scrollView = scrollview;
    
    
}


////创建 UICollectionView
//- (void)createCollectionView{
//    
//    //确定是水平滚动，还是垂直滚动
//    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    
//    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, wScreen, hScreen) collectionViewLayout:flowLayout];
//    self.collectionView.dataSource=self;
//    self.collectionView.delegate=self;
//    [self.collectionView setBackgroundColor:[UIColor clearColor]];
//    
//    //注册Cell，必须要有
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
//    
//
//    [self.view addSubview:self.collectionView];
//}
//
//- (void)loadData{
//    for (int i = 0; i < 10; i++ ) {
//        
//        //创建MLStatus模型
//        CollectionModel *model = [[CollectionModel alloc]init];
//        model.img = [NSString stringWithFormat:@"shuoxiImg.png"];
//        model.name = @"好好好";
//        [self.dataSource addObject:model];
//        
//    }
//    
//}
//
//
//#pragma mark -- UICollectionViewDataSource
//
////定义展示的UICollectionViewCell的个数
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 15;
//}
//
////定义展示的Section的个数
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 3;
//}
//
//
//
////每个UICollectionView展示的内容
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//  //  static NSString * CellIdentifier = @"UICollectionViewCell";
//    CollectionCellView * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell"forIndexPath:indexPath];
//    
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
////    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
////    label.textColor = [UIColor redColor];
////    label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//    
////    if (cell ==nil) {
////        cell = [[CollectionCellView alloc]init];
////    }
//    cell.img.image = [UIImage imageNamed:@"shuoxiImg.png"];
//    cell.name.text = @"好好好";
//    
// //   [cell setup:self.dataSource[indexPath.row]];
//
////    for (id subView in cell.contentView.subviews) {
////        [subView removeFromSuperview];
////    }
////    [cell.contentView addSubview:label];
//    return cell;
//}
//
//#pragma mark --UICollectionViewDelegateFlowLayout
//
////定义每个Item 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(100, 150);
//}
//
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}
//
//#pragma mark --UICollectionViewDelegate
//
////UICollectionView被选中时调用的方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
//    cell.backgroundColor = [UIColor greenColor];
////    NSLog(@"item======%d",indexPath.item);
////    NSLog(@"row=======%d",indexPath.row);
////    NSLog(@"section===%d",indexPath.section);
//}
//
////返回这个UICollectionView是否可以被选择
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
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

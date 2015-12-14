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
    [guanzhuBtn addTarget:self action:@selector(guanzhubtn:) forControlEvents:UIControlEventTouchUpInside];
     [guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    [guanzhuBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [self.view addSubview:guanzhuBtn];
   
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, wScreen, hScreen - 64) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)guanzhubtn:(id)sender{


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

//
//  RecommendPublishViewController.m
//  cine
//
//  Created by Guyi on 15/12/14.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "RecommendPublishViewController.h"
#import <QiniuSDK.h>
#import "RestAPI.h"
#import "TagModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

@implementation RecommendPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐电影";
    // 创建控件
    [self _initView];
    self.recommendTagIDArray = [[NSMutableArray alloc] init];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"发布中...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    if (![self.publishType isEqualToString:@"shuoxi"])
        self.navigationItem.title = @"推荐电影";
    else
        self.navigationItem.title = @"说戏";
    [self loadTagData];
    

    //键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name: UIKeyboardWillHideNotification object:nil];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    
    
}


///键盘事件
- (void) keyboardShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        self.view.center = CGPointMake(self.view.center.x, keyBoardEndY  - self.view.bounds.size.height/2.0);
    }];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_textView resignFirstResponder];
}



-(void)loadTagData{
    NSLog(@"loadTagData",nil);
    [self.view bringSubviewToFront:self.hud];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = TAG_API;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        __weak RecommendPublishViewController *weakSelf = self;
        NSArray *arrModel = [TagModel mj_objectArrayWithKeyValuesArray:responseObject];
        weakSelf.dataSource = [arrModel mutableCopy];
        [weakSelf.recommendTagCollectionView reloadData];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
}

- (void)_initView
{
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen/2.5)];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.movie.cover] placeholderImage:nil];
    [self.view addSubview:self.bgImageView];
    
    self.movieName = [[UILabel alloc] initWithFrame:CGRectMake(10, self.bgImageView.bottom + 4, wScreen - 20, 20)];
    self.movieName.textAlignment = NSTextAlignmentCenter;
    self.movieName.text = self.movie.title;
    [self.view addSubview:self.movieName];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, self.movieName.bottom + 10, wScreen-20, 200)];
    _textView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    _textView.delegate = self;
    _textView.text = @"我想说";
    _textView.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_textView];
    
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    self.navigationItem.rightBarButtonItem=item;
    
    //tag collection
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((wScreen)/3.0, (wScreen)/3.0);
    flowLayout.minimumInteritemSpacing = 6;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 6;
    
    // 创建瀑布流试图
    //init collection
    self.recommendTagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, hScreen - 100, wScreen,50) collectionViewLayout:flowLayout];
    self.recommendTagCollectionView.dataSource=self;
    self.recommendTagCollectionView.delegate=self;
    self.recommendTagCollectionView.showsHorizontalScrollIndicator = NO;
    [self.recommendTagCollectionView setBackgroundColor:[UIColor whiteColor]];
    self.recommendTagCollectionView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
    //注册Cell，必须要有
    [self.recommendTagCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:self.recommendTagCollectionView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor lightGrayColor];
    TagModel *tag = self.dataSource[indexPath.row];
    label.text = tag.name;
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:label];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 30);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(6, 6, 6, 6);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //临时改变个颜色，看好，只是临时改变的
    cell.backgroundColor = [UIColor darkGrayColor];
    TagModel *tag = self.dataSource[indexPath.row];
    [self.recommendTagIDArray addObject:tag.tagId];
    NSLog(@"item======%ld",(long)indexPath.item);
    NSLog(@"row=======%ld",(long)indexPath.row);
}

// 取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    TagModel *tag = self.dataSource[indexPath.row];
    [self.recommendTagIDArray removeObject:tag.tagId];
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 设置是否允许取消选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void)publish{
    [self.view bringSubviewToFront:self.hud];
    [self.hud show:YES];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userID = [userDef stringForKey:@"userID"];
    
    
   
    
//    //上传图片到七牛
//    
//    NSString *qiniuToken = [userDef stringForKey:@"qiniuToken"];
//    NSString *qiniuBaseUrl = [userDef stringForKey:@"qiniuDomain"];
//    
//    QNUploadManager *upManager = [[QNUploadManager alloc] init];
//    NSData *data;
//    if (UIImagePNGRepresentation(self.image) == nil) {
//        data = UIImageJPEGRepresentation(self.image, 1);
//    } else {
//        data = UIImagePNGRepresentation(self.image);
//    }
//    
//    [upManager putData:data key:self.urlString token:qiniuToken
//              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                  NSLog(@"qiniu==%@", info);
//                  NSLog(@"qiniu==%@", resp);
//                  self.imageQiniuUrl = [NSString stringWithFormat:@"%@%@",qiniuBaseUrl,resp[@"key"]];
                  //创建定格测试
                  
                  NSString *urlString;
                  if (![self.publishType isEqualToString:@"shuoxi"])
                      urlString = REC_API;
                  else
                      urlString = SHUOXI_API;
                  NSDictionary *parameters;
                  if (![self.publishType isEqualToString:@"shuoxi"])
                     parameters = @{@"content": self.textView.text, @"user": userID, @"movie": self.movie.ID, @"tags": self.recommendTagIDArray};
                  else
                      parameters = @{@"content": self.textView.text,@"title": self.textView.text, @"user": userID, @"movie": self.movie.ID, @"tags": self.recommendTagIDArray,@"activity": self.activityId};
                  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                  //申明返回的结果是json类型
                  manager.responseSerializer = [AFJSONResponseSerializer serializer];
                  //申明请求的数据是json类型
                  manager.requestSerializer=[AFJSONRequestSerializer serializer];
                  
                  [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
                  [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"----create post-------------请求成功 --- %@",responseObject);
                      [self.hud hide:YES];
                      self.hud.labelText = @"发布成功...";//显示提示
                      [self.hud show:YES];
                      [self.hud hide:YES];
                      [self.navigationController popToRootViewControllerAnimated:YES];
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"请求失败 --- %@",error);
                  }];
                  
//              } option:nil];
}

@end

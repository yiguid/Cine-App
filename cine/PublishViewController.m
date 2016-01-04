//
//  PublishViewController.m
//  cine
//
//  Created by Deluan on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "PublishViewController.h"
#import "EditPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoAlbumCollectionViewCell.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
#import "ReviewPublishViewController.h"
#import "RecommendPublishViewController.h"

@interface PublishViewController ()

@end

@implementation PublishViewController

- (instancetype)init
{
    self = [super init];
    if(self != nil)
    {
        self.images = [[NSMutableArray alloc] init];
//        self.images = [[[self.images reverseObjectEnumerator] allObjects] mutableCopy];
//        [_collectionView reloadData];
    }
    return self;
}

// 加载本地图片到数组中的方法
- (void)_loadWebImage
{
    [self.images removeAllObjects];
    //http://fl.limijiaoyin.com:1337/movie/565d4497b9d36ae00e3c3622
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/%@",MOVIE_API,self.movie.ID];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(responseObject[@"screenshots"][0],nil);
             for (NSString *imageURL in responseObject[@"screenshots"]) {
                 [self.images addObject:imageURL];
             }
             [_collectionView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
}

// 加载本地图片到数组中的方法
- (void)_loadImage
{
    [self.images removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @autoreleasepool {
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
                NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
                if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                    NSLog(@"无法访问相册.请设置为打开状态.");
                }else{
                    NSLog(@"相册访问失败.");
                }
            };
            
            ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
                if (result!=NULL) {
                    
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        
                        NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                        [self.images addObject:urlstr];
                        [_collectionView reloadData];
                        //NSLog(@"urlStr is %@",urlstr);
                        /*result.defaultRepresentation.fullScreenImage//图片的大图
                         result.thumbnail                             //图片的缩略图小图
                         //                    NSRange range1=[urlstr rangeOfString:@"id="];
                         //                    NSString *resultName=[urlstr substringFromIndex:range1.location+3];
                         //                    resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                         */
                    }
                }
            };
            
            ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
                
                if (group == nil)
                {
                    
                }
                
                if (group!=nil) {
                    NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                    NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                    
                    NSString *g1=[g substringFromIndex:16 ];
                    NSArray *arr=[[NSArray alloc] init];
                    arr=[g1 componentsSeparatedByString:@","];
                    NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                    if ([g2 isEqualToString:@"Camera Roll"]) {
                        g2=@"相机胶卷";
                    }
//                    NSString *groupName=g2;//组的name
                    
//                    [group enumerateAssetsUsingBlock:groupEnumerAtion];
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:groupEnumerAtion];
                }
                
            };
            
            ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
            [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:libraryGroupsEnumeration
                                 failureBlock:failureblock];
        }
        
    });

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.title = @"选择图片";
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"选择图片";
    self.navigationItem.backBarButtonItem = back;
    
    [self _loadWebImage];
    self.view.backgroundColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
    
    // 创建右上角的按钮
    [self _initRightBar];
    
    // 创建视图
    [self _initView];
    
    self.dd = [[MyDropdown alloc] initWithFrame:CGRectMake(wScreen/2 - 60, 26, 120, 180)];
    self.dd.indexLabel.text = @"定格";
    NSArray* arr=[[NSArray alloc]initWithObjects:@"定格",@"影评",@"推荐电影",nil];
    self.dd.tableArray = arr;
    
    //seg
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"图库", @"相册"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.frame = CGRectMake(0, _bgviewImage.bottom, wScreen, 30);
    self.segmentedControl.selectionIndicatorHeight = 3.0f;
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]};
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    
}






- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"%ld",(long)segmentedControl.selectedSegmentIndex,nil);
    if (segmentedControl.selectedSegmentIndex == 1) {
        [self _loadImage];
    }
    else {
        [self _loadWebImage];
    }
    [_collectionView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (![self.publishType isEqualToString:@"shuoxi"])
        [self.navigationController.view addSubview:self.dd];
//    else
//        [self.navigationController setTitle:@"定格"];
    
    self.tabBarController.tabBar.translucent = YES;
//    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    if (![self.publishType isEqualToString:@"shuoxi"])
        [self.dd removeFromSuperview];
}
// 创建右上角的按钮
- (void)_initRightBar
{

//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 100, 44);
//    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(rightbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"继续" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)];
}
- (void)_initView
{

    _bgviewImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen/2.5)];
    _bgviewImage.image = [UIImage imageNamed:@"2011102267331457.jpg"];
    [self.view addSubview:_bgviewImage];
    
//    // 点击开发相册获取图片
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(10, 300+10, 50, 50);
//    button.backgroundColor = [UIColor redColor];
//    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((wScreen)/3.0, (wScreen)/3.0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    // 创建瀑布流试图
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _bgviewImage.bottom + 30, wScreen, hScreen-_bgviewImage.height-60) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    // 注册单元格
    [_collectionView registerClass:[PhotoAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
    [self.view addSubview:_collectionView];
    
}



#pragma mark - UICollectionView 的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        return self.images.count+1;
    }
    else
        return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        if(indexPath.row == 0)
        {
            cell.urlString = @"2011102267331457.jpg";
        }
        else
        {
            cell.urlString = self.images[indexPath.row - 1];
        }
    }
    else
        cell.urlString = self.images[indexPath.row];
    
    [cell setNeedsLayout];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        if(indexPath.row == 0)
        {
            // 1.创建相册控制器对象
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
            // 判断当前设备是否有摄像头
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                // 打开相机
                imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                // 打开失败提示
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"打开失败" message:@"您的设备没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
        }
        else
        {
            _urlString = self.images[indexPath.row-1];
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            NSURL *url=[NSURL URLWithString:self.images[indexPath.row - 1]];
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                
                CGImageRef ref = [[asset  defaultRepresentation]fullScreenImage];
                
                UIImage *image=[UIImage imageWithCGImage:ref];
                _bgviewImage.image=image;
                
            }failureBlock:^(NSError *error) {
                NSLog(@"error=%@",error);
            }];
        }
    }else {
        NSString *cover = [self.images[indexPath.row] stringByReplacingOccurrencesOfString:@"albumicon" withString:@"photo"];
        [_bgviewImage sd_setImageWithURL:[NSURL URLWithString:cover] placeholderImage:nil];
    }
    
}

//
//// 点击获取图片的点击事件
//#pragma mark -  点击获取图片的点击事件
//- (void)buttonAction:(UIButton *)button
//{
//    // 1.创建相册控制器对象
//    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
//    // 设置代理对象
//    imagePickerVC.delegate = self;
//    // 设置照片的编辑模式
//    imagePickerVC.allowsEditing = YES;
//    // 指定媒体类型
//    // 1.获取相册里面的图片，2.获取相册里面的时候，3.打开照相机，4.打开录像机
//    imagePickerVC.mediaTypes = @[@"public.image"];
//    //    imagePickerVC.mediaTypes = @[@"public.image",@"public.movie"];
//    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    // 3.通过模态视图弹出相册控制器（因为系统的相册控制器是导航控制器）
//    [self presentViewController:imagePickerVC animated:YES completion:nil];
//}
//
//#pragma mark -  相册对象的代理方法
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    // 获取点击的图片
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    // 把图片设置到试图上
//    _bgviewImage.image = image;
//    // 关闭相册控制器
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//
#pragma mark - rightBarButtonAction 右上角点击事件
- (void)rightAction:(UIBarButtonItem *)barButton
{
    NSLog(self.dd.indexLabel.text,nil);
    if (![self.publishType isEqualToString:@"shuoxi"]) {
        
        if ([self.dd.indexLabel.text isEqualToString:@"定格"]) {
            EditPhotoViewController *editPhotoView = [[EditPhotoViewController alloc]init];
            editPhotoView.image = _bgviewImage.image;
            editPhotoView.urlString = self.urlString;
            editPhotoView.movie = self.movie;
            [self.navigationController pushViewController:editPhotoView animated:YES];
        }else if ([self.dd.indexLabel.text isEqualToString:@"影评"]) {
            ReviewPublishViewController *reviewPublishVC = [[ReviewPublishViewController alloc]init];
            reviewPublishVC.image = _bgviewImage.image;
            reviewPublishVC.urlString = self.urlString;
            reviewPublishVC.movie = self.movie;
            [self.navigationController pushViewController:reviewPublishVC animated:YES];
        }else {
            RecommendPublishViewController *recommendPublishVC = [[RecommendPublishViewController alloc]init];
            recommendPublishVC.image = _bgviewImage.image;
            recommendPublishVC.urlString = self.urlString;
            recommendPublishVC.movie = self.movie;
            [self.navigationController pushViewController:recommendPublishVC animated:YES];
        }
    }else {
        RecommendPublishViewController *recommendPublishVC = [[RecommendPublishViewController alloc]init];
        recommendPublishVC.image = _bgviewImage.image;
        recommendPublishVC.urlString = self.urlString;
        recommendPublishVC.movie = self.movie;
        [self.navigationController pushViewController:recommendPublishVC animated:YES];
    }
    
}

@end

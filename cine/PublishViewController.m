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

@interface PublishViewController ()

@end

@implementation PublishViewController

- (instancetype)init
{
    self = [super init] ;
    if(self != nil)
    {
        [self _loadImage] ;
    }
    return self ;
}

// 加载本地图片到数组中的方法
- (void)_loadImage
{
    self.images = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @autoreleasepool {
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
                NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
                if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                    NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
                }else{
                    NSLog(@"相册访问失败.");
                }
            };
            
            ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
                if (result!=NULL) {
                    
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        
                        NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                        [self.images addObject:urlstr];
                        [_collectionView reloadData] ;
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
                    
                    NSString *g1=[g substringFromIndex:16 ] ;
                    NSArray *arr=[[NSArray alloc] init];
                    arr=[g1 componentsSeparatedByString:@","];
                    NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                    if ([g2 isEqualToString:@"Camera Roll"]) {
                        g2=@"相机胶卷";
                    }
                    NSString *groupName=g2;//组的name
                    
                    [group enumerateAssetsUsingBlock:groupEnumerAtion];
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
    
    self.navigationItem.title = @"定格" ;
    self.view.backgroundColor = [UIColor purpleColor] ;
    
    // 创建右上角的按钮
    [self _initRightBar] ;
    
    // 创建试图
    [self _initView] ;

}
// 创建右上角的按钮
- (void)_initRightBar
{

//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
//    rightButton.frame = CGRectMake(0, 0, 100, 44) ;
//    [rightButton setTitle:@"下一步" forState:UIControlStateNormal] ;
//    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
//    [rightButton addTarget:self action:@selector(rightbuttonAction:) forControlEvents:UIControlEventTouchUpInside] ;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)]  ;
}
- (void)_initView
{

    _bgviewImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, wScreen-20, hScreen/2.5)] ;
    _bgviewImage.image = [UIImage imageNamed:@"2011102267331457.jpg"] ;
    [self.view addSubview:_bgviewImage] ;
    
//    // 点击开发相册获取图片
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
//    button.frame = CGRectMake(10, 300+10, 50, 50) ;
//    button.backgroundColor = [UIColor redColor] ;
//    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside] ;
//    [self.view addSubview:button] ;
    
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init] ;
    flowLayout.itemSize = CGSizeMake((wScreen-20)/3.0, (wScreen-20)/3.0) ;
    flowLayout.minimumInteritemSpacing = 5 ;
    flowLayout.minimumLineSpacing = 5 ;
    
    // 创建瀑布流试图
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _bgviewImage.bottom+10, wScreen, hScreen-_bgviewImage.height-60-20) collectionViewLayout:flowLayout] ;
    _collectionView.delegate = self ;
    _collectionView.dataSource = self ;
    _collectionView.backgroundColor = [UIColor grayColor] ;
    
    // 注册单元格
    [_collectionView registerClass:[PhotoAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"] ;
    
    [self.view addSubview:_collectionView] ;
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
}


#pragma mark - UICollectionView 的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    return self.images.count+1 ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath] ;
    if(indexPath.row == 0)
    {
        cell.urlString = @"2011102267331457.jpg" ;
    }
    else
    {
        cell.urlString = self.images[indexPath.row - 1] ;
    }
    [cell setNeedsLayout] ;
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
//    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
//    // 3.通过模态视图弹出相册控制器（因为系统的相册控制器是导航控制器）
//    [self presentViewController:imagePickerVC animated:YES completion:nil];
//}
//
//#pragma mark -  相册对象的代理方法
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    // 获取点击的图片
//    UIImage *image = info[UIImagePickerControllerOriginalImage] ;
//    // 把图片设置到试图上
//    _bgviewImage.image = image ;
//    // 关闭相册控制器
//    [picker dismissViewControllerAnimated:YES completion:nil] ;
//}
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:nil] ;
//}
//
#pragma mark - rightBarButtonAction 右上角点击事件
- (void)rightAction:(UIBarButtonItem *)barButton
{
    EditPhotoViewController *editPhotoView = [[EditPhotoViewController alloc]init] ;
    editPhotoView.image = _bgviewImage.image ;
    [self.navigationController pushViewController:editPhotoView animated:YES] ;
}

@end
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
#import "MovieSecondViewController.h"
@interface DinggeTitleViewController (){
    
    NSString * str;
    NSString * icon;
    UIButton * firstbun;
}



@property MBProgressHUD *hud;
@property UIScrollView * scrollView;
@property UIButton *guanzhuBtn;
@property NSMutableArray * dataSource;
@property UIImageView * imageView;
@end

@implementation DinggeTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    str = [[NSString alloc]init];
    str = @"12";
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    // Set custom view mode
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.square = YES;//设置显示框的高度和宽度一样
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];

    self.hidesBottomBarWhenPushed = YES;
    self.title = [NSString stringWithFormat:@"标签：%@",self.tagTitle];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    
    firstbun = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    
    
    [self.view addSubview:firstbun];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
     UILabel *tagName = [[UILabel alloc] initWithFrame:CGRectMake(90,25, 200,20)];
    tagName.font = NameFont;
    [tagName setText:self.tagTitle];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSDictionary *parameters = @{@"name": self.tagTitle};
    [manager GET:TAG_API parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求返回,%@",responseObject);
        
        icon = responseObject[0][@"icon"];
        NSLog(@"11111111111%@",icon);
        
        if (icon==NULL) {
            
            firstbun.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            
            NSString *firstStr = [self.tagTitle substringToIndex:1];
            
            //判断是不是中文开头的
            BOOL isFirst = [self isChineseFirst:firstStr];
            if (isFirst)
                NSLog(@"第一个字符是中文开头的--%@", firstStr);
            else
            {
                //判断是不是字母开头的
                BOOL isA = [self MatchLetter:firstStr];
                if (isA)
                    NSLog(@"第一个是字母开头的--%@", firstStr);
                else
                    NSLog(@"--不是中文和字母开头的--%@",self.tagTitle);
            }
            [firstbun setTitle:firstStr forState:UIControlStateNormal];
            firstbun.titleLabel.textAlignment = NSTextAlignmentCenter;
            firstbun.titleLabel.textColor = [UIColor whiteColor];

        }else{
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 50, 50)];
       
        [image sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"movieCover.png"]];
        [self.view addSubview:image];
        }
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
    
    [self.view addSubview:tagName];
    
    UIImageView * jiantouimage = [[UIImageView alloc]initWithFrame:CGRectMake(33, 75, 5, 5)];
    jiantouimage.image = [UIImage imageNamed:@"jiantou1"];
    [self.view addSubview:jiantouimage];
    
    
    
    
    
    self.guanzhuBtn = [[UIButton alloc]initWithFrame:CGRectMake(wScreen-90,25, 70,25)];
    [self.guanzhuBtn.layer setMasksToBounds:YES];
    [self.guanzhuBtn.layer setCornerRadius:3.0]; //设置矩圆角半径
    [self.guanzhuBtn.layer setBorderWidth:0.6];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){254/255.0 ,153/255.0,0/255.0,1.0});
    [self.guanzhuBtn.layer setBorderColor:colorref];//边框颜色
      self.guanzhuBtn.backgroundColor = [UIColor clearColor];
    //[guanzhuBtn addTarget:self action:@selector(guanzhubtn:) forControlEvents:UIControlEventTouchUpInside];
     [self.guanzhuBtn setImage:[UIImage imageNamed:@"follow-mark@2x.png"] forState:UIControlStateNormal];
     [self.guanzhuBtn setTitle:@" 关注" forState:UIControlStateNormal];

    self.guanzhuBtn.titleLabel.font = NameFont;
    [self.guanzhuBtn setTitleColor:[UIColor colorWithRed:254/255.0 green:153/255.0 blue:0/255.0 alpha:1.0] forState: UIControlStateNormal];
    [self.guanzhuBtn addTarget:self action:@selector(followTag) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.guanzhuBtn];
   
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, wScreen, hScreen) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    [self setupHeader];
    [self setupFooter];
    
    [self viewDidLoadData];
   
}

-(void)viewDidLoadData{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    
     NSDictionary *parameters = @{@"name": self.tagTitle};
    [manager GET:TAG_API parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求返回,%@",responseObject);
        __weak DinggeTitleViewController *weakSelf = self;
        
        NSArray *arrModel = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject[0][@"posts"]];
        NSArray *follower = [UserModel mj_objectArrayWithKeyValuesArray:responseObject[0][@"follower"]];
//        icon = responseObject[0][@"icon"];
//        NSLog(@"11111111111%@",icon);
        
        self.tagId = responseObject[0][@"id"];
        weakSelf.dataSource = [arrModel mutableCopy];
        DingGeModel *model = arrModel[0];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"movieCover.png"]];
        for (UserModel *user in follower) {
            if ([user.userId isEqualToString:userId]) {
                [self.guanzhuBtn setImage:[UIImage imageNamed:@"followed-mark.png"] forState:UIControlStateNormal];
                [self.guanzhuBtn setTitle:@" 已关注" forState:UIControlStateNormal];
            }
        }
        [weakSelf.collectionView reloadData];
                [self.hud hide:YES afterDelay:1];
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
    
}

-(void)followTag
{
    NSLog(@"follow tag: %@",self.tagId);
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *url;
    if ([self.guanzhuBtn.titleLabel.text isEqualToString:@" 已关注"]) {
        url = [NSString stringWithFormat:@"%@/%@/unfollowTag/%@", BASE_API, userId, self.tagId];
    }else{
        url = [NSString stringWithFormat:@"%@/%@/followTag/%@", BASE_API, userId, self.tagId];
    }
    
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
              if ([self.guanzhuBtn.titleLabel.text isEqualToString:@" 已关注"]) {
                
                  [self.guanzhuBtn setImage:[UIImage imageNamed:@"follow-mark@2x.png"] forState:UIControlStateNormal];
                  [self.guanzhuBtn setTitle:@" 关注" forState:UIControlStateNormal];
                  self.hud.labelText = @"取消关注";
                  [self.hud show:YES];
                  [self.hud hide:YES afterDelay:2];
                  NSLog(@"取消关注成功,%@",responseObject);
              }else{
                  //修改按钮
                  [self.guanzhuBtn setImage:[UIImage imageNamed:@"followed-mark.png"] forState:UIControlStateNormal];
                  [self.guanzhuBtn setTitle:@" 已关注" forState:UIControlStateNormal];
                  self.hud.labelText = @"已关注";//显示提示
                  [self.hud show:YES];
                  [self.hud hide:YES afterDelay:2];
                  NSLog(@"关注成功,%@",responseObject);
                  
              }
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //[self.hud setHidden:YES];
              NSLog(@"请求失败,%@",error);
          }];
}


-(BOOL)MatchLetter:(NSString *)str
{
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:ZIMU] == YES)
        return YES;
    else
        return NO;
}

-(BOOL)isChineseFirst:(NSString *)firstStr
{
    //是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
  
    BOOL b = [firstStr getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5))
        return YES;
    else
        return NO;
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
    
    
    cell.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds  = YES;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"movieCover.png"]];
    
//    cell.title.text = model.movie.title;
    
    return cell;
}

//定义每个UICollectionView 的大小（返回CGSize：宽度和高度）
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return CGSizeMake((wScreen - 80)/3,80);
    
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
    dingge.hidesBottomBarWhenPushed = YES;
    DingGeModel *model = self.dataSource[indexPath.row];
    dingge.dingimage = model.image;
    dingge.DingID = model.ID;
    
     
    [self.navigationController pushViewController:dingge animated:YES];
    
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.collectionView];
    
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            
            [self viewDidLoadData];
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
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        
        NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":str};
        [manager GET:DINGGE_API parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        
        
        [self.collectionView reloadData];
        
        [self.refreshFooter endRefreshing];
        
        
        
    });
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

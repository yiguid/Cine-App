//
//  CineViewController.m
//  cine
//
//  Created by Guyi on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CineViewController.h"
#import "HMSegmentedControl.h"
#import "ShuoxiTableViewController.h"
#import "DinggeSecondViewController.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModelFrame.h"
#import "DingGeModel.h"
#import "MLStatus.h"
#import "MianMLStatusCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"


@interface CineViewController (){

    DingGeModel * DingGe;
    NSMutableArray * modelArr;
  
    
}
@property(nonatomic,retain)IBOutlet UITableView *dingge;
@property(nonatomic,retain)IBOutlet UITableView *shuoxi;
@property(nonatomic, strong)NSArray *statusFramesDingGe;
@property (nonatomic, strong) NSDictionary *dic;
@property NSMutableArray *dataSource;
@property MBProgressHUD *hud;

@end

@implementation CineViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add two table views
    //设置导航栏
    [self setNav];
    
    self.dingge.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.shuoxi.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在获取数据";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    [self.hud show:YES];
    
    self.dataSource = [[NSMutableArray alloc]init];
    [self loadData];
    [self loadDingGeData];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"定格", @"说戏"]];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.frame = CGRectMake(0, 0, 200, 30);
    segmentedControl.selectionIndicatorHeight = 3.0f;
    segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]};
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
    
    
    [DingGeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];

    modelArr = [NSMutableArray array];
    
    
    
    
    
  
    
}

- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://fl.limijiaoyin.com:1337/post";
    //NSString *urlstring = @"http://fl.limijiaoyin.com:1337/story";
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             modelArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             self.DingArr = responseObject;
             NSLog(@"2222------%@",self.DingArr[0][@"content"]);
             
             
             [self.dingge reloadData];
             
             
             [self.hud setHidden:YES];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
    

    
    
    
    
    
    
    
    
    //将dictArray里面的所有字典转成模型,放到新的数组里
    NSMutableArray *statusFrames = [NSMutableArray array];
        
    for (int i = 0; i < 10; i++ ) {
            
        //创建MLStatus模型
        DingGeModel *status = [[DingGeModel alloc]init];
        //status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
        
        status.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
        status.seeCount = @"600";
        status.zambiaCount = @"600";
        status.answerCount = @"50";
        status.movieName = @"<<泰囧>>";
        status.time = [NSString stringWithFormat:@"1小时前"];
        //创建MianDingGeModelFrame模型
        DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
        statusFrame.model = status;
        [statusFrame setModel:status];
        [statusFrames addObject:statusFrame];
       
            
    }
    self.statusFramesDingGe = statusFrames;
    
  }

/**
 * 设置导航栏
 */
- (void)setNav{
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]}];
}


- (void)loadData{
    for (int i = 0; i < 10; i++ ) {
        
        //创建MLStatus模型
        MLStatus *status = [[MLStatus alloc]init];
        status.text = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
        status.icon = [NSString stringWithFormat:@"avatar@2x.png"];
        status.name = [NSString stringWithFormat:@"哈哈哈"];
        status.vip = YES;
        status.picture = [NSString stringWithFormat:@"shuoxiImg.png"];
        status.daRenTitle = @"达人";
        status.mark = @"(著名编剧 导演 )";
        
    
        [self.dataSource addObject:status];

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
//    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    if (segmentedControl.selectedSegmentIndex == 1) {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        [self.dingge.layer addAnimation:animation forKey:nil];
        [self.shuoxi.layer addAnimation:animation forKey:nil];
        [self.dingge setHidden:YES];
        [self.shuoxi setHidden:NO];
    }
    else {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        [self.dingge.layer addAnimation:animation forKey:nil];
        [self.shuoxi.layer addAnimation:animation forKey:nil];
        [self.shuoxi setHidden:YES];
        [self.dingge setHidden:NO];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.dingge]) {
        return self.statusFramesDingGe.count;
    }
    else
        return 10;
   
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if ([tableView isEqual:self.dingge]) {
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置cell
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        
        NSString * string =self.DingArr[0][@"image"];
        
         [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        
        [imageView setImage:cell.movieImg.image];
        
        [cell.contentView addSubview:imageView];
        
      

        cell.message.text = self.DingArr[0][@"content"];
        //cell.movieName.text = self.DingArr[0][@""];
        //cell.nikeName.text = self.DingArr[0][@""];
       
        
        
        
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextControloler:)];
        
        [cell.contentView addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 2;
        
        return cell;
    }
    else {
        
        NSString *ID = [NSString stringWithFormat:@"DingGe"];
        MianMLStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[MianMLStatusCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }

        [cell setup:self.dataSource[indexPath.row]];


         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextControloler:)];
        
        [cell.contentView addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 1;
        
        return cell;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.dingge]) {
        DingGeModelFrame *statusFrame = self.statusFramesDingGe[indexPath.row];
        return statusFrame.cellHeight;

    }
    else{
       
        return 300;
    }
        
}


- (void) nextControloler: (id)sender{
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    
    UITapGestureRecognizer *tap = sender;
    long tapTag = [tap view].tag;
    
    if (tapTag == 1) {
        ShuoxiTableViewController *shuoxi = [[ShuoxiTableViewController alloc]init];
        shuoxi.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shuoxi animated:YES];
    }
    else{
        DinggeSecondViewController *dingge = [[DinggeSecondViewController alloc]init];
        dingge.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dingge animated:YES];
    }
}

//- (void) nextControllerWithTableView: (UITableView *)tableView WhitGesRecognizer: (UITapGestureRecognizer *)sender{
//    
//    
//    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
//    back.title = @"";
//    self.navigationItem.backBarButtonItem = back;
//    
//    
//  //  UITableView *tab = tableView;
//    UITapGestureRecognizer *tap = sender;
//    long tapTag = [tap view].tag;
//    
//    if ([tableView isEqual:self.dingge]) {
//        NSLog(@"定格------");
//    }
//    else{
//        if (tapTag == 1) {
//            ShuoxiTableViewController *shuoxi = [[ShuoxiTableViewController alloc]init];
//            [self.navigationController pushViewController:shuoxi animated:YES];
//        }
//    }
//    
//    
//    
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

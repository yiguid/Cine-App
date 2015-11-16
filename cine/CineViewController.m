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
#import "DinggeSecondTableViewController.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModelFrame.h"
#import "DingGeModel.h"
#import "MLStatus.h"
#import "MianMLStatusCell.h"



@interface CineViewController ()
@property(nonatomic,retain)IBOutlet UITableView *dingge;
@property(nonatomic,retain)IBOutlet UITableView *shuoxi;
@property(nonatomic, strong)NSArray *statusFramesDingGe;
@property NSMutableArray *dataSource;

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
    
    self.dataSource = [[NSMutableArray alloc]init];
    [self loadData];

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
}
-(NSArray *)statusFramesDingGe{
    if (_statusFramesDingGe == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *statusFrames = [NSMutableArray array];
      
        for (int i = 0; i < 10; i++ ) {
            
            //创建MLStatus模型
            DingGeModel *status = [[DingGeModel alloc]init];
            status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
            status.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
            status.nikeName = [NSString stringWithFormat:@"霍比特人"];
            status.movieImg = [NSString stringWithFormat:@"backImg.png"];
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
            _statusFramesDingGe = statusFrames;
    }
    return _statusFramesDingGe;
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
        status.picture = [NSString stringWithFormat:@"backImg.png"];
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
        //设置高度
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];

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
        DinggeSecondTableViewController *dingge = [[DinggeSecondTableViewController alloc]init];
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

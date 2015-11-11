//
//  CineViewController.m
//  cine
//
//  Created by Guyi on 15/11/5.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CineViewController.h"
#import "HMSegmentedControl.h"
#import "DingGeTableViewCell.h"
#import "ShuoXiTableViewCell.h"
#import "ShuoxiTableViewController.h"
#import "DinggeSecondTableViewController.h"



@interface CineViewController ()
@property(nonatomic,retain)IBOutlet UITableView *dingge;
@property(nonatomic,retain)IBOutlet UITableView *shuoxi;
@end

@implementation CineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //add two table views
//    self.dingge =
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]];
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
        return 10;
    }
    else
        return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if ([tableView isEqual:self.dingge]) {
        DingGeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DingGeCell" forIndexPath:indexPath];
//        if (!cell) {
//            cell = [[DingGeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DingGeCell"];
//        }
        // Configure the cell...
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        cell.nickname.text = @"修远";
        cell.content.text = @"这是我看过最好看的电影";
        cell.backImg.image = [UIImage imageNamed:@"backImg.png"];
        cell.avatarImg.image = [UIImage imageNamed:@"avatar.png"];
        cell.avatarImg.frame = CGRectMake(10, 200, 70, 70);
        
//        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextControloler:)];
        
        [cell.contentView addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 2;
        
        return cell;
    }
    else {
        ShuoXiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShuoXiCell" forIndexPath:indexPath];
        //        if (!cell) {
        //            cell = [[DingGeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DingGeCell"];
        //        }
        // Configure the cell...
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        cell.nickname.text = @"修远";
        cell.content.text = @"这是我看过最好看的电影";
        cell.backImg.image = [UIImage imageNamed:@"shuoxiImg.png"];
        cell.avatarImg.image = [UIImage imageNamed:@"avatar.png"];
        cell.avatarImg.frame = CGRectMake(10, 200, 70, 70);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextControloler:)];
        
        [cell.contentView addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 1;

        
        return cell;
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
        [self.navigationController pushViewController:shuoxi animated:YES];
    }
    else{
        DinggeSecondTableViewController *dingge = [[DinggeSecondTableViewController alloc]init];
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

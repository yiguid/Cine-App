//
//  AddPersonViewController.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "AddPersonViewController.h"
#import "HMSegmentedControl.h"
#import "GuanZhuTableViewCell.h"
#import "GuanZhuModel.h"
#import "MBProgressHUD.h"
#import "GuanZhuTableViewCell.h"
#import "TaTableViewController.h"
#import "UserModel.h"
#import "MJExtension.h"
#import "RestAPI.h"



@interface AddPersonViewController ()
@property (nonatomic)  UIView *yingjiang;
@property UITableView *yingmi;

@property MBProgressHUD *hud;
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableArray *user;


@end

@implementation AddPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0];

    self.yingjiang = [[UIView alloc]initWithFrame:CGRectMake(0 ,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self refreshYingjiang];
    [self setYj:self.yingjiang];
    self.yingmi = [[UITableView alloc]initWithFrame:CGRectMake(0 ,0,self.view.frame.size.width,self.view.frame.size.height)];
    self.yingmi.dataSource = self;
    self.yingmi.delegate = self;
    self.yingmi.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.yingjiang];
    [self.view addSubview:self.yingmi];
    [self.yingjiang setHidden:NO];
    [self.yingmi setHidden:YES];
    [self setNav];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //mjextension
    [UserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userId" : @"id"};
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;

}
#pragma 定义影匠界面
- (void) setYj:(UIView *)yingjiang{
    
    
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, wScreen - 40, 30)];
    topTitle.text = @"你可能感兴趣的人";
    topTitle.textAlignment = NSTextAlignmentCenter;
    [topTitle setTextColor:[UIColor lightGrayColor]];
    topTitle.font = NameFont;
    [yingjiang addSubview:topTitle];
    
    UILabel *bottomTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, hScreen - 120, wScreen - 60, 30)];
    bottomTitle.text = @"向左滑动看下一位,向右滑动添加关注";
    bottomTitle.textAlignment = NSTextAlignmentCenter;
    bottomTitle.font = NameFont;
    [bottomTitle setTextColor:[UIColor whiteColor]];
    bottomTitle.backgroundColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    bottomTitle.layer.masksToBounds = YES;
    bottomTitle.layer.cornerRadius = 6.0;
    [yingjiang addSubview:bottomTitle];    
    
}


- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.frontCardView.user.userId);
    } else {
        NSLog(@"You liked %@.", self.frontCardView.user.userId);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDef stringForKey:@"token"];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        NSString *url = [NSString stringWithFormat:@"%@/follow/%@", ME_API, self.frontCardView.user.userId];
        [manager POST:url parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"关注成功,%@",responseObject);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //             [self.hud setHidden:YES];
                 NSLog(@"请求失败,%@",error);
             }];

    }
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.yingjiang insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNav{

    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"影匠", @"影迷"]];
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


- (void)loadData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSString *url = @"http://fl.limijiaoyin.com:1337/auth";
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"catalog"] = @"0";
    [manager GET:USER_AUTH_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSArray *arrModel = [UserModel mj_objectArrayWithKeyValuesArray:responseObject];
             //NSLog(@"%@",responseObject);
             //             [self.hud setHidden:YES];
             //                 NSLog(@"----%@",arrModel);
//             for (UserModel *model in arrModel) {
//                 NSLog(model.nickname,nil);
//             }
             self.user = [arrModel mutableCopy];
             [self.yingmi reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //             [self.hud setHidden:YES];
             NSLog(@"请求失败,%@",error);
         }];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    //    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    if (segmentedControl.selectedSegmentIndex == 1) {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        [self.yingjiang.layer addAnimation:animation forKey:nil];
        [self.yingmi.layer addAnimation:animation forKey:nil];
        [self.yingmi setHidden:NO];
        [self.yingjiang setHidden:YES];
        self.yingmi.delegate = self;
        self.yingmi.dataSource = self;
        [self loadData];
    }
    else {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        [self.yingjiang.layer addAnimation:animation forKey:nil];
        [self.yingmi.layer addAnimation:animation forKey:nil];
        [self.yingjiang setHidden:NO];
        [self.yingmi setHidden:YES];
        [self refreshYingjiang];
    }
    
}
//更新图片
- (void) refreshYingjiang{
    NSLog(@"change yingjiang",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *url = @"http://fl.limijiaoyin.com:1337/auth";
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"catalog"] = @"1";
    [manager GET:USER_AUTH_API parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arrModel = [UserModel mj_objectArrayWithKeyValuesArray:responseObject];
        
//        NSLog(@"----%@",arrModel);
        
        self.people = [arrModel mutableCopy];
        //左右滑动
        [self.frontCardView removeFromSuperview];
        [self.backCardView removeFromSuperview];
        //
        self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
        [self.yingjiang addSubview:self.frontCardView];
        
        //
        //        // Display the second ChoosePersonView in back. This view controller uses
        //        // the MDCSwipeToChooseDelegate protocol methods to update the front and
        //        // back views after each user swipe.
        
        self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
        [self.yingjiang insertSubview:self.backCardView belowSubview:self.frontCardView];
        
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.user.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.yingmi]) {
        GuanZhuTableViewCell *cell = [[GuanZhuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DingGeCell"];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"DingGeCell" forIndexPath:indexPath];
        }
        UserModel *user = self.user[indexPath.row];
        cell.model.userId = user.userId;
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        cell.nickname.text = user.nickname;
        cell.content.text = user.city;
        cell.avatarImg.image = [UIImage imageNamed:@"avatar.png"];
        cell.rightBtn.image = [UIImage imageNamed:@"follow-mark.png"];
        
        UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(followPerson:)];
        
        [cell.rightBtn addGestureRecognizer:imgTap];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yingmiController)];
        
        [cell.contentView addGestureRecognizer:tap];
        return cell;
    }
    return nil;
}

- (void) followPerson :(UITapGestureRecognizer *)recognizer{
    GuanZhuTableViewCell *view = (GuanZhuTableViewCell *)[(UIImageView *)recognizer.view superview];
    NSLog(@"follow---- %@",view.model.userId);
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void) yingmiController{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    
    TaTableViewController *ta = [[TaTableViewController alloc]init];
    [self.navigationController pushViewController:ta animated:YES];
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 50.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.yingjiang.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.yingjiang.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame {
    if ([self.people count] == 0) {
        return nil;
    }
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
//    options.onPan = ^(MDCPanState *state){
//        CGRect frame = [self backCardViewFrame];
//        self.backCardView.frame = CGRectMake(frame.origin.x,
//                                             frame.origin.y - (state.thresholdRatio * 10.f),
//                                             CGRectGetWidth(frame),
//                                             CGRectGetHeight(frame));
//    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    ChoosePersonView *movieView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                  movie:self.people[0]
                                                                options:options];
    [self.people removeObjectAtIndex:0];
    return movieView;
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

//
//  TuijianViewController.m
//  cine
//
//  Created by wang on 16/1/27.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "TuijianViewController.h"
#import "HMSegmentedControl.h"
#import "GuanZhuTableViewCell.h"
#import "GuanZhuModel.h"
#import "MBProgressHUD.h"
#import "GuanZhuTableViewCell.h"
#import "UserModel.h"
#import "MJExtension.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
#import "TaViewController.h"
@interface TuijianViewController (){
    
    NSMutableArray * arrModel;
}
@property (nonatomic)  UIView *yingjiang;

@property MBProgressHUD *hud;
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableArray *user;

@end

@implementation TuijianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0];
    
    self.yingjiang = [[UIView alloc]initWithFrame:CGRectMake(0 ,0,self.view.frame.size.width,self.view.frame.size.height)];
    self.yingjiang.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    
    [self refreshYingjiang];
    [self setYj:self.yingjiang];
   
    [self.view addSubview:self.yingjiang];
    [self.yingjiang setHidden:NO];

   
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //mjextension
    [UserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userId" : @"id"};
    }];
    arrModel = [NSMutableArray array];
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //    self.tabBarController.tabBar.hidden = YES;
    
}
#pragma 定义影匠界面
- (void) setYj:(UIView *)yingjiang{
    
    
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, wScreen - 40, 30)];
    topTitle.text = @"你可能感兴趣的人";
    topTitle.textAlignment = NSTextAlignmentCenter;
    [topTitle setTextColor:[UIColor lightGrayColor]];
    topTitle.font = NameFont;
    [yingjiang addSubview:topTitle];
    
  
}


- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
  
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
    options.threshold = 60.f;
    options.likedText = @"";
    options.likedColor = [UIColor clearColor];
    options.nopeText = @"";
    options.nopeColor = [UIColor clearColor];
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    
    ChoosePersonView * personview = [[ChoosePersonView alloc] initWithFrame:frame
                                                                      movie:self.people[0]
                                                                    options:options];
    
    
    UITapGestureRecognizer *btnTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectionperson:)];
    
    [personview.PersonBtn addGestureRecognizer:btnTap];
    
    UserModel *user = [self.people objectAtIndex:0];
    
    [self.people removeObjectAtIndex:0];
    
    [self.people addObject:user];
    
    return personview;
}





- (void) collectionperson :(UIImageView *)sender{
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    for (UserModel * model in self.people) {
        
        if ([userId isEqual:model.userId]) {
            
            
            
        }else{
            
            
            self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:self.hud];
            // Set custom view mode
            self.hud.mode = MBProgressHUDModeCustomView;
            
            self.hud.labelText = @"已关注";//显示提示
            self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
            
            
            NSLog(@"You liked %@.", self.frontCardView.user.userId);
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSString *token = [userDef stringForKey:@"token"];
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
            NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
            NSString *url = [NSString stringWithFormat:@"%@/%@/follow/%@", BASE_API, userId, self.frontCardView.user.userId];
            [manager POST:url parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"关注成功,%@",responseObject);
                      
                      [self.hud show:YES];
                      [self.hud hide:YES afterDelay:1];
                      
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      //             [self.hud setHidden:YES];
                      NSLog(@"请求失败,%@",error);
                  }];
            
            
            
            
        }
    }
    
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) refreshYingjiang{
    NSLog(@"change yingjiang",nil);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"movie":self.movieID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * arrmodel = [UserModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        //        NSLog(@"----%@",arrModel);
        
        self.people = [arrmodel mutableCopy];
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




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end

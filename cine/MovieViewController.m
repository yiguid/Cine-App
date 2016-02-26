//
//  SecondViewController.m
//  cine
//
//  Created by Guyi on 15/10/27.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MovieViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MovieModel.h"
#import "MJExtension.h"
#import "MovieSecondViewController.h"
#import "RestAPI.h"
#import "RecModel.h"
//static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
//static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;


@interface MovieViewController () <ChooseMovieViewDelegate>
@property MBProgressHUD *hud;
@property (nonatomic,strong) NSMutableArray *people;
@property(nonatomic,strong) NSArray *movies;
@property(nonatomic,copy) NSString *frontMovieId;
@property(nonatomic,copy) NSString *frontMovieName;
@property(nonatomic,assign) BOOL isFirstLoad;
@property(nonatomic,assign) BOOL isFirstChoosePersonView;
@property(nonatomic,strong) NSArray * tuijianarr;
@property(nonatomic,strong) NSArray * shoucangarr;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNev];
    
    self.movies = [NSArray array];
  //  self.title = @"找影片";
    // Do any additional setup after loading the view, typically from a nib.
    _hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示

    
    self.view.backgroundColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
    
    [MovieModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    
   
   //[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];

//    //左右滑动
//    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
//    [self.view addSubview:self.frontCardView];
//    // Display the second ChoosePersonView in back. This view controller uses
//    // the MDCSwipeToChooseDelegate protocol methods to update the front and
//    // back views after each user swipe.
//    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
//    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
//    [self constructNopeButton];
//    [self constructLikedButton];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (self.isFirstLoad == NO) {
        [self changePicture];
        self.isFirstLoad = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    MovieViewController * movie = [[MovieViewController alloc]init];
    
    movie.hidesBottomBarWhenPushed =  NO;

}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    
    
    
    
//    if (direction == MDCSwipeDirectionLeft) {
//        NSLog(@"You noped %@.", self.frontMovieId);
//    } else {
//        NSLog(@"You liked %@.", self.frontMovieId);
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//        NSString *token = [userDef stringForKey:@"token"];
//        NSString *userId = [userDef stringForKey:@"userID"];
//        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
//        NSString *url = [NSString stringWithFormat:@"%@/%@/favorite/%@", BASE_API,userId,self.frontMovieId];
//        NSLog(@"收藏电影%@",url);
//        [manager POST:url parameters:nil
//              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                  NSLog(@"收藏成功,%@",responseObject);
//                  
//              }
//              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                  //             [self.hud setHidden:YES];
//                  NSLog(@"请求失败,%@",error);
//              }];
//    }
    
    
    
    //左右滑动
//    [self.frontCardView removeFromSuperview];
//    [self.backCardView removeFromSuperview];
//
//    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
//    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    
    self.frontCardView = self.backCardView;
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontMovieId = self.frontCardView.movie.ID;
    self.frontMovieName = self.frontCardView.movie.title;

    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
       [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

- (void)setNev{
    
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]}];
    
//    UIBarButtonItem *changePic = [[UIBarButtonItem alloc]initWithTitle:@"换一批" style:UIBarButtonItemStylePlain target:self action:@selector(changePicture)];
//    
//    self.navigationItem.rightBarButtonItem = changePic;
    
   
    
}


- (void) changePicture{
    NSLog(@"change movie",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    ///auth/:authId/favroiteMovies
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    NSString *url1 = [NSString stringWithFormat:@"%@/%@/favoriteMovies",USER_AUTH_API, userId];
    [manager GET:url1 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求返回,%@",responseObject);
       self.shoucangarr = [MovieModel mj_objectArrayWithKeyValuesArray:responseObject];
     
      
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/hasRecommends",MOVIE_API];
    
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    
//    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//       param[@"searchText"] = @"";
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arrModel = [MovieModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        //NSLog(@"----%@",arrModel);
        NSMutableArray *movieArray = [NSMutableArray array];
        
        
        for (MovieModel *model in arrModel) {
            MovieModel *movieModel = [[MovieModel alloc]init];
            movieModel = model;
            
            [movieArray addObject:movieModel];
            
        }
        
        NSInteger i = [movieArray count];
        while(--i > 0) {
            NSInteger j = rand() % (i+1);
            [movieArray exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        self.movies = movieArray;
        NSMutableArray *nsarr = [NSMutableArray array];
        
        for (MovieModel *model in self.movies) {
            
            MovieModel *movieModel = [[MovieModel alloc]init];
            
            movieModel = model;
            NSString *cover = [movieModel.screenshots[0] stringByReplacingOccurrencesOfString:@"albumicon" withString:@"photo"];

            
            movieModel.cover = cover;
            [nsarr addObject:movieModel];
        }
        
        for (MovieModel * model in self.shoucangarr) {
            [nsarr removeObject:model];
        }
        
        
        self.people = nsarr;
        //左右滑动
        [self.frontCardView removeFromSuperview];
        [self.backCardView removeFromSuperview];
//
        self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
        [self.view addSubview:self.frontCardView];
        self.frontMovieId = self.frontCardView.movie.ID;
        self.frontMovieName = self.frontCardView.movie.title;
        
//
//        // Display the second ChoosePersonView in back. This view controller uses
//        // the MDCSwipeToChooseDelegate protocol methods to update the front and
//        // back views after each user swipe.
        
            self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
            [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
     
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 10.f;
//    CGFloat bottomPadding = 200.f;
//    return CGRectMake(horizontalPadding,
//                      topPadding,
//                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
//                      CGRectGetHeight(self.view.frame) - bottomPadding);
    return CGRectMake(horizontalPadding+30, topPadding+40, wScreen - (horizontalPadding * 2)-60, hScreen - 220);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}




- (ChooseMovieView *)popPersonViewWithFrame:(CGRect)frame {
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
    options.nopeText = @"";
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };

    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    
    ChooseMovieView *movieView = [[ChooseMovieView alloc] initWithFrame:frame
                                                                  movie:self.people[0]
                                                                options:options];
    
    movieView.delegate = self;
    
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController)];
    
    [movieView addGestureRecognizer:imgTap];
    
    UITapGestureRecognizer *btnTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectionMovie:)];
    
    [movieView.collectionButton addGestureRecognizer:btnTap];
    
    MovieModel *movie = [self.people objectAtIndex:0];
    
    [self.people removeObjectAtIndex:0];
    
    [self.people addObject:movie];
    
    return movieView;
}

- (void) collectionMovie :(UIImageView *)sender{
    
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
        // Set custom view mode
    self.hud.mode = MBProgressHUDModeCustomView;
 
    self.hud.labelText = @"已收藏";//显示提示
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];
  
    NSLog(@"favourite---- %@ | %@",self.frontMovieId, self.frontMovieName);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/favorite/%@", BASE_API,userId,self.frontMovieId];
    NSLog(@"收藏电影%@",url);
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"收藏成功,%@",responseObject);
//              for (NSDictionary * dic in responseObject) {
//                  
//              }
              
              
              
              [self.hud show:YES];
              [self.hud hide:YES afterDelay:1];
              
              [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];

              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
     //[self.hud setHidden:YES];

}
#pragma 电影图片代理

- (void)chooseMovieView:(ChooseMovieView *)chooseMovieView withMovieName:(NSString *)name withId:(NSString *)Id{
    
    
    MovieSecondViewController *movieController = [[MovieSecondViewController alloc]init];
    
    movieController.name = name;
    movieController.ID = Id;
    
    movieController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:movieController animated:YES];

}

-(void)nextController{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    
    back.title = @"";
    
    self.navigationItem.backBarButtonItem = back;
    
    
    [self chooseMovieView:nil withMovieName: self.frontMovieName withId:self.frontMovieId];
}


#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
//- (void)viewDidCancelSwipe:(UIView *)view {
//   // NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
//}



#pragma mark Control Events

// Programmatically "nopes" the front card view.
//- (void)nopeFrontCardView {
//    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
//}

// Programmatically "likes" the front card view.
//- (void)likeFrontCardView {
//    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
//}


@end

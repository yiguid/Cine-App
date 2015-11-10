//
//  AddPersonViewController.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "AddPersonViewController.h"
#import "HMSegmentedControl.h"
#import "DingGeTableViewCell.h"
#import "GuanZhuTableViewCell.h"
#import "GuanZhuModel.h"
#import "MBProgressHUD.h"
#import "GuanZhuTableViewCell.h"
#import "AddPersonTableViewCell.h"



static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;


@interface AddPersonViewController ()
@property UITableView *yingjiang;
@property UITableView *yingmi;

@property MBProgressHUD *hud;
@property (nonatomic, strong) NSMutableArray *people;


@end

@implementation AddPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.yingmi.dataSource = self;
    
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 100.f;
    CGFloat bottomPadding = 200.f;
//    
    UITableView *tabyj = [[UITableView alloc]initWithFrame:CGRectMake(0 ,0,self.view.frame.size.width,self.view.frame.size.height)];
    
    self.yingjiang = tabyj;
 //   [self.yingjiang addSubview:tabyj];
    
//    UITableView *tabym = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    self.yingmi = tabym;
   // [self.yingmi addSubview:tabym];
   
    
  //  [self selectView:nil];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self setNav];
}

- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentPerson.name);
    } else {
        NSLog(@"You liked %@.", self.currentPerson.name);
    }
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNav{
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
 //   [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]];
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

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    //    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    if (segmentedControl.selectedSegmentIndex == 1) {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        [self.yingjiang.layer addAnimation:animation forKey:nil];
        [self.yingmi.layer addAnimation:animation forKey:nil];
        [self.yingjiang setHidden:YES];
        [self.yingmi setHidden:NO];
    }
    else {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        [self.yingjiang.layer addAnimation:animation forKey:nil];
        [self.yingmi.layer addAnimation:animation forKey:nil];
        [self.yingmi setHidden:YES];
        [self.yingjiang setHidden:NO];
    }
 //   [self selectView:segmentedControl];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.yingjiang]) {
        return 1;
    }
    else{
        return 20;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.yingjiang]) {
        
        [self selectView:nil];
//        AddPersonTableViewCell *cell = [[AddPersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddPerson"];
////                if (!cell) {
////                    cell = [tableView dequeueReusableCellWithIdentifier:@"DingGeCell" forIndexPath:indexPath];
////                }
//        // Configure the cell...
//        
//        CGFloat horizontalPadding = 20.f;
//        CGFloat topPadding = 100.f;
//        CGFloat bottomPadding = 200.f;
//        
//        UIView *yj = [[UIView alloc]initWithFrame:CGRectMake(0 ,0,CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),CGRectGetHeight(self.view.frame) - bottomPadding)];
////        cell.imgView = yj;
//        
// //       [cell.imgView addSubview:yj];
//
// //       [self.view addSubview:yj];
//        
//        self.yingjiang = yj;
//        
//        self.people = [[self defaultPeople] mutableCopy];
//        
//        //   左右滑动
//        self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
//        [self.yingjiang addSubview:self.frontCardView];
//        self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
//        [self.yingjiang insertSubview:self.backCardView belowSubview:self.frontCardView];
//
//        
//        return cell;
        
        
    }
    else {
        GuanZhuTableViewCell *cell = [[GuanZhuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DingGeCell"];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"DingGeCell" forIndexPath:indexPath];
        }
        // Configure the cell...
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        cell.nickname.text = @"修远111111";
        cell.content.text = @"这是我看过最好看的电影";
        cell.avatarImg.image = [UIImage imageNamed:@"avatar.png"];
        cell.rightBtn.image = [UIImage imageNamed:@"cine@2x.png"];

        return cell;

    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UIView *)selectView :(id)sender{
    HMSegmentedControl *seg = (HMSegmentedControl *)sender;
    
    int index = seg.selectedSegmentIndex;
    
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 100.f;
    CGFloat bottomPadding = 200.f;
    
    if (index  == 0) {
        
//        if (self.yingjiang == nil) {
//            UIView *yj = [[UITableView alloc]initWithFrame:CGRectMake(0 ,0,self.view.frame.size.width,self.view.frame.size.height)];
//            [self.view addSubview:yj];
//            
//            self.yingjiang = yj;
//        }
        
          
        self.people = [[self defaultPeople] mutableCopy];
        
   //     左右滑动
        self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
        [self.view addSubview:self.frontCardView];
        self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];

        
    }
    return nil;
}


#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 100.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}


#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}




- (NSArray *)defaultPeople {
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    return @[
             [[Person alloc] initWithName:@"Finn"
                                   image:[UIImage imageNamed:@"finn"]
                                     age:18
                   numberOfSharedFriends:10
                 numberOfSharedInterests:20
                          numberOfPhotos:10],
             [[Person alloc] initWithName:@"Jake"
                                   image:[UIImage imageNamed:@"jake"]
                                     age:28
                   numberOfSharedFriends:2
                 numberOfSharedInterests:6
                          numberOfPhotos:8],
             [[Person alloc] initWithName:@"Fiona"
                                   image:[UIImage imageNamed:@"fiona"]
                                     age:14
                   numberOfSharedFriends:1
                 numberOfSharedInterests:3
                          numberOfPhotos:5],
             [[Person alloc] initWithName:@"P. Gumball"
                                   image:[UIImage imageNamed:@"prince"]
                                     age:18
                   numberOfSharedFriends:1
                 numberOfSharedInterests:1
                          numberOfPhotos:2],
             ];
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

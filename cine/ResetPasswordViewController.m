//
//  ResetPasswordViewController.m
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition* interactionController;
@end

@implementation ResetPasswordViewController

//@synthesize rightSwipeGestureRecognizer;

- (void)modifyUITextField: (UITextField *) textField {
    CGRect rect = textField.frame;
    rect.size.height = 50;
    textField.frame = rect;
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)modifyUIButton: (UIButton *) button {
    button.backgroundColor = [UIColor grayColor];
    CGRect rect = button.frame;
    rect.size.height = 50;
    button.frame = rect;
    button.layer.cornerRadius = 6.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self modifyUITextField: self.password];
    [self modifyUIButton:self.resetBtn];
    [self modifyUITextField: self.mobile];
    [self modifyUIButton:self.nextBtn];
    [self modifyUITextField:self.captcha];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];

}
//
//- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
//{
//    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
//        NSLog(@"right",nil);
//        if (!self.navigationController || [self.navigationController.viewControllers count] != 1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//}

- (void)viewDidAppear:(BOOL)animated{
    //*************方法二*****************//
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGestureRecognizer.delegate = self;
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
}

#pragma mark- private method
//*************方法二*****************//
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer*)recognizer{
    NSLog(@"pop",nil);
    
    UIView *view = self.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // 获取手势的触摸点坐标
        CGPoint location = [recognizer locationInView:view];
        // 判断,用户从右半边滑动的时候,推出下一个VC(根据实际需要是推进还是推出)
        if (location.x > CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count == 1){
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
            //
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // 获取手势在视图上偏移的坐标
        CGPoint translation = [recognizer translationInView:view];
        // 根据手指拖动的距离计算一个百分比，切换的动画效果也随着这个百分比来走
        CGFloat distance = fabs(translation.x / CGRectGetWidth(view.bounds));
        // 交互控制器控制动画的进度
        [self.interactionController updateInteractiveTransition:distance];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [recognizer translationInView:view];
        // 根据手指拖动的距离计算一个百分比，切换的动画效果也随着这个百分比来走
        CGFloat distance = fabs(translation.x / CGRectGetWidth(view.bounds));
        // 移动超过一半就强制完成
        if (distance > 0.5) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        // 结束后一定要置为nil
        self.interactionController = nil;
    }
}

#pragma mark- UIGestureRecognizerDelegate
//**************方法二****************//
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)resetPassword:(id)sender {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush]; //淡入淡出kCATransitionFade
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScene"];
    self.view.window.rootViewController = loginVC;
}

- (IBAction)backToLogin:(id)sender {
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScene"];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush]; //淡入淡出kCATransitionFade
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    self.view.window.rootViewController = loginVC;

//    [UIView transitionFromView:self.view.window.rootViewController.view
//                        toView:loginVC.view
//                      duration:0.5
//                       options:UIViewAnimationOptionTransitionCurlUp
//                    completion:^(BOOL finished)
//    {
//        self.view.window.rootViewController = loginVC;
//    }];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end







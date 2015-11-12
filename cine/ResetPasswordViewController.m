//
//  ResetPasswordViewController.m
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "UIBackAnimation.h"

@interface ResetPasswordViewController ()
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;
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
//    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(backGesture:)];
//    gesture.delegate = self;
//    gesture.edges = UIRectEdgeLeft;
    //[self.view addGestureRecognizer:gesture];
//    self.navigationController.delegate = self;
//    self.transitioningDelegate = self;
    //加下面这一句就可以找回自定义返回按钮后，右滑返回的手势了
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 我不再是 navigationController 的代理啦
//    if (self.navigationController.delegate == self) {
//        self.navigationController.delegate = nil;
//    }
}

//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                  animationControllerForOperation:(UINavigationControllerOperation)operation
//                                               fromViewController:(UIViewController *)fromVC
//                                                 toViewController:(UIViewController *)toVC {
//    // 检查一下是不是过渡到DSLSecondViewController
//    return [[UIBackAnimation alloc] init];
//}

//- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
//                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
//    return self.percentDrivenTransition;
//}

#pragma mark- private method
//*************方法二*****************//
- (void)backGesture:(UIScreenEdgePanGestureRecognizer*)recognizer{
    //计算手指滑的物理距离（滑了多远，与起始位置无关）
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));//把这个百分比限制在0~1之间
    
    //当手势刚刚开始，我们创建一个 UIPercentDrivenInteractiveTransition 对象
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        //当手慢慢划入时，我们把总体手势划入的进度告诉 UIPercentDrivenInteractiveTransition 对象。
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
        //当手势结束，我们根据用户的手势进度来判断过渡是应该完成还是取消并相应的调用 finishInteractiveTransition 或者 cancelInteractiveTransition 方法.
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        }else{
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
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







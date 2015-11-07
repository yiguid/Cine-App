//
//  AboutCineViewController.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "AboutCineViewController.h"

@interface AboutCineViewController ()

@end

@implementation AboutCineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewW = self.view.frame.size.width;
    CGFloat btnW = 80;
    CGFloat btnH = 90;
    CGFloat edge = (viewW -btnW);
    
    
    
    UIButton *titBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewW / 2 - 40, 120, btnW, btnW)];
  //  [titBtn setImage:[UIImage imageNamed:@"follows.png"] forState:UIControlStateNormal];
    titBtn.backgroundColor = [UIColor blackColor];
    titBtn.layer.masksToBounds = YES;
    titBtn.layer.cornerRadius = 8.0;
    
    titBtn.enabled = NO;
    [self.view addSubview:titBtn];
    
    UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(viewW / 2 - 40, 120 + btnW, btnW, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    [title setText:@"关于cine"];
    [self.view addSubview:title];
    
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 170 + btnW, viewW - 20, 300)];
    textView.text = @"hhhhhhhhhhhhhhhhhhhhhhh";
    textView.textAlignment = NSTextAlignmentLeft; //水平居中
    textView.editable = NO;
    [self.view addSubview:textView];
   
    
    
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

@end

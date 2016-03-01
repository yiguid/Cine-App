//
//  AboutCineViewController.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "AboutCineViewController.h"

@interface AboutCineViewController (){

    UIWebView * webView;
}

@end

@implementation AboutCineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"关于影迷圈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewW = self.view.frame.size.width;
    CGFloat btnW = 80;

    
    UIButton *titBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewW / 2 - 40, 30, btnW, btnW)];
    titBtn.backgroundColor = [UIColor colorWithRed:250.0/255 green:205.0/255 blue:0 alpha:1.0];
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(viewW/2-30, 40, btnW-20, btnW-20)];
    imageview.image = [UIImage imageNamed:@"icon-180.png"];
    [titBtn bringSubviewToFront:imageview];
    titBtn.layer.masksToBounds = YES;
    titBtn.layer.cornerRadius = 8.0;
    
    titBtn.enabled = NO;
    [self.view addSubview:titBtn];
    [self.view addSubview:imageview];
    
    UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(viewW / 2 - 40, 40 + btnW, btnW, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    [title setText:@"影迷圈"];
    [self.view addSubview:title];
    
    
     UIWebView *textView = [[UIWebView alloc]initWithFrame:CGRectMake(10,80 + btnW, viewW - 20,hScreen/2)];
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%@",TimeFont];
    [textView stringByEvaluatingJavaScriptFromString:jsString];

    [self.view addSubview:textView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"产品介绍.rtf" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [textView loadRequest:request];

    
    
    
    
    UIButton * negotiate = [[UIButton alloc]initWithFrame:CGRectMake(20,hScreen/2+170, self.view.frame.size.width - 40, 30)];
    negotiate.backgroundColor = [UIColor grayColor];
    [negotiate setTitle:@"影迷圈软件许可及服务协议" forState:UIControlStateNormal];
    [negotiate addTarget:self action:@selector(negotiaate) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:negotiate];
    
}

-(void)negotiaate{
    
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen-64)];
    [self.view addSubview:webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"服务协议.rtf" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = YES;
    
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

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
    
    UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(viewW / 2 - 40,30 + btnW, btnW, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    [title setText:@"影迷圈"];
    title.font = XiaoxiFont;
    [self.view addSubview:title];
    
    
//     UIWebView *textView = [[UIWebView alloc]initWithFrame:CGRectMake(10,80 + btnW, viewW - 20,hScreen/2)];
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%@",TimeFont];
//    [textView stringByEvaluatingJavaScriptFromString:jsString];
//
//    [self.view addSubview:textView];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"产品介绍.rtf" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [textView loadRequest:request];
    UILabel * textlable1 = [[UILabel alloc]initWithFrame:CGRectMake(10,80+btnW,viewW-20,20)];
    textlable1.text = @"影迷圈——你的电影朋友圈";
    textlable1.font = NameFont;
    textlable1.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    [self.view addSubview:textlable1];
    UILabel * textlable2 = [[UILabel alloc]initWithFrame:CGRectMake(10,100+btnW,viewW-20,60)];
    textlable2.text = @"在这里，你不仅会发现有料的电影内容、趣味相投的影友，还可以接触到以往深藏不露的幕后匠人——没准你喜欢的电影就出自Ta手！";
    textlable2.font = NameFont;
    textlable2.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    textlable2.numberOfLines = 0;
    [self.view addSubview:textlable2];
    UILabel * textlable3 = [[UILabel alloc]initWithFrame:CGRectMake(10,160+btnW,viewW-20,20)];
    textlable3.text = @"功能";
    textlable3.font = NameFont;
    textlable3.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    [self.view addSubview:textlable3];
    UILabel * textlable4 = [[UILabel alloc]initWithFrame:CGRectMake(10,180+btnW,viewW-20,40)];
    textlable4.text = @"定格：和影友们一起发现/分享电影中的瞬间，通过“标签”来赞美/吐槽。";
    textlable4.font = NameFont;
     textlable4.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    textlable4.numberOfLines = 0;
    [self.view addSubview:textlable4];
    UILabel * textlable5 = [[UILabel alloc]initWithFrame:CGRectMake(10,220+btnW,viewW-20,40)];
    textlable5.text = @"说戏：来看看幕后工作者、电影行家们如何点评一部电影。";
    textlable5.font = NameFont;
     textlable5.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    textlable5.numberOfLines = 0;
    [self.view addSubview:textlable5];
    UILabel * textlable6 = [[UILabel alloc]initWithFrame:CGRectMake(10,260+btnW,viewW-20,40)];
    textlable6.text = @"发现：这里有电影匠人（制片专业人士）挑选推荐的影片，兼顾品质与品味。";
    textlable6.font = NameFont;
    textlable6.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    textlable6.numberOfLines = 0;
    [self.view addSubview:textlable6];
    
    
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
